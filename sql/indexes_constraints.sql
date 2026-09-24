-- ============================================================
-- File: indexes_constraints.sql
-- Purpose: Add helpful indexes for ETL joins and analytical queries.
-- Run after all Bronze, Silver, Gold and ETL tables are created.
-- ============================================================

-- Bronze source/business-key indexes
CREATE INDEX IF NOT EXISTS idx_bronze_customer_customer_id
    ON bronze.customer(customer_id);
CREATE INDEX IF NOT EXISTS idx_bronze_stream_customer_date
    ON bronze.streaming_session(customer_id, start_time);
CREATE INDEX IF NOT EXISTS idx_bronze_rental_customer_date
    ON bronze.rental(customer_id, rental_date);
CREATE INDEX IF NOT EXISTS idx_bronze_payment_customer_date
    ON bronze.payment(customer_id, payment_date);
CREATE INDEX IF NOT EXISTS idx_bronze_inventory_content_warehouse
    ON bronze.inventory_item(content_id, warehouse_id);

-- Silver Data Vault lookup indexes
CREATE INDEX IF NOT EXISTS idx_hub_customer_business_key
    ON silver.hub_customer(customer_id);
CREATE INDEX IF NOT EXISTS idx_hub_content_business_key
    ON silver.hub_content(content_id);
CREATE INDEX IF NOT EXISTS idx_hub_rental_business_key
    ON silver.hub_rental(rental_id);
CREATE INDEX IF NOT EXISTS idx_hub_inventory_business_key
    ON silver.hub_inventory(inventory_id);

-- Gold dimension business-key indexes
CREATE INDEX IF NOT EXISTS idx_dim_customer_customer_id
    ON gold.dim_customer(customer_id);
CREATE INDEX IF NOT EXISTS idx_dim_content_content_id
    ON gold.dim_content(content_id);
CREATE INDEX IF NOT EXISTS idx_dim_inventory_inventory_id
    ON gold.dim_inventory(inventory_id);
CREATE INDEX IF NOT EXISTS idx_dim_warehouse_warehouse_id
    ON gold.dim_warehouse(warehouse_id);

-- Gold fact foreign-key indexes
CREATE INDEX IF NOT EXISTS idx_fact_customer_daily_customer_date
    ON gold.fact_customer_daily_activity(customer_key, date_key);
CREATE INDEX IF NOT EXISTS idx_fact_content_monthly_content_month
    ON gold.fact_content_monthly_performance(content_key, month_key);
CREATE INDEX IF NOT EXISTS idx_fact_inventory_daily_inventory_date
    ON gold.fact_inventory_daily_utilisation(inventory_key, date_key);
