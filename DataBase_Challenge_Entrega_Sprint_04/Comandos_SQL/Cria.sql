CREATE TABLE t_insightia_anuncio (
    id_anuncio    NUMBER(9) NOT NULL,
    id_usuario    NUMBER(9) NOT NULL,
    sg_ativo      VARCHAR2(1) NOT NULL,
    ds_descricao  VARCHAR2(100) NOT NULL
);

ALTER TABLE t_insightia_anuncio ADD CONSTRAINT pk_t_insightia_anuncio PRIMARY KEY ( id_anuncio );

CREATE TABLE t_insightia_auditoria (
    id_auditoria       NUMBER(9) NOT NULL,
    usuario_auditoria  VARCHAR2(250) NOT NULL,
    date_auditoria     TIMESTAMP(2) WITH LOCAL TIME ZONE NOT NULL,
    comando_auditoria  VARCHAR2(10) NOT NULL,
    vlr_antigo         CLOB,
    vlr_novo           CLOB,
    coluna_afetada     VARCHAR2(50),
    tabela_afetada     VARCHAR2(50)
);

ALTER TABLE t_insightia_auditoria ADD CONSTRAINT pk_t_insight_auditoria_pk PRIMARY KEY ( id_auditoria );

CREATE TABLE t_insightia_comando (
    id_comando   NUMBER(9) NOT NULL,
    id_anuncio   NUMBER(9) NOT NULL,
    ds_conteudo  VARCHAR2(100) NOT NULL
);

ALTER TABLE t_insightia_comando ADD CONSTRAINT pk_t_insightia_comando PRIMARY KEY ( id_comando );

CREATE TABLE t_insightia_insight (
    id_insight   NUMBER(9) NOT NULL,
    id_anuncio   NUMBER(9) NOT NULL,
    ds_conteudo  VARCHAR2(30) NOT NULL,
    ft_image     BLOB NOT NULL
);

ALTER TABLE t_insightia_insight ADD CONSTRAINT pk_t_insightia_insight PRIMARY KEY ( id_insight );

CREATE TABLE t_insightia_transacao (
    id_transacao  NUMBER(9) NOT NULL,
    id_usuario    NUMBER(9) NOT NULL,
    ds_titulo     VARCHAR2(20) NOT NULL,
    ds_transacao  VARCHAR2(100) NOT NULL,
    dt_cadastro   DATE NOT NULL,
    vl_valor      NUMBER(9, 2) NOT NULL,
    vl_bonus      NUMBER(9, 2) 
);

ALTER TABLE t_insightia_transacao ADD CONSTRAINT pk_t_insightia_transacao PRIMARY KEY ( id_transacao );

CREATE TABLE t_insightia_usuario (
    id_usuario  NUMBER(9) NOT NULL,
    ds_email    VARCHAR2(50) NOT NULL,
    nm_usuario  VARCHAR2(40) NOT NULL,
    ds_senha    VARCHAR2(20) NOT NULL,
    nr_saldo    NUMBER(9, 2) NOT NULL
);

ALTER TABLE t_insightia_usuario ADD CONSTRAINT pk_t_insightia_usuario PRIMARY KEY ( id_usuario );

ALTER TABLE t_insightia_usuario ADD CONSTRAINT uk_usuario_email UNIQUE ( ds_email );

ALTER TABLE t_insightia_usuario ADD CONSTRAINT uk_nm_usuario UNIQUE ( nm_usuario );

ALTER TABLE t_insightia_anuncio
    ADD CONSTRAINT relation_2 FOREIGN KEY ( id_usuario )
        REFERENCES t_insightia_usuario ( id_usuario );

ALTER TABLE t_insightia_transacao
    ADD CONSTRAINT relation_4 FOREIGN KEY ( id_usuario )
        REFERENCES t_insightia_usuario ( id_usuario );

ALTER TABLE t_insightia_insight
    ADD CONSTRAINT relation_6 FOREIGN KEY ( id_anuncio )
        REFERENCES t_insightia_anuncio ( id_anuncio );

ALTER TABLE t_insightia_comando
    ADD CONSTRAINT relation_7 FOREIGN KEY ( id_anuncio )
        REFERENCES t_insightia_anuncio ( id_anuncio );

CREATE SEQUENCE SQ_INSIGHTIA_USUARIO INCREMENT BY 1 START WITH 1 NOCACHE; 

CREATE SEQUENCE SQ_INSIGHTIA_ANUNCIO INCREMENT BY 1 START WITH 1 NOCACHE; 

CREATE SEQUENCE SQ_INSIGHTIA_TRANSACAO INCREMENT BY 1 START WITH 1 NOCACHE; 

CREATE SEQUENCE SQ_INSIGHTIA_COMANDO INCREMENT BY 1 START WITH 1 NOCACHE; 

CREATE SEQUENCE SQ_INSIGHTIA_INSIGHT INCREMENT BY 1 START WITH 1 NOCACHE; 

CREATE SEQUENCE SQ_INSIGHTIA_AUDITORIA INCREMENT BY 1 START WITH 1 NOCACHE; 
