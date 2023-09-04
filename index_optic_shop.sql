CREATE INDEX ix_address_city_street ON address (city, street); 

CREATE UNIQUE INDEX ix_address_last_first_address on client(last_name, first_name, address_id);

CREATE INDEX ix_work_order_work_date on work_order(work_date);

