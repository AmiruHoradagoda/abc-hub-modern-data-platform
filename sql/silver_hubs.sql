-- =========================
-- SILVER HUBS
-- =========================

CREATE TABLE IF NOT EXISTS silver.hub_customer (
                                     customer_hk VARCHAR(64) PRIMARY KEY,
                                     customer_id BIGINT NOT NULL UNIQUE,
                                     load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     record_source VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.hub_content (
                                    content_hk VARCHAR(64) PRIMARY KEY,
                                    content_id BIGINT NOT NULL UNIQUE,
                                    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    record_source VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.hub_rental (
                                   rental_hk VARCHAR(64) PRIMARY KEY,
                                   rental_id BIGINT NOT NULL UNIQUE,
                                   load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   record_source VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.hub_inventory (
                                      inventory_hk VARCHAR(64) PRIMARY KEY,
                                      inventory_id BIGINT NOT NULL UNIQUE,
                                      load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      record_source VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.hub_subscription (
                                         subscription_hk VARCHAR(64) PRIMARY KEY,
                                         subscription_id BIGINT NOT NULL UNIQUE,
                                         load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                         record_source VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS silver.hub_payment (
                                    payment_hk VARCHAR(64) PRIMARY KEY,
                                    payment_id BIGINT NOT NULL UNIQUE,
                                    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    record_source VARCHAR(100) NOT NULL
);