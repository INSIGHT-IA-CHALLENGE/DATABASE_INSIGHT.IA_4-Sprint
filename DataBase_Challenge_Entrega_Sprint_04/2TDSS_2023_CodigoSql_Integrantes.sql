SET SERVEROUTPUT ON;

--1) Empacotando as Procedures


  -- Package - Procedure de listar Transações dos usuários
CREATE OR REPLACE PACKAGE pkg_transacoes AS
  PROCEDURE listar_transacoes_usuario(v_id_usuario NUMBER);

END pkg_transacoes;
/

-- Package Body - Procedure de listar Transações dos usuários
CREATE OR REPLACE PACKAGE BODY pkg_transacoes AS
  PROCEDURE listar_transacoes_usuario(
    v_id_usuario NUMBER)
  IS
    v_id_transacao NUMBER;
    v_ds_titulo VARCHAR2(20);
  BEGIN
    v_id_transacao := NULL;
    v_ds_titulo := NULL;

    BEGIN
      SELECT id_transacao, ds_titulo
      INTO v_id_transacao, v_ds_titulo
      FROM t_insightia_transacao
      WHERE id_usuario = v_id_usuario;

      DBMS_OUTPUT.PUT_LINE('ID Transação: ' || v_id_transacao || ', Título: ' || v_ds_titulo);

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhuma informação encontrada para o usuário');
    END;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
  END listar_transacoes_usuario;

END pkg_transacoes;
/


-- Package - Listar anúncios ativos
CREATE OR REPLACE PACKAGE pkg_anuncios AS
  PROCEDURE sp_relatorio_anuncios_ativos(p_id_usuario NUMBER);
END pkg_anuncios;
/

-- Package Body - Listar anúncios ativos
CREATE OR REPLACE PACKAGE BODY pkg_anuncios AS
  PROCEDURE sp_relatorio_anuncios_ativos(p_id_usuario NUMBER) 
  IS
    v_id_anuncio NUMBER;
    v_ds_descricao VARCHAR2(100);
  BEGIN
    BEGIN
      SELECT id_anuncio, ds_descricao
      INTO v_id_anuncio, v_ds_descricao
      FROM t_insightia_anuncio
      WHERE id_usuario = p_id_usuario AND sg_ativo = 'S';

      DBMS_OUTPUT.PUT_LINE('ID do Anúncio: ' || v_id_anuncio);
      DBMS_OUTPUT.PUT_LINE('Descrição: ' || v_ds_descricao);

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum anúncio ativo encontrado para o usuário');
    END;
  END sp_relatorio_anuncios_ativos;
END pkg_anuncios;
/

--1.1) Empacotando as Funções


-- Package - Funções relacionadas ao cálculo de bônus
CREATE OR REPLACE PACKAGE pkg_func_cancular_bonus AS
  FUNCTION calcular_bonus(p_id_usuario NUMBER, p_valor_inserido NUMBER)
  RETURN NUMBER;
END pkg_func_cancular_bonus;
/

CREATE OR REPLACE PACKAGE BODY pkg_func_cancular_bonus AS
  FUNCTION calcular_bonus(
    p_id_usuario NUMBER,
    p_valor_inserido NUMBER
  ) RETURN NUMBER 
  IS
    v_bonus NUMBER := 0.05; -- Bônus de 5%
    v_valor_bonus NUMBER;

  BEGIN
    -- Verificar se o usuário existe
    SELECT 1
    INTO v_valor_bonus
    FROM t_insightia_usuario
    WHERE id_usuario = p_id_usuario;

    -- Calcular o valor do bônus
    v_valor_bonus := (p_valor_inserido) + (p_valor_inserido * v_bonus);

    -- Atualizar o saldo do usuário com o bônus calculado
    UPDATE t_insightia_usuario
    SET nr_saldo = nr_saldo + v_valor_bonus
    WHERE id_usuario = p_id_usuario;

    -- Retornar o valor do bônus calculado
    RETURN v_valor_bonus;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Usuário não encontrado.');
        RETURN NULL; -- Retornar NULL em caso de usuário não encontrado
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
        RETURN NULL; -- Retornar NULL em caso de erro
    
    END calcular_bonus;
    
END pkg_func_cancular_bonus;
/


-- Package Body - Funções relacionadas à contagem de anúncios ativos
CREATE OR REPLACE PACKAGE pkg_func_cont_anuncios AS
  FUNCTION contar_anuncios_ativos RETURN NUMBER;
END pkg_func_cont_anuncios;
/

CREATE OR REPLACE PACKAGE BODY pkg_func_cont_anuncios AS
  FUNCTION contar_anuncios_ativos 
  RETURN NUMBER 
  IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count
    FROM t_insightia_anuncio
    WHERE sg_ativo = 'Y';

    RETURN v_count;
  END contar_anuncios_ativos;
END pkg_func_cont_anuncios;
/



--2) Criar gatilhos


-- Gatilho para auditar operações de DELETE na tabela t_insightia_insight
CREATE OR REPLACE TRIGGER trg_auditoria_delete_insight
AFTER DELETE ON t_insightia_insight 
FOR EACH ROW
BEGIN

  INSERT INTO t_insightia_auditoria (id_auditoria, usuario_auditoria, date_auditoria, comando_auditoria, vlr_antigo, vlr_novo, coluna_afetada, tabela_afetada) 
  VALUES (sq_insightia_auditoria.nextval, USER, SYSTIMESTAMP, 'DELETE', :old.ds_conteudo, NULL, 'DS_CONTEUDO', 't_insightia_insight');
  
END trg_auditoria_delete_anuncio;
/

-- Gatilho para auditar operações de INSERT na tabela t_insightia_anuncio
CREATE OR REPLACE TRIGGER trg_auditoria_insert_anuncio
AFTER INSERT ON t_insightia_anuncio
FOR EACH ROW
BEGIN

  INSERT INTO t_insightia_auditoria (id_auditoria, usuario_auditoria, date_auditoria, comando_auditoria, vlr_antigo, vlr_novo, coluna_afetada, tabela_afetada) 
  VALUES (sq_insightia_auditoria.nextval, USER, SYSTIMESTAMP, 'INSERT', NULL, :NEW.ds_descricao, 'DS_DESCRICAO', 't_insightia_anuncio');
  
END trg_auditoria_insert_comando;
/


-- Exemplo de INSERT em t_insightia_anuncio
INSERT INTO t_insightia_anuncio (id_anuncio, id_usuario, sg_ativo, ds_descricao)
VALUES (SQ_INSIGHTIA_ANUNCIO.NEXTVAL, 1, 'S', 'Exemplo');

select * from t_insightia_anuncio;

-- Exemplo de INSERT em t_insightia_insight
INSERT INTO t_insightia_insight (id_insight, id_anuncio, ds_conteudo, ft_image)
VALUES (SQ_INSIGHTIA_INSIGHT.NEXTVAL, 1, 'Insight Exemplo', EMPTY_BLOB());

select * from t_insightia_insight;

-- Exemplo de DELETE em t_insightia_insight
DELETE FROM t_insightia_insight WHERE id_insight = 1;

select * from t_insightia_insight;

select * FROM t_insightia_auditoria;

