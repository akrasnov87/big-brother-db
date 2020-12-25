CREATE TABLE dbo.cd_top (
	id bigint NOT NULL,
	n_la1 numeric(5,2),
	n_la2 numeric(5,2),
	n_la3 numeric(5,2),
	n_users smallint,
	n_task_total smallint,
	n_task_running smallint,
	n_mem_total integer,
	n_mem_used integer,
	jb_data jsonb,
	dx_created timestamp without time zone DEFAULT now(),
	c_ip character varying(15)
);

ALTER TABLE dbo.cd_top ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
	SEQUENCE NAME dbo.cd_top_id_seq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1
	CYCLE
);

ALTER TABLE dbo.cd_top OWNER TO monitor;

COMMENT ON TABLE dbo.cd_top IS 'Диспетчер сервера';

COMMENT ON COLUMN dbo.cd_top.n_la1 IS '1 минута назад';

COMMENT ON COLUMN dbo.cd_top.n_la2 IS '5 минут назад';

COMMENT ON COLUMN dbo.cd_top.n_la3 IS '15 минут назад';

COMMENT ON COLUMN dbo.cd_top.n_task_total IS 'Процессы';

COMMENT ON COLUMN dbo.cd_top.n_task_running IS 'процессы, выполняющиеся в данный момент;';

COMMENT ON COLUMN dbo.cd_top.n_mem_total IS 'это суммарный объем оперативной памяти сервера';

COMMENT ON COLUMN dbo.cd_top.n_mem_used IS 'это объем использованной памяти';

--------------------------------------------------------------------------------

ALTER TABLE dbo.cd_top
	ADD CONSTRAINT cd_top_pkey PRIMARY KEY (id);
