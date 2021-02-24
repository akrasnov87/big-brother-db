CREATE OR REPLACE FUNCTION dbo.cf_cpu_server_history(_ip text) RETURNS TABLE(n_la1 numeric, n_la2 numeric, n_la3 numeric, dx_created timestamp with time zone, n_la3_avg numeric)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _ip - IP - адрес
*
* @example
* [{ "action": "cf_cpu_server_history", "method": "Select", "data": [{ "params": [_ip] }], "type": "rpc", "tid": 0}]
*/
DECLARE
	_n_la3_avg numeric;
BEGIN
	select avg(t.n_la3) into _n_la3_avg from (select avg(d.n_la3) as n_la3 from dbo.cd_top as d where d.c_ip =_ip
			group by date_part('month', d.dx_created), date_part('day', d.dx_created), date_part('hour', d.dx_created)) as t ;
	
	RETURN QUERY select avg(d.n_la1), avg(d.n_la2), avg(d.n_la3), max(d.dx_created), _n_la3_avg
	from dbo.cd_top as d
	where d.c_ip =_ip and d.dx_created between now() - interval '7 day' and now()
	group by date_part('month', d.dx_created), date_part('day', d.dx_created), date_part('hour', d.dx_created)
	order by max(d.dx_created);
END
$$;

ALTER FUNCTION dbo.cf_cpu_server_history(_ip text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_cpu_server_history(_ip text) IS 'Информация о CPU сервера';
