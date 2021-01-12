CREATE OR REPLACE FUNCTION dbo.sf_remove_outdated() RETURNS void
    LANGUAGE plpgsql
    AS $$
/**
* системная функция должна выполнять от postgres
*/
DECLARE
    _n_val      integer = 14;
    _d_data     timestamptz = date_trunc('day', now()) + '1 day'::interval; -- начало следующего дня
	_dg_cnt		integer; --diagnostic
	_dg_text	text = '';
BEGIN
    _d_data  = _d_data - _n_val * '1 day'::interval;

    delete from dbo.cd_df where dx_created < _d_data;
	get diagnostics _dg_cnt = row_count;
	_dg_text = _dg_text || ' dbo.cd_df: удалено '|| _dg_cnt::text || E'\n';

    delete from dbo.cd_iotop where dx_created < _d_data;
	get diagnostics _dg_cnt = row_count;
	_dg_text = _dg_text || ' dbo.cd_iotop: удалено '|| _dg_cnt::text || E'\n';

    delete from dbo.cd_net where dx_created < _d_data;
	get diagnostics _dg_cnt = row_count;
	_dg_text = _dg_text || ' dbo.cd_net: удалено '|| _dg_cnt::text || E'\n';

    delete from dbo.cd_net_log where dx_created < _d_data;
	get diagnostics _dg_cnt = row_count;
	_dg_text = _dg_text || ' dbo.cd_net_log: удалено '|| _dg_cnt::text || E'\n';

	delete from dbo.cd_psql where dx_created < _d_data;
	get diagnostics _dg_cnt = row_count;
	_dg_text = _dg_text || ' dbo.cd_psql: удалено '|| _dg_cnt::text || E'\n';
	
	delete from dbo.cd_top where dx_created < _d_data;
	get diagnostics _dg_cnt = row_count;
	_dg_text = _dg_text || ' dbo.cd_top: удалено '|| _dg_cnt::text || E'\n';

	insert into dbo.cd_sys_log(d_timestamp, c_descr)
	values(clock_timestamp(), 'Очистка таблиц выполнена. ' || E'\n' || _dg_text);

	EXCEPTION
	WHEN OTHERS
    THEN
		insert into dbo.cd_sys_log(d_timestamp, c_descr)
		values(clock_timestamp(), 'Непредвиденная ошибка очистки таблиц');

END;
$$;

ALTER FUNCTION dbo.sf_remove_outdated() OWNER TO postgres;

COMMENT ON FUNCTION dbo.sf_remove_outdated() IS 'Процедура очистки устаревших данных';
