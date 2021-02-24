CREATE OR REPLACE FUNCTION dbo.cf_mem_server_history(_ip text) RETURNS TABLE(n_mem_total numeric, n_mem_used numeric, dx_created timestamp with time zone, n_mem_avg numeric)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _ip - IP - адрес
*
* @example
* [{ "action": "cf_mem_server_history", "method": "Select", "data": [{ "params": [_ip] }], "type": "rpc", "tid": 0}]
*/
DECLARE
	_n_mem_avg numeric;
BEGIN
	
	select avg(t.n_mem_used) / 1024 / 1024  into _n_mem_avg
	from (select avg(d.n_mem_used) as n_mem_used
			 from dbo.cd_top as d 
			 where d.c_ip =_ip 
			 group by date_part('month', d.dx_created), date_part('day', d.dx_created), date_part('hour', d.dx_created)) as t;
	
	RETURN QUERY 
	select 
		avg(d.n_mem_total) / 1024 / 1024, 
		avg(d.n_mem_used) / 1024 / 1024, 
		max(d.dx_created),
		_n_mem_avg as n_mem_avg
	from dbo.cd_top as d
	where d.c_ip =_ip and d.dx_created between now() - interval '7 day' and now()
	group by date_part('month', d.dx_created), date_part('day', d.dx_created), date_part('hour', d.dx_created)
	order by max(d.dx_created);
END
$$;

ALTER FUNCTION dbo.cf_mem_server_history(_ip text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_mem_server_history(_ip text) IS 'Информация о ОЗУ сервера';
