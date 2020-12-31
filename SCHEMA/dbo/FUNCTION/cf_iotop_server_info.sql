CREATE OR REPLACE FUNCTION dbo.cf_iotop_server_info(_ip text) RETURNS TABLE(c_device text, n_tps numeric, n_kb_read numeric, n_kb_wrtn numeric, dx_created timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _ip - IP - адрес
*
* @example
* [{ "action": "cf_iotop_server_info", "method": "Select", "data": [{ "params": [_ip] }], "type": "rpc", "tid": 0}]
*/
DECLARE
	_c_device text;
BEGIN
	select d.c_device into _c_device from dbo.cd_iotop as d where d.c_ip =_ip
	order by d.n_kb_read desc
	limit 1;

	RETURN QUERY with items as (
		select 
			d.c_device::text, 
			d.n_tps, 
			d.n_kb_read as n_kb_read_current,
			d.n_kb_wrtn as n_kb_wrtn_current,
			(d.n_kb_read - coalesce(LAG (d.n_kb_read, 1) over(order by d.dx_created), 0)) / 1024 / 1024 as n_kb_read,
			coalesce(LAG (d.n_kb_read, 1) over(order by d.dx_created), 0) as n_kb_read_prev,
			(d.n_kb_wrtn - coalesce(LAG (d.n_kb_wrtn, 1) over(order by d.dx_created), 0)) / 1024 / 1024 as n_kb_wrtn, 
			coalesce(LAG (d.n_kb_wrtn, 1) over(order by d.dx_created), 0) as n_kb_wrtn_prev,
			d.dx_created
		from dbo.cd_iotop as d
		where d.c_ip =_ip and d.c_device = _c_device and d.dx_created between now() - interval '1 day' and now()
	)
	SELECT max(d.c_device), avg(d.n_tps), avg(d.n_kb_read), avg(d.n_kb_wrtn), max(d.dx_created) FROM items as d
	where d.n_kb_read_current > d.n_kb_read_prev and d.n_kb_wrtn_current > d.n_kb_wrtn_prev
	group by date_part('hour', d.dx_created)
	order by max(d.dx_created);
END
$$;

ALTER FUNCTION dbo.cf_iotop_server_info(_ip text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_iotop_server_info(_ip text) IS 'Информация чтении-записи с диска';
