CREATE TABLE dbo.cd_psql (
	id bigint NOT NULL,
	c_datname character varying(100),
	n_xact_commit bigint,
	n_numbackends smallint,
	dx_created timestamp with time zone DEFAULT now(),
	c_ip character varying(15)
);

ALTER TABLE dbo.cd_psql ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
	SEQUENCE NAME dbo.cd_psql_id_seq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1
	CYCLE
);

ALTER TABLE dbo.cd_psql OWNER TO monitor;

COMMENT ON TABLE dbo.cd_psql IS 'Транзакции';

--------------------------------------------------------------------------------

CREATE INDEX cd_psql_dx_created_idx ON dbo.cd_psql USING btree (dx_created);

--------------------------------------------------------------------------------

ALTER TABLE dbo.cd_psql
	ADD CONSTRAINT cd_psql_pkey PRIMARY KEY (id);
