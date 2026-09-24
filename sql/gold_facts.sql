CREATE TABLE IF NOT EXISTS gold.fact_customer_daily_activity (
                                                   customer_activity_key BIGSERIAL PRIMARY KEY,

                                                   customer_key BIGINT NOT NULL,
                                                   date_key INT NOT NULL,
                                                   location_key BIGINT,
                                                   subscription_plan_key BIGINT,

                                                   streaming_session_count INT DEFAULT 0,
                                                   total_streaming_duration INT DEFAULT 0,
                                                   physical_rental_count INT DEFAULT 0,
                                                   returned_item_count INT DEFAULT 0,
                                                   total_amount_spent NUMERIC(14,2) DEFAULT 0,
                                                   support_ticket_count INT DEFAULT 0,

                                                   FOREIGN KEY (customer_key)
                                                       REFERENCES gold.dim_customer(customer_key),

                                                   FOREIGN KEY (date_key)
                                                       REFERENCES gold.dim_date(date_key),

                                                   FOREIGN KEY (location_key)
                                                       REFERENCES gold.dim_location(location_key),

                                                   FOREIGN KEY (subscription_plan_key)
                                                       REFERENCES gold.dim_subscription_plan(subscription_plan_key),

                                                   UNIQUE (customer_key, date_key)
);

CREATE TABLE IF NOT EXISTS gold.fact_content_monthly_performance (
                                                       content_monthly_key BIGSERIAL PRIMARY KEY,

                                                       content_key BIGINT NOT NULL,
                                                       month_key INT NOT NULL,
                                                       content_type_key BIGINT,
                                                       genre_key BIGINT,

                                                       total_streams INT DEFAULT 0,
                                                       total_rental_count INT DEFAULT 0,
                                                       revenue_generated NUMERIC(14,2) DEFAULT 0,
                                                       average_customer_rating NUMERIC(5,2),
                                                       wishlist_additions INT DEFAULT 0,

                                                       FOREIGN KEY (content_key)
                                                           REFERENCES gold.dim_content(content_key),

                                                       FOREIGN KEY (month_key)
                                                           REFERENCES gold.dim_month(month_key),

                                                       FOREIGN KEY (content_type_key)
                                                           REFERENCES gold.dim_content_type(content_type_key),

                                                       FOREIGN KEY (genre_key)
                                                           REFERENCES gold.dim_genre(genre_key),

                                                       UNIQUE (content_key, month_key)
);
CREATE TABLE IF NOT EXISTS gold.fact_inventory_daily_utilisation (
                                                       inventory_daily_key BIGSERIAL PRIMARY KEY,

                                                       inventory_key BIGINT NOT NULL,
                                                       date_key INT NOT NULL,
                                                       content_key BIGINT NOT NULL,
                                                       warehouse_key BIGINT NOT NULL,

                                                       rental_count INT DEFAULT 0,
                                                       return_count INT DEFAULT 0,
                                                       days_available INT DEFAULT 0,
                                                       utilisation_percentage NUMERIC(5,2) DEFAULT 0,

                                                       FOREIGN KEY (inventory_key)
                                                           REFERENCES gold.dim_inventory(inventory_key),

                                                       FOREIGN KEY (date_key)
                                                           REFERENCES gold.dim_date(date_key),

                                                       FOREIGN KEY (content_key)
                                                           REFERENCES gold.dim_content(content_key),

                                                       FOREIGN KEY (warehouse_key)
                                                           REFERENCES gold.dim_warehouse(warehouse_key),

                                                       UNIQUE (inventory_key, date_key)
);