CREATE OR REPLACE FUNCTION save_employee_order() RETURNS TRIGGER AS
$$
DECLARE 
inserted_count INT = 0;
BEGIN
	RAISE NOTICE 'Trigger save_employee_order is starting';
	IF NOT EXISTS (SELECT * FROM employee WHERE user_name = CURRENT_USER) THEN 
		 INSERT INTO employee(user_name, order_count) VALUES (CURRENT_USER, 0); 
 	END IF; 
 
 	SELECT COUNT(*) INTO inserted_count FROM inserted; 
 
	 UPDATE employee 
	 SET order_count = order_count + inserted_count 
	 WHERE user_name = CURRENT_USER; 
	 
	 RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER save_employee_order 
AFTER INSERT on work_order
REFERENCING NEW TABLE inserted
FOR EACH STATEMENT EXECUTE FUNCTION save_employee_order();

--TEST

 
INSERT INTO work_order(client_id, glasses_id, description, work_date, price) 
VALUES (1, NULL, 'Test of a brand new trigger', CURRENT_DATE, 333), 
 (2, NULL, 'Test of a brand new trigger', CURRENT_DATE, 333), 
 (3, NULL, 'Test of a brand new trigger', CURRENT_DATE, 333);
 

INSERT INTO work_order(client_id, glasses_id, description, work_date, price) 
VALUES (1, NULL, 'Test of a brand new trigger', CURRENT_DATE, 333); 

SELECT * FROM employee; 