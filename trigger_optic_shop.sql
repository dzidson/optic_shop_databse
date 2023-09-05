CREATE OR REPLACE FUNCTION trigger_new_service() RETURNS trigger AS 
$$ 
BEGIN 
 	NEW.name = UPPER(NEW.name); 
	RETURN NEW; 
END; 
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER trigger_new_service 
BEFORE INSERT OR UPDATE on service 
FOR EACH ROW EXECUTE FUNCTION trigger_new_service();


INSERT INTO service(service_id, name) VALUES (200, 'rEPAIR caps lock');
SELECT * FROM service WHERE service_id=200; 

UPDATE service 
SET name = 'repair caps lock one' 
where service_id = 200;