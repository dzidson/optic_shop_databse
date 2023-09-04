CREATE SEQUENCE IF NOT EXISTS QUEUE_NUMBER INCREMENT 1
START WITH 101


/*
SELECT NEXTVAL('queue_number');
SELECT CURRVAL('queue_number');  zwraca ostatnio wygenerowany numer w danej sekwencji
SELECT LASTVAL(); zwraca ostatnio wygenerowany numer dla wszystkich sekwencji
SELECT SETVAL('queue_number', 100, FALSE); ustawi 100 jako następną wartość do wygenerowania
*/
