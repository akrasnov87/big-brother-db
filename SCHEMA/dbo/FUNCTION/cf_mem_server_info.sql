CREATE OR REPLACE FUNCTION dbo.cf_mem_server_info(_ip text) RETURNS TABLE(n_mem_total numeric, n_mem_used numeric, dx_created timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _ip - IP - адрес
*
* @example
* [{ "action": "cf_cpu_server_info", "method": "Select", "data": [{ "params": [_ip] }], "type": "rpc", "tid": 0}]
*/
BEGIN

	RETURN QUERY select avg(d.n_mem_total) / 1024 / 1024, avg(d.n_mem_used) / 1024 / 1024, max(d.dx_created)
	from dbo.cd_top as d
	where d.c_ip =_ip and d.dx_created between now() - interval '1 day' and now()
	group by date_part('hour', d.dx_created)
	order by max(d.dx_created);
END
$$;

ALTER FUNCTION dbo.cf_mem_server_info(_ip text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_mem_server_info(_ip text) IS 'Информация о ОЗУ сервера';
