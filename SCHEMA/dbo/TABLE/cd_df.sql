CREATE TABLE dbo.cd_df (
	id bigint NOT NULL,
	c_name character varying(100),
	n_blocks integer,
	n_used integer,
	n_available integer,
	n_use smallint,
	dx_created timestamp with time zone DEFAULT now(),
	c_ip character varying(15)
);

ALTER TABLE dbo.cd_df ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
	SEQUENCE NAME dbo.cd_df_id_seq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1
	CYCLE
);

ALTER TABLE dbo.cd_df OWNER TO monitor;

COMMENT ON TABLE dbo.cd_df IS 'Дисковое пространство';

COMMENT ON COLUMN dbo.cd_df.c_name IS 'Filesystem';

COMMENT ON COLUMN dbo.cd_df.n_blocks IS '1K-blocks';

COMMENT ON COLUMN dbo.cd_df.n_used IS 'Used';

COMMENT ON COLUMN dbo.cd_df.n_available IS 'Available';

COMMENT ON COLUMN dbo.cd_df.n_use IS 'Use%';

--------------------------------------------------------------------------------

ALTER TABLE dbo.cd_df
	ADD CONSTRAINT cd_df_pkey PRIMARY KEY (id);
