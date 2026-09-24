-- =========================
-- GOLD DIMENSIONS
-- =========================

CREATE TABLE IF NOT EXISTS gold.dim_customer (
                                   customer_key BIGSERIAL PRIMARY KEY,
                                   customer_id BIGINT NOT NULL UNIQUE,
                                   customer_no VARCHAR(50),
                                   first_name VARCHAR(100),
                                   last_name VARCHAR(100),
                                   status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS gold.dim_date (
                               date_key INT PRIMARY KEY,
                               full_date DATE NOT NULL UNIQUE,
                               day INT NOT NULL,
                               month INT NOT NULL,
                               month_name VARCHAR(20),
                               quarter INT NOT NULL,
                               year INT NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.dim_month (
                                month_key INT PRIMARY KEY,
                                month INT NOT NULL,
                                month_name VARCHAR(20),
                                quarter INT NOT NULL,
                                year INT NOT NULL,

                                UNIQUE (year, month)
);

CREATE TABLE IF NOT EXISTS gold.dim_location (
                                   location_key BIGSERIAL PRIMARY KEY,
                                   city_id BIGINT,
                                   city_name VARCHAR(100),
                                   country_id BIGINT,
                                   country_name VARCHAR(100),
                                   country_code VARCHAR(20),
    CONSTRAINT uq_dim_location_city_country UNIQUE (city_id, country_id)
);

CREATE TABLE IF NOT EXISTS gold.dim_subscription_plan (
                                            subscription_plan_key BIGSERIAL PRIMARY KEY,
                                            plan_id BIGINT NOT NULL UNIQUE,
                                            plan_name VARCHAR(100),
                                            monthly_fee NUMERIC(12,2),
                                            video_quality VARCHAR(50),
                                            max_devices INT
);

CREATE TABLE IF NOT EXISTS gold.dim_content (
                                  content_key BIGSERIAL PRIMARY KEY,
                                  content_id BIGINT NOT NULL UNIQUE,
                                  title VARCHAR(255),
                                  release_date DATE,
                                  duration_minutes INT,
                                  language VARCHAR(100),
                                  age_rating VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS gold.dim_content_type (
                                       content_type_key BIGSERIAL PRIMARY KEY,
                                       content_type_id BIGINT NOT NULL UNIQUE,
                                       content_type VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS gold.dim_genre (
                                genre_key BIGSERIAL PRIMARY KEY,
                                genre_id BIGINT NOT NULL UNIQUE,
                                genre_name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS gold.dim_inventory (
                                    inventory_key BIGSERIAL PRIMARY KEY,
                                    inventory_id BIGINT NOT NULL UNIQUE,
                                    barcode VARCHAR(100),
                                    purchase_date DATE,
                                    item_condition VARCHAR(100),
                                    status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS gold.dim_warehouse (
                                    warehouse_key BIGSERIAL PRIMARY KEY,
                                    warehouse_id BIGINT NOT NULL UNIQUE,
                                    warehouse_name VARCHAR(150),
                                    city_name VARCHAR(100),
                                    country_name VARCHAR(100)
);