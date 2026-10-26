CREATE TABLE customer (
    customer_sk BIGINT,
    customer_id BIGINT,
    name TEXT,
    age INT,
    customeraddress TEXT,
    valid_from_timestamp TIMESTAMP,
    valid_to_timestamp TIMESTAMP,
    is_valid BOOLEAN,
    PRIMARY KEY (customer_sk)
);
