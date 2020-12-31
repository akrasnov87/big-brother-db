CREATE OR REPLACE FUNCTION dbo.cf_servers() RETURNS TABLE(c_name character varying)
    LANGUAGE plpgsql
    AS $$
/**
* 
* @example
* [{ "action": "cf_servers", "method": "Select", "data": [{ "params": [_ip] }], "type": "rpc", "tid": 0}]
*/
BEGIN
	RETURN QUERY SELECT DISTINCT t.c_ip
	FROM dbo.cd_top as t;
END
$$;

ALTER FUNCTION dbo.cf_servers() OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_servers() IS 'Список серверов';
