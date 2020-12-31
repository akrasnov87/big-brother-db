CREATE OR REPLACE FUNCTION dbo.cf_cpu_server_info(_ip text) RETURNS TABLE(n_la1 numeric, n_la2 numeric, n_la3 numeric, dx_created timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _ip - IP - адрес
*
* @example
* [{ "action": "cf_cpu_server_info", "method": "Select", "data": [{ "params": [_ip] }], "type": "rpc", "tid": 0}]
*/
BEGIN

	RETURN QUERY select avg(d.n_la1), avg(d.n_la2), avg(d.n_la3), max(d.dx_created)
	from dbo.cd_top as d
	where d.c_ip =_ip and d.dx_created between now() - interval '1 day' and now()
	group by date_part('hour', d.dx_created)
	order by max(d.dx_created);
END
$$;

ALTER FUNCTION dbo.cf_cpu_server_info(_ip text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_cpu_server_info(_ip text) IS 'Информация о CPU сервера';
