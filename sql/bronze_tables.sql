-- =========================
-- BRONZE SCHEMA
-- =========================

CREATE TABLE IF NOT EXISTS bronze.customer (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                 customer_id BIGINT,
                                 customer_no VARCHAR(50),
                                 first_name VARCHAR(100),
                                 last_name VARCHAR(100),
                                 email VARCHAR(255),
                                 phone VARCHAR(50),
                                 date_of_birth DATE,
                                 gender VARCHAR(50),
                                 registration_date DATE,
                                 status VARCHAR(50),
                                 ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.customer_address (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                         address_id BIGINT,
                                         customer_id BIGINT,
                                         city_id BIGINT,
                                         address_line VARCHAR(255),
                                         postal_code VARCHAR(50),
                                         address_type VARCHAR(50),
                                         ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                         source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.city (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                             city_id BIGINT,
                             country_id BIGINT,
                             city_name VARCHAR(100),
                             ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                             source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.country (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                country_id BIGINT,
                                country_name VARCHAR(100),
                                country_code VARCHAR(20),
                                ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.subscription_plan (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                          plan_id BIGINT,
                                          plan_name VARCHAR(100),
                                          monthly_fee NUMERIC(12,2),
                                          video_quality VARCHAR(50),
                                          max_devices INT,
                                          ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                          source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.customer_subscription (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                              subscription_id BIGINT,
                                              customer_id BIGINT,
                                              plan_id BIGINT,
                                              start_date DATE,
                                              end_date DATE,
                                              status VARCHAR(50),
                                              auto_renew BOOLEAN,
                                              ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                              source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.content (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                content_id BIGINT,
                                content_type_id BIGINT,
                                title VARCHAR(255),
                                release_date DATE,
                                duration_minutes INT,
                                language VARCHAR(100),
                                age_rating VARCHAR(50),
                                ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.content_type (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                     content_type_id BIGINT,
                                     content_type VARCHAR(100),
                                     ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.genre (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                              genre_id BIGINT,
                              genre_name VARCHAR(100),
                              ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.content_genre (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                      content_id BIGINT,
                                      genre_id BIGINT,
                                      ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                      source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.streaming_session (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                          stream_id BIGINT,
                                          customer_id BIGINT,
                                          content_id BIGINT,
                                          device_id BIGINT,
                                          start_time TIMESTAMP,
                                          end_time TIMESTAMP,
                                          watch_duration INT,
                                          completion_percentage NUMERIC(5,2),
                                          ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                          source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.warehouse (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                  warehouse_id BIGINT,
                                  city_id BIGINT,
                                  warehouse_name VARCHAR(150),
                                  ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.inventory_item (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                       inventory_id BIGINT,
                                       content_id BIGINT,
                                       warehouse_id BIGINT,
                                       barcode VARCHAR(100),
                                       purchase_date DATE,
                                       item_condition VARCHAR(100),
                                       status VARCHAR(50),
                                       ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                       source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.rental (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                               rental_id BIGINT,
                               customer_id BIGINT,
                               inventory_id BIGINT,
                               rental_date DATE,
                               due_date DATE,
                               return_date DATE,
                               rental_fee NUMERIC(12,2),
                               late_fee NUMERIC(12,2),
                               status VARCHAR(50),
                               ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.payment (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                payment_id BIGINT,
                                customer_id BIGINT,
                                rental_id BIGINT,
                                subscription_id BIGINT,
                                payment_method_id BIGINT,
                                amount NUMERIC(12,2),
                                payment_date TIMESTAMP,
                                payment_type VARCHAR(50),
                                status VARCHAR(50),
                                ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.review (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                               review_id BIGINT,
                               customer_id BIGINT,
                               content_id BIGINT,
                               rating INT,
                               review_text TEXT,
                               review_date TIMESTAMP,
                               ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.wishlist (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                 wishlist_id BIGINT,
                                 customer_id BIGINT,
                                 content_id BIGINT,
                                 added_date TIMESTAMP,
                                 ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                 source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.support_ticket (
    bronze_row_id BIGSERIAL PRIMARY KEY,
                                       ticket_id BIGINT,
                                       customer_id BIGINT,
                                       category_id BIGINT,
                                       opened_date TIMESTAMP,
                                       closed_date TIMESTAMP,
                                       priority VARCHAR(50),
                                       status VARCHAR(50),
                                       ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                       source_system VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS bronze.artist (
                                             bronze_row_id BIGSERIAL PRIMARY KEY,
                                             artist_id BIGINT,
                                             artist_name VARCHAR(255),
                                             country VARCHAR(100),
                                             ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                             source_system VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS bronze.content_artist (
                                                     bronze_row_id BIGSERIAL PRIMARY KEY,
                                                     content_id BIGINT,
                                                     artist_id BIGINT,
                                                     role VARCHAR(100),
                                                     ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                     source_system VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS bronze.device (
                                             bronze_row_id BIGSERIAL PRIMARY KEY,
                                             device_id BIGINT,
                                             device_name VARCHAR(150),
                                             ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                             source_system VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS bronze.payment_method (
                                                     bronze_row_id BIGSERIAL PRIMARY KEY,
                                                     payment_method_id BIGINT,
                                                     method_name VARCHAR(100),
                                                     ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                     source_system VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS bronze.support_category (
                                                       bronze_row_id BIGSERIAL PRIMARY KEY,
                                                       category_id BIGINT,
                                                       category_name VARCHAR(150),
                                                       ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                       source_system VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS bronze.courier (
                                              bronze_row_id BIGSERIAL PRIMARY KEY,
                                              courier_id BIGINT,
                                              courier_name VARCHAR(150),
                                              ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                              source_system VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS bronze.delivery (
                                               bronze_row_id BIGSERIAL PRIMARY KEY,
                                               delivery_id BIGINT,
                                               rental_id BIGINT,
                                               courier_id BIGINT,
                                               dispatch_date TIMESTAMP,
                                               delivered_date TIMESTAMP,
                                               returned_date TIMESTAMP,
                                               delivery_status VARCHAR(50),
                                               ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                               source_system VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS bronze.recommendation (
                                                     bronze_row_id BIGSERIAL PRIMARY KEY,
                                                     recommendation_id BIGINT,
                                                     customer_id BIGINT,
                                                     content_id BIGINT,
                                                     recommendation_date TIMESTAMP,
                                                     algorithm_version VARCHAR(100),
                                                     clicked BOOLEAN,
                                                     ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                     source_system VARCHAR(100)
);