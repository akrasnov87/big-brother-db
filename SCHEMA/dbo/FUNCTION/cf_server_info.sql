CREATE OR REPLACE FUNCTION dbo.cf_server_info(_ip text) RETURNS TABLE(c_name text, c_text text)
    LANGUAGE plpgsql
    AS $$
/**
* @params {text} _ip - IP - адрес
*
* @example
* [{ "action": "cf_server_info", "method": "Select", "data": [{ "params": [_ip] }], "type": "rpc", "tid": 0}]
*/
BEGIN
	RETURN QUERY select '', '';
END
$$;

ALTER FUNCTION dbo.cf_server_info(_ip text) OWNER TO mobnius;

COMMENT ON FUNCTION dbo.cf_server_info(_ip text) IS 'Информация об аномалиях на сервере';
