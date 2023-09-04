CREATE OR REPLACE PROCEDURE count_rows(p_reason TEXT)
AS $$

INSERT INTO DATA_INVENTORY(reason, table_name, number_of_rows)
VALUES  (P_REASON, 'client', (SELECT COUNT(*) FROM CLIENT)),
		(P_REASON, 'work_order', (SELECT COUNT(*) FROM WORK_ORDER)),
		(P_REASON, 'service', (SELECT COUNT(*) FROM SERVICE))
$$ LANGUAGE SQL;
		 
		 
CALL count_rows('February opening')
SELECT * FROM data_inventory;