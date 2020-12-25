CREATE TABLE dbo.cd_net (
	id bigint NOT NULL,
	c_name character varying(100),
	n_sent numeric(9,6),
	n_received numeric(9,6),
	dx_created timestamp with time zone DEFAULT now(),
	c_ip character varying(15)
);

ALTER TABLE dbo.cd_net ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
	SEQUENCE NAME dbo.net_id_seq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1
	CYCLE
);

ALTER TABLE dbo.cd_net OWNER TO monitor;

COMMENT ON TABLE dbo.cd_net IS 'Сетевой мониторинг';

COMMENT ON COLUMN dbo.cd_net.c_name IS 'наименование приложения, службы';

COMMENT ON COLUMN dbo.cd_net.n_sent IS 'отправлено';

COMMENT ON COLUMN dbo.cd_net.n_received IS 'получено';

--------------------------------------------------------------------------------

ALTER TABLE dbo.cd_net
	ADD CONSTRAINT net_pkey PRIMARY KEY (id);
