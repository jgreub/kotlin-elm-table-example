CREATE SEQUENCE fruit_id_seq;

CREATE TABLE fruit (
    id bigint PRIMARY KEY DEFAULT nextval('fruit_id_seq'),
    name TEXT
);

-- Make sure sequence is dropped if 'fruit' table is dropped
ALTER SEQUENCE fruit_id_seq OWNED BY fruit.id;