CREATE TABLE dbo.cd_iotop (
	id bigint NOT NULL,
	c_device character varying(100),
	n_tps numeric(6,2),
	n_kb_read_s numeric(6,2),
	n_kb_wrtn_s numeric(6,2),
	n_kb_read bigint,
	n_kb_wrtn bigint,
	dx_created timestamp with time zone DEFAULT now(),
	c_ip character varying(15)
);

ALTER TABLE dbo.cd_iotop ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
	SEQUENCE NAME dbo.cd_iotop_id_seq
	START WITH 1
	INCREMENT BY 1
	NO MAXVALUE
	NO MINVALUE
	CACHE 1
	CYCLE
);

ALTER TABLE dbo.cd_iotop OWNER TO monitor;

COMMENT ON TABLE dbo.cd_iotop IS 'Мониторинг состояния дисков';

COMMENT ON COLUMN dbo.cd_iotop.n_tps IS 'означает количество запросов на чтение или запись к устройству в секунду';

COMMENT ON COLUMN dbo.cd_iotop.n_kb_read_s IS 'количество килобайт или мегабайт, прочитанных с устройства за секунду';

COMMENT ON COLUMN dbo.cd_iotop.n_kb_wrtn_s IS 'количество килобайт или мегабайт записанных на устройство в секунду';

COMMENT ON COLUMN dbo.cd_iotop.n_kb_read IS 'общее количество прочитанных данных с диска с момента загрузки системы';

COMMENT ON COLUMN dbo.cd_iotop.n_kb_wrtn IS 'количество записанных данных с момента загрузки системы';

--------------------------------------------------------------------------------

CREATE INDEX cd_iotop_dx_created_idx ON dbo.cd_iotop USING btree (dx_created);

--------------------------------------------------------------------------------

ALTER TABLE dbo.cd_iotop
	ADD CONSTRAINT cd_iotop_pkey PRIMARY KEY (id);
