CREATE OR REPLACE FUNCTION dbo.cf_df_server_info(_ip text) RETURNS TABLE(c_name text, n_blocks numeric, n_used numeric, dx_created timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _ip - IP - адрес
* @params {text} _c_interval - интервал видимости
* @params {text} _c_group - группировка по дате
*
* @example
* [{ "action": "cf_df_server_info", "method": "Select", "data": [{ "params": [_ip] }], "type": "rpc", "tid": 0}]
*/
DECLARE
	_c_dev text;
BEGIN
	select d.c_name into _c_dev from dbo.cd_df as d where d.c_ip =_ip
	order by d.n_blocks desc
	limit 1;

	RETURN QUERY
	SELECT max(d.c_name)::text, avg(d.n_blocks) / 1024 / 1024, avg(d.n_used) / 1024 / 1024, max(d.dx_created)
	FROM dbo.cd_df as d
	where d.c_ip =_ip and d.c_name = _c_dev and d.dx_created between now() - '1 day'::interval and now()
	group by date_part('day', d.dx_created), date_part('hour', d.dx_created)
	order by max(d.dx_created);
END
$$;

ALTER FUNCTION dbo.cf_df_server_info(_ip text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_df_server_info(_ip text) IS 'Информация о дисках сервера';
