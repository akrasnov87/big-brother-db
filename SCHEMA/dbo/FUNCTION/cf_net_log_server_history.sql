CREATE OR REPLACE FUNCTION dbo.cf_net_log_server_history(_ip text) RETURNS TABLE(n_sent numeric, n_received numeric, dx_created timestamp with time zone, n_sent_avg numeric, n_received_avg numeric)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _ip - IP - адрес
*
* @example
* [{ "action": "cf_net_log_server_history", "method": "Select", "data": [{ "params": [_ip] }], "type": "rpc", "tid": 0}]
*/
DECLARE
	_n_sent_avg numeric;
	_n_received_avg numeric;
BEGIN
	with items as (
		select 
			CASE WHEN n.c_sent_name != 'GiB' THEN n.n_sent / 1024 ELSE n.n_sent END as n_sent,
			LAG(CASE WHEN n.c_sent_name != 'GiB' THEN n.n_sent / 1024 ELSE n.n_sent END, 1) over(order by n.dx_created) as n_sent_prev,
			CASE WHEN n.c_received_name != 'GiB' THEN n.n_received / 1024 ELSE n.n_received END as n_received,
			LAG(CASE WHEN n.c_received_name != 'GiB' THEN n.n_received / 1024 ELSE n.n_received END, 1) over(order by n.dx_created) as n_received_prev,
			n.dx_created
		from dbo.cd_net_log as n
		where n.c_ip =_ip
	)
	select avg(t.n_sent), avg(t.n_received) into
		_n_sent_avg, _n_received_avg from (SELECT 
		sum(d.n_sent) - sum(coalesce(d.n_sent_prev, 0)) as n_sent, 
		sum(d.n_received) - sum(coalesce(d.n_received_prev, 0)) as n_received
	FROM items as d
	where d.n_sent > d.n_sent_prev and d.n_received > d.n_received_prev
	group by date_part('month', d.dx_created), date_part('day', d.dx_created), date_part('hour', d.dx_created)) as t;

	RETURN QUERY with items as (
		select 
			CASE WHEN n.c_sent_name != 'GiB' THEN n.n_sent / 1024 ELSE n.n_sent END as n_sent,
			LAG(CASE WHEN n.c_sent_name != 'GiB' THEN n.n_sent / 1024 ELSE n.n_sent END, 1) over(order by n.dx_created) as n_sent_prev,
			CASE WHEN n.c_received_name != 'GiB' THEN n.n_received / 1024 ELSE n.n_received END as n_received,
			LAG(CASE WHEN n.c_received_name != 'GiB' THEN n.n_received / 1024 ELSE n.n_received END, 1) over(order by n.dx_created) as n_received_prev,
			n.c_sent_name,
			n.c_received_name,
			n.dx_created
		from dbo.cd_net_log as n
		where n.c_ip =_ip and n.dx_created between now() - interval '7 day' and now()
	)
	SELECT 
		sum(d.n_sent) - sum(coalesce(d.n_sent_prev, 0)) as n_sent, 
		sum(d.n_received) - sum(coalesce(d.n_received_prev, 0)) as n_received,
		max(d.dx_created) as dx_created,
		_n_sent_avg,
		_n_received_avg
	FROM items as d
	where d.n_sent > d.n_sent_prev and d.n_received > d.n_received_prev
	group by date_part('month', d.dx_created), date_part('day', d.dx_created), date_part('hour', d.dx_created)
	order by max(d.dx_created);
END
$$;

ALTER FUNCTION dbo.cf_net_log_server_history(_ip text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_net_log_server_history(_ip text) IS 'Информация о состоянии сети - трафик';
