CREATE OR REPLACE FUNCTION dbo.cf_psql_log_server_history(_ip text) RETURNS TABLE(n_xact_commit numeric, n_numbackends numeric, dx_created timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _ip - IP - адрес
*
* @example
* [{ "action": "cf_psql_log_server_history", "method": "Select", "data": [{ "params": [_ip] }], "type": "rpc", "tid": 0}]
*/
BEGIN
	RETURN QUERY with items as (
		select 
			sum(p.n_xact_commit) as n_xact_commit,
			LAG(sum(p.n_xact_commit), 1) over(order by p.dx_created) as n_xact_commit_prev,
			sum(p.n_numbackends) as n_numbackends,
			max(p.dx_created) as dx_created
		from dbo.cd_psql as p
		where p.c_ip = _ip and p.dx_created between now() - interval '7 day' and now()
		group by p.dx_created
	)
	SELECT 
		sum(d.n_xact_commit) - sum(coalesce(d.n_xact_commit_prev, 0)) as n_xact_commit, 
		avg(d.n_numbackends) as n_numbackends,
		max(d.dx_created) as dx_created 
	FROM items as d
	where d.n_xact_commit_prev is not null and d.n_xact_commit > d.n_xact_commit_prev
	group by date_part('day', d.dx_created), date_part('hour', d.dx_created)
	order by max(d.dx_created);
END
$$;

ALTER FUNCTION dbo.cf_psql_log_server_history(_ip text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_psql_log_server_history(_ip text) IS 'Транзакции';

--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION dbo.cf_psql_log_server_history(_ip text, _db_name text) RETURNS TABLE(n_xact_commit numeric, n_numbackends numeric, dx_created timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _ip - IP - адрес
*
* @example
* [{ "action": "cf_psql_log_server_history", "method": "Select", "data": [{ "params": [_ip] }], "type": "rpc", "tid": 0}]
*/
BEGIN
	RETURN QUERY with items as (
		select 
			sum(p.n_xact_commit) as n_xact_commit,
			LAG(sum(p.n_xact_commit), 1) over(order by p.dx_created) as n_xact_commit_prev,
			sum(p.n_numbackends) as n_numbackends,
			max(p.dx_created) as dx_created
		from dbo.cd_psql as p
		where p.c_ip = _ip and p.c_datname = _db_name and p.dx_created between now() - interval '7 day' and now()
		group by p.dx_created
	)
	SELECT 
		sum(d.n_xact_commit) - sum(coalesce(d.n_xact_commit_prev, 0)) as n_xact_commit, 
		avg(d.n_numbackends) as n_numbackends,
		max(d.dx_created) as dx_created 
	FROM items as d
	where d.n_xact_commit_prev is not null and d.n_xact_commit > d.n_xact_commit_prev
	group by date_part('day', d.dx_created), date_part('hour', d.dx_created)
	order by max(d.dx_created);
END
$$;

ALTER FUNCTION dbo.cf_psql_log_server_history(_ip text, _db_name text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_psql_log_server_history(_ip text, _db_name text) IS 'Транзакции';
