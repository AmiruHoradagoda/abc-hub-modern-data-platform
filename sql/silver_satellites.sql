-- =========================
-- SILVER SATELLITES
-- =========================

CREATE TABLE IF NOT EXISTS silver.sat_customer (
                                     customer_hk VARCHAR(64) NOT NULL,
                                     first_name VARCHAR(100),
                                     last_name VARCHAR(100),
                                     email VARCHAR(255),
                                     phone VARCHAR(50),
                                     status VARCHAR(50),
                                     load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                     record_source VARCHAR(100) NOT NULL,

                                     PRIMARY KEY (customer_hk, load_date),

                                     FOREIGN KEY (customer_hk)
                                         REFERENCES silver.hub_customer(customer_hk)
);

CREATE TABLE IF NOT EXISTS silver.sat_content (
                                    content_hk VARCHAR(64) NOT NULL,
                                    title VARCHAR(255),
                                    release_date DATE,
                                    duration_minutes INT,
                                    language VARCHAR(100),
                                    age_rating VARCHAR(50),
                                    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    record_source VARCHAR(100) NOT NULL,

                                    PRIMARY KEY (content_hk, load_date),

                                    FOREIGN KEY (content_hk)
                                        REFERENCES silver.hub_content(content_hk)
);

CREATE TABLE IF NOT EXISTS silver.sat_rental (
                                   rental_hk VARCHAR(64) NOT NULL,
                                   rental_date DATE,
                                   due_date DATE,
                                   return_date DATE,
                                   rental_fee NUMERIC(12,2),
                                   late_fee NUMERIC(12,2),
                                   status VARCHAR(50),
                                   load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   record_source VARCHAR(100) NOT NULL,

                                   PRIMARY KEY (rental_hk, load_date),

                                   FOREIGN KEY (rental_hk)
                                       REFERENCES silver.hub_rental(rental_hk)
);

CREATE TABLE IF NOT EXISTS silver.sat_inventory (
                                      inventory_hk VARCHAR(64) NOT NULL,
                                      barcode VARCHAR(100),
                                      purchase_date DATE,
                                      item_condition VARCHAR(100),
                                      status VARCHAR(50),
                                      load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                      record_source VARCHAR(100) NOT NULL,

                                      PRIMARY KEY (inventory_hk, load_date),

                                      FOREIGN KEY (inventory_hk)
                                          REFERENCES silver.hub_inventory(inventory_hk)
);

CREATE TABLE IF NOT EXISTS silver.sat_payment (
                                    payment_hk VARCHAR(64) NOT NULL,
                                    amount NUMERIC(12,2),
                                    payment_date TIMESTAMP,
                                    payment_type VARCHAR(50),
                                    status VARCHAR(50),
                                    load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                    record_source VARCHAR(100) NOT NULL,

                                    PRIMARY KEY (payment_hk, load_date),

                                    FOREIGN KEY (payment_hk)
                                        REFERENCES silver.hub_payment(payment_hk)
);