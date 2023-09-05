CREATE OR REPLACE FUNCTION CALL_CUSTOMERS_IF (OUT P_LAST_NAME TEXT, OUT P_FIRST_NAME TEXT, OUT P_COMMENT TEXT) 
RETURNS SETOF RECORD AS $$
DECLARE
 	row RECORD;
BEGIN
 	FOR row IN SELECT MAX(wo.work_date) AS last_contact, c.last_name, c.first_name
					  FROM work_order AS wo
					  INNER JOIN client AS c ON c.client_id = wo.client_id
					  GROUP BY c.last_name, c.first_name
	LOOP
		 p_last_name = row.last_name;
		 p_first_name = row.first_name;
		 IF row.last_contact < CURRENT_DATE - INTERVAL '3 years' THEN p_comment = 'LOST';
		 ELSIF row.last_contact < CURRENT_DATE - INTERVAL '1 year' THEN p_comment = 'CALL';
		 ELSE
		 p_comment = 'WAIT';
		 END IF;
 	RETURN NEXT;
 END LOOP;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION CALL_CUSTOMERS_CASE (OUT P_LAST_NAME TEXT, OUT P_FIRST_NAME TEXT, OUT P_COMMENT TEXT) 
RETURNS SETOF RECORD AS 
$$
DECLARE
 	row RECORD;
BEGIN
 	FOR row IN SELECT MAX(wo.work_date) AS last_contact, c.last_name, c.first_name
					  FROM work_order AS wo
				 	  INNER JOIN client AS c ON c.client_id = wo.client_id
				 	  GROUP BY c.last_name, c.first_name
	LOOP
		 p_last_name = row.last_name;
		 p_first_name = row.first_name;
 	CASE
		WHEN row.last_contact < CURRENT_DATE - INTERVAL '3 years' THEN p_comment = 'LOST';
	 	WHEN row.last_contact < CURRENT_DATE - INTERVAL '1 year' THEN p_comment = 'CALL';
	 	ELSE p_comment = 'WAIT';
	END CASE;
 RETURN NEXT;
 END LOOP;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION CALENDAR_ORDERS(P_START_DATE DATE, P_NUMBER_OF_DAYS INT) 
RETURNS TABLE(DAY_DATE DATE, NUMBER_OF_ORDERS BIGINT) AS 
$$
DECLARE
	day INT = 0;
BEGIN
 	CREATE TEMPORARY TABLE tmp_days(day_date DATE, number_of_orders BIGINT) ON COMMIT DROP;
 	WHILE day < p_number_of_days
 	LOOP
 		INSERT INTO tmp_days(day_date, number_of_orders) VALUES(p_start_date + day * INTERVAL '1 day', 0);
 		day = day + 1;
 	END LOOP;

 	UPDATE tmp_days AS d
 	SET number_of_orders = (SELECT COUNT(*) FROM work_order AS wo 
						 	WHERE wo.work_date=d.day_date);

 	RETURN QUERY
 	SELECT * FROM tmp_days;
END
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION GET_MEAN_VALUE_FOR_DATE(P_DATE DATE) RETURNS NUMERIC(8,2) AS 
$$
DECLARE
	number_of_rows INT = 0;
	sum_value NUMERIC(8,2) = 0;
BEGIN
	SELECT COUNT(*) INTO number_of_rows
	FROM work_order
	WHERE work_date=p_date;

	IF number_of_rows > 0 THEN
 		SELECT SUM(price) INTO sum_value
 		FROM work_order
 		WHERE work_date=p_date;
 	END IF;

	RAISE NOTICE 'sum_value=%', sum_value;
	RAISE NOTICE 'number_of_rows=%', number_of_rows;

 	RETURN (sum_value/number_of_rows);
	
	EXCEPTION 
		WHEN division_by_zero THEN
		RAISE NOTICE 'DIVISION BY ZERO';
			RETURN NULL;
END;
$$ LANGUAGE PLPGSQL
-- TEST FUNCTION--

SELECT * FROM CALL_CUSTOMERS_IF();
SELECT * FROM CALL_CUSTOMER_CASE();
SELECT * FROM CALENDAR_ORDERS('2023-01-01', 360);
SELECT * FROM get_mean_value_for_date(CURRENT_DATE); 