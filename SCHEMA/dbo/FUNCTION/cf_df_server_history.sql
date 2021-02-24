CREATE OR REPLACE FUNCTION dbo.cf_df_server_history(_ip text, _disk text) RETURNS TABLE(c_name text, n_blocks numeric, n_used numeric, dx_created timestamp with time zone, n_used_avg numeric)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _ip - IP - адрес
*
* @example
* [{ "action": "cf_df_server_history", "method": "Select", "data": [{ "params": [_ip, _disk] }], "type": "rpc", "tid": 0}]
*/
DECLARE
	_n_used_avg numeric;
BEGIN
	select (select avg(d.n_used) from dbo.cd_df as d where d.c_ip =_ip and d.c_name = _disk) / 1024 / 1024 into _n_used_avg;
	RETURN QUERY
	SELECT 
		max(d.c_name)::text, 
		avg(d.n_blocks) / 1024 / 1024, 
		avg(d.n_used) / 1024 / 1024, 
		max(d.dx_created),
		_n_used_avg
	FROM dbo.cd_df as d
	where d.c_ip =_ip and d.c_name = _disk and d.dx_created between now() - '7 day'::interval and now()
	group by date_part('month', d.dx_created), date_part('day', d.dx_created), date_part('hour', d.dx_created)
	order by max(d.dx_created);
END
$$;

ALTER FUNCTION dbo.cf_df_server_history(_ip text, _disk text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_df_server_history(_ip text, _disk text) IS 'Информация о дисках сервера';
