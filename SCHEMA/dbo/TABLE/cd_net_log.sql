CREATE TABLE dbo.cd_net_log (
	id bigint NOT NULL,
	c_name character varying(10),
	n_sent numeric(6,2),
	n_received numeric(6,2),
	dx_created timestamp with time zone DEFAULT now(),
	c_ip character varying(15),
	c_sent_name character varying(3),
	c_received_name character varying(3),
	n_rate numeric(6,2),
	c_rate_name character varying(6)
);

ALTER TABLE dbo.cd_net_log ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
	SEQUENCE NAME dbo.cd_net_log_id_seq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1
	CYCLE
);

ALTER TABLE dbo.cd_net_log OWNER TO monitor;

COMMENT ON TABLE dbo.cd_net_log IS 'Сетевой мониторинг - статистика';

COMMENT ON COLUMN dbo.cd_net_log.c_name IS 'дата';

COMMENT ON COLUMN dbo.cd_net_log.n_sent IS 'отправлено';

COMMENT ON COLUMN dbo.cd_net_log.n_received IS 'получено';

COMMENT ON COLUMN dbo.cd_net_log.n_rate IS 'Средняя скорость';

--------------------------------------------------------------------------------

ALTER TABLE dbo.cd_net_log
	ADD CONSTRAINT net_log_pkey PRIMARY KEY (id);
