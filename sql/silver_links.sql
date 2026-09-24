-- =========================
-- SILVER LINKS
-- =========================

CREATE TABLE IF NOT EXISTS silver.link_customer_rental (
                                             customer_rental_hk VARCHAR(64) PRIMARY KEY,
                                             customer_hk VARCHAR(64) NOT NULL,
                                             rental_hk VARCHAR(64) NOT NULL,
                                             load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                             record_source VARCHAR(100) NOT NULL,

    CONSTRAINT uq_link_customer_rental UNIQUE (customer_hk, rental_hk),

                                             FOREIGN KEY (customer_hk)
                                                 REFERENCES silver.hub_customer(customer_hk),

                                             FOREIGN KEY (rental_hk)
                                                 REFERENCES silver.hub_rental(rental_hk)
);

CREATE TABLE IF NOT EXISTS silver.link_customer_subscription (
                                                   customer_subscription_hk VARCHAR(64) PRIMARY KEY,
                                                   customer_hk VARCHAR(64) NOT NULL,
                                                   subscription_hk VARCHAR(64) NOT NULL,
                                                   load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                                   record_source VARCHAR(100) NOT NULL,

    CONSTRAINT uq_link_customer_subscription UNIQUE (customer_hk, subscription_hk),

                                                   FOREIGN KEY (customer_hk)
                                                       REFERENCES silver.hub_customer(customer_hk),

                                                   FOREIGN KEY (subscription_hk)
                                                       REFERENCES silver.hub_subscription(subscription_hk)
);

CREATE TABLE IF NOT EXISTS silver.link_customer_payment (
                                              customer_payment_hk VARCHAR(64) PRIMARY KEY,
                                              customer_hk VARCHAR(64) NOT NULL,
                                              payment_hk VARCHAR(64) NOT NULL,
                                              load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                              record_source VARCHAR(100) NOT NULL,

    CONSTRAINT uq_link_customer_payment UNIQUE (customer_hk, payment_hk),

                                              FOREIGN KEY (customer_hk)
                                                  REFERENCES silver.hub_customer(customer_hk),

                                              FOREIGN KEY (payment_hk)
                                                  REFERENCES silver.hub_payment(payment_hk)
);

CREATE TABLE IF NOT EXISTS silver.link_content_inventory (
                                               content_inventory_hk VARCHAR(64) PRIMARY KEY,
                                               content_hk VARCHAR(64) NOT NULL,
                                               inventory_hk VARCHAR(64) NOT NULL,
                                               load_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                               record_source VARCHAR(100) NOT NULL,

    CONSTRAINT uq_link_content_inventory UNIQUE (content_hk, inventory_hk),

                                               FOREIGN KEY (content_hk)
                                                   REFERENCES silver.hub_content(content_hk),

                                               FOREIGN KEY (inventory_hk)
                                                   REFERENCES silver.hub_inventory(inventory_hk)
);