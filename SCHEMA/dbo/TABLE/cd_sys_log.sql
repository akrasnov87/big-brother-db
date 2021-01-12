CREATE TABLE dbo.cd_sys_log (
	id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
	n_level_msg integer DEFAULT 0,
	d_timestamp timestamp with time zone,
	c_descr text
);

ALTER TABLE dbo.cd_sys_log OWNER TO mobnius;

COMMENT ON TABLE dbo.cd_sys_log IS ' Логирование job';

COMMENT ON COLUMN dbo.cd_sys_log.n_level_msg IS '0 - сообщение
1 - предупрежденние
2 - ошибка';

--------------------------------------------------------------------------------

ALTER TABLE dbo.cd_sys_log
	ADD CONSTRAINT cd_sys_log_pkey PRIMARY KEY (id);
