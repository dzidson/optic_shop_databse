CREATE OR REPLACE FUNCTION log_operation() RETURNS TRIGGER AS
$$
DECLARE
query TEXT = '';
BEGIN
	SELECT CURRENT_QUERY() INTO QUERY;
	RAISE NOTICE 'Logging opetation: %', query;
	INSERT INTO operation_log(log_datetime, log_user, log_query) 
	VALUES (CURRENT_TIMESTAMP, CURRENT_USER, query);
	
	RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER log_operation 
AFTER UPDATE or INSERT or DELETE or TRUNCATE on work_order
FOR EACH STATEMENT EXECUTE FUNCTION log_operation();

--TEST

SELECT * FROM work_order; 
UPDATE work_order SET price = price+1 ; 
 
SELECT * FROM operation_log; 