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

