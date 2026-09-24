-- ABC Hub: read-only validation against abc_hub_analytics.
-- Newly authored from existing DDL; no standalone validation SQL was supplied.
-- Run after all layer loads finish. Exact counts can scan large tables.
-- Row counts are informational: compare against the expected source snapshot.
-- Other results are issue counts: investigate nonzero values. Zero counts on
-- empty tables do not prove that data was loaded successfully.
-- Bronze repeated keys may represent intentional historical versions.
-- content_artist business key from the operational schema: (content_id, artist_id).
-- Orphan checks exclude nullable foreign keys when the value is NULL.
-- Positive issue counts are reported; they do not raise SQL exceptions.

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ READ ONLY;

-- BRONZE row counts
SELECT 'bronze.artist' AS table_name, COUNT(*) AS row_count FROM bronze.artist
UNION ALL
SELECT 'bronze.city' AS table_name, COUNT(*) AS row_count FROM bronze.city
UNION ALL
SELECT 'bronze.content' AS table_name, COUNT(*) AS row_count FROM bronze.content
UNION ALL
SELECT 'bronze.content_artist' AS table_name, COUNT(*) AS row_count FROM bronze.content_artist
UNION ALL
SELECT 'bronze.content_genre' AS table_name, COUNT(*) AS row_count FROM bronze.content_genre
UNION ALL
SELECT 'bronze.content_type' AS table_name, COUNT(*) AS row_count FROM bronze.content_type
UNION ALL
SELECT 'bronze.country' AS table_name, COUNT(*) AS row_count FROM bronze.country
UNION ALL
SELECT 'bronze.courier' AS table_name, COUNT(*) AS row_count FROM bronze.courier
UNION ALL
SELECT 'bronze.customer' AS table_name, COUNT(*) AS row_count FROM bronze.customer
UNION ALL
SELECT 'bronze.customer_address' AS table_name, COUNT(*) AS row_count FROM bronze.customer_address
UNION ALL
SELECT 'bronze.customer_subscription' AS table_name, COUNT(*) AS row_count FROM bronze.customer_subscription
UNION ALL
SELECT 'bronze.delivery' AS table_name, COUNT(*) AS row_count FROM bronze.delivery
UNION ALL
SELECT 'bronze.device' AS table_name, COUNT(*) AS row_count FROM bronze.device
UNION ALL
SELECT 'bronze.genre' AS table_name, COUNT(*) AS row_count FROM bronze.genre
UNION ALL
SELECT 'bronze.inventory_item' AS table_name, COUNT(*) AS row_count FROM bronze.inventory_item
UNION ALL
SELECT 'bronze.payment' AS table_name, COUNT(*) AS row_count FROM bronze.payment
UNION ALL
SELECT 'bronze.payment_method' AS table_name, COUNT(*) AS row_count FROM bronze.payment_method
UNION ALL
SELECT 'bronze.recommendation' AS table_name, COUNT(*) AS row_count FROM bronze.recommendation
UNION ALL
SELECT 'bronze.rental' AS table_name, COUNT(*) AS row_count FROM bronze.rental
UNION ALL
SELECT 'bronze.review' AS table_name, COUNT(*) AS row_count FROM bronze.review
UNION ALL
SELECT 'bronze.streaming_session' AS table_name, COUNT(*) AS row_count FROM bronze.streaming_session
UNION ALL
SELECT 'bronze.subscription_plan' AS table_name, COUNT(*) AS row_count FROM bronze.subscription_plan
UNION ALL
SELECT 'bronze.support_category' AS table_name, COUNT(*) AS row_count FROM bronze.support_category
UNION ALL
SELECT 'bronze.support_ticket' AS table_name, COUNT(*) AS row_count FROM bronze.support_ticket
UNION ALL
SELECT 'bronze.warehouse' AS table_name, COUNT(*) AS row_count FROM bronze.warehouse
UNION ALL
SELECT 'bronze.wishlist' AS table_name, COUNT(*) AS row_count FROM bronze.wishlist
ORDER BY 1;

-- SILVER row counts
SELECT 'silver.hub_content' AS table_name, COUNT(*) AS row_count FROM silver.hub_content
UNION ALL
SELECT 'silver.hub_customer' AS table_name, COUNT(*) AS row_count FROM silver.hub_customer
UNION ALL
SELECT 'silver.hub_inventory' AS table_name, COUNT(*) AS row_count FROM silver.hub_inventory
UNION ALL
SELECT 'silver.hub_payment' AS table_name, COUNT(*) AS row_count FROM silver.hub_payment
UNION ALL
SELECT 'silver.hub_rental' AS table_name, COUNT(*) AS row_count FROM silver.hub_rental
UNION ALL
SELECT 'silver.hub_subscription' AS table_name, COUNT(*) AS row_count FROM silver.hub_subscription
UNION ALL
SELECT 'silver.link_content_inventory' AS table_name, COUNT(*) AS row_count FROM silver.link_content_inventory
UNION ALL
SELECT 'silver.link_customer_payment' AS table_name, COUNT(*) AS row_count FROM silver.link_customer_payment
UNION ALL
SELECT 'silver.link_customer_rental' AS table_name, COUNT(*) AS row_count FROM silver.link_customer_rental
UNION ALL
SELECT 'silver.link_customer_subscription' AS table_name, COUNT(*) AS row_count FROM silver.link_customer_subscription
UNION ALL
SELECT 'silver.sat_content' AS table_name, COUNT(*) AS row_count FROM silver.sat_content
UNION ALL
SELECT 'silver.sat_customer' AS table_name, COUNT(*) AS row_count FROM silver.sat_customer
UNION ALL
SELECT 'silver.sat_inventory' AS table_name, COUNT(*) AS row_count FROM silver.sat_inventory
UNION ALL
SELECT 'silver.sat_payment' AS table_name, COUNT(*) AS row_count FROM silver.sat_payment
UNION ALL
SELECT 'silver.sat_rental' AS table_name, COUNT(*) AS row_count FROM silver.sat_rental
ORDER BY 1;

-- GOLD row counts
SELECT 'gold.dim_content' AS table_name, COUNT(*) AS row_count FROM gold.dim_content
UNION ALL
SELECT 'gold.dim_content_type' AS table_name, COUNT(*) AS row_count FROM gold.dim_content_type
UNION ALL
SELECT 'gold.dim_customer' AS table_name, COUNT(*) AS row_count FROM gold.dim_customer
UNION ALL
SELECT 'gold.dim_date' AS table_name, COUNT(*) AS row_count FROM gold.dim_date
UNION ALL
SELECT 'gold.dim_genre' AS table_name, COUNT(*) AS row_count FROM gold.dim_genre
UNION ALL
SELECT 'gold.dim_inventory' AS table_name, COUNT(*) AS row_count FROM gold.dim_inventory
UNION ALL
SELECT 'gold.dim_location' AS table_name, COUNT(*) AS row_count FROM gold.dim_location
UNION ALL
SELECT 'gold.dim_month' AS table_name, COUNT(*) AS row_count FROM gold.dim_month
UNION ALL
SELECT 'gold.dim_subscription_plan' AS table_name, COUNT(*) AS row_count FROM gold.dim_subscription_plan
UNION ALL
SELECT 'gold.dim_warehouse' AS table_name, COUNT(*) AS row_count FROM gold.dim_warehouse
UNION ALL
SELECT 'gold.fact_content_monthly_performance' AS table_name, COUNT(*) AS row_count FROM gold.fact_content_monthly_performance
UNION ALL
SELECT 'gold.fact_customer_daily_activity' AS table_name, COUNT(*) AS row_count FROM gold.fact_customer_daily_activity
UNION ALL
SELECT 'gold.fact_inventory_daily_utilisation' AS table_name, COUNT(*) AS row_count FROM gold.fact_inventory_daily_utilisation
ORDER BY 1;

-- Bronze duplicate candidate business keys
SELECT 'bronze.artist' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT artist_id FROM bronze.artist
      GROUP BY artist_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.city' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT city_id FROM bronze.city
      GROUP BY city_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.content' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT content_id FROM bronze.content
      GROUP BY content_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.content_artist' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT content_id, artist_id FROM bronze.content_artist
      GROUP BY content_id, artist_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.content_genre' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT content_id, genre_id FROM bronze.content_genre
      GROUP BY content_id, genre_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.content_type' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT content_type_id FROM bronze.content_type
      GROUP BY content_type_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.country' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT country_id FROM bronze.country
      GROUP BY country_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.courier' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT courier_id FROM bronze.courier
      GROUP BY courier_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.customer' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT customer_id FROM bronze.customer
      GROUP BY customer_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.customer_address' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT address_id FROM bronze.customer_address
      GROUP BY address_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.customer_subscription' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT subscription_id FROM bronze.customer_subscription
      GROUP BY subscription_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.delivery' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT delivery_id FROM bronze.delivery
      GROUP BY delivery_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.device' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT device_id FROM bronze.device
      GROUP BY device_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.genre' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT genre_id FROM bronze.genre
      GROUP BY genre_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.inventory_item' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT inventory_id FROM bronze.inventory_item
      GROUP BY inventory_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.payment' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT payment_id FROM bronze.payment
      GROUP BY payment_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.payment_method' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT payment_method_id FROM bronze.payment_method
      GROUP BY payment_method_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.recommendation' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT recommendation_id FROM bronze.recommendation
      GROUP BY recommendation_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.rental' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT rental_id FROM bronze.rental
      GROUP BY rental_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.review' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT review_id FROM bronze.review
      GROUP BY review_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.streaming_session' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT stream_id FROM bronze.streaming_session
      GROUP BY stream_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.subscription_plan' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT plan_id FROM bronze.subscription_plan
      GROUP BY plan_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.support_category' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT category_id FROM bronze.support_category
      GROUP BY category_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.support_ticket' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT ticket_id FROM bronze.support_ticket
      GROUP BY ticket_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.warehouse' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT warehouse_id FROM bronze.warehouse
      GROUP BY warehouse_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'bronze.wishlist' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT wishlist_id FROM bronze.wishlist
      GROUP BY wishlist_id HAVING COUNT(*) > 1) AS duplicates
ORDER BY 1;

-- Bronze missing business identifiers
SELECT 'bronze.artist' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.artist WHERE artist_id IS NULL
UNION ALL
SELECT 'bronze.city' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.city WHERE city_id IS NULL
UNION ALL
SELECT 'bronze.content' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.content WHERE content_id IS NULL
UNION ALL
SELECT 'bronze.content_artist' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.content_artist WHERE content_id IS NULL OR artist_id IS NULL
UNION ALL
SELECT 'bronze.content_genre' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.content_genre WHERE content_id IS NULL OR genre_id IS NULL
UNION ALL
SELECT 'bronze.content_type' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.content_type WHERE content_type_id IS NULL
UNION ALL
SELECT 'bronze.country' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.country WHERE country_id IS NULL
UNION ALL
SELECT 'bronze.courier' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.courier WHERE courier_id IS NULL
UNION ALL
SELECT 'bronze.customer' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.customer WHERE customer_id IS NULL
UNION ALL
SELECT 'bronze.customer_address' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.customer_address WHERE address_id IS NULL
UNION ALL
SELECT 'bronze.customer_subscription' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.customer_subscription WHERE subscription_id IS NULL
UNION ALL
SELECT 'bronze.delivery' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.delivery WHERE delivery_id IS NULL
UNION ALL
SELECT 'bronze.device' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.device WHERE device_id IS NULL
UNION ALL
SELECT 'bronze.genre' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.genre WHERE genre_id IS NULL
UNION ALL
SELECT 'bronze.inventory_item' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.inventory_item WHERE inventory_id IS NULL
UNION ALL
SELECT 'bronze.payment' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.payment WHERE payment_id IS NULL
UNION ALL
SELECT 'bronze.payment_method' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.payment_method WHERE payment_method_id IS NULL
UNION ALL
SELECT 'bronze.recommendation' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.recommendation WHERE recommendation_id IS NULL
UNION ALL
SELECT 'bronze.rental' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.rental WHERE rental_id IS NULL
UNION ALL
SELECT 'bronze.review' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.review WHERE review_id IS NULL
UNION ALL
SELECT 'bronze.streaming_session' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.streaming_session WHERE stream_id IS NULL
UNION ALL
SELECT 'bronze.subscription_plan' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.subscription_plan WHERE plan_id IS NULL
UNION ALL
SELECT 'bronze.support_category' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.support_category WHERE category_id IS NULL
UNION ALL
SELECT 'bronze.support_ticket' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.support_ticket WHERE ticket_id IS NULL
UNION ALL
SELECT 'bronze.warehouse' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.warehouse WHERE warehouse_id IS NULL
UNION ALL
SELECT 'bronze.wishlist' AS table_name, COUNT(*) AS missing_key_rows
FROM bronze.wishlist WHERE wishlist_id IS NULL
ORDER BY 1;

-- Silver duplicate hub business keys, link endpoints, satellite versions
SELECT 'silver.hub_content' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT content_id FROM silver.hub_content
      GROUP BY content_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.hub_customer' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT customer_id FROM silver.hub_customer
      GROUP BY customer_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.hub_inventory' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT inventory_id FROM silver.hub_inventory
      GROUP BY inventory_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.hub_payment' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT payment_id FROM silver.hub_payment
      GROUP BY payment_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.hub_rental' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT rental_id FROM silver.hub_rental
      GROUP BY rental_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.hub_subscription' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT subscription_id FROM silver.hub_subscription
      GROUP BY subscription_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.link_content_inventory' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT content_hk, inventory_hk FROM silver.link_content_inventory
      GROUP BY content_hk, inventory_hk HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.link_customer_payment' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT customer_hk, payment_hk FROM silver.link_customer_payment
      GROUP BY customer_hk, payment_hk HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.link_customer_rental' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT customer_hk, rental_hk FROM silver.link_customer_rental
      GROUP BY customer_hk, rental_hk HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.link_customer_subscription' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT customer_hk, subscription_hk FROM silver.link_customer_subscription
      GROUP BY customer_hk, subscription_hk HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.sat_content' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT content_hk, load_date FROM silver.sat_content
      GROUP BY content_hk, load_date HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.sat_customer' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT customer_hk, load_date FROM silver.sat_customer
      GROUP BY customer_hk, load_date HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.sat_inventory' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT inventory_hk, load_date FROM silver.sat_inventory
      GROUP BY inventory_hk, load_date HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.sat_payment' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT payment_hk, load_date FROM silver.sat_payment
      GROUP BY payment_hk, load_date HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'silver.sat_rental' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT rental_hk, load_date FROM silver.sat_rental
      GROUP BY rental_hk, load_date HAVING COUNT(*) > 1) AS duplicates
ORDER BY 1;

-- Gold duplicate dimension business keys
SELECT 'gold.dim_content' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT content_id FROM gold.dim_content
      GROUP BY content_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'gold.dim_content_type' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT content_type_id FROM gold.dim_content_type
      GROUP BY content_type_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'gold.dim_customer' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT customer_id FROM gold.dim_customer
      GROUP BY customer_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'gold.dim_date' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT full_date FROM gold.dim_date
      GROUP BY full_date HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'gold.dim_genre' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT genre_id FROM gold.dim_genre
      GROUP BY genre_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'gold.dim_inventory' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT inventory_id FROM gold.dim_inventory
      GROUP BY inventory_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'gold.dim_location' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT city_id, country_id FROM gold.dim_location
      GROUP BY city_id, country_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'gold.dim_month' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT year, month FROM gold.dim_month
      GROUP BY year, month HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'gold.dim_subscription_plan' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT plan_id FROM gold.dim_subscription_plan
      GROUP BY plan_id HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'gold.dim_warehouse' AS table_name, COUNT(*) AS duplicate_key_groups
FROM (SELECT warehouse_id FROM gold.dim_warehouse
      GROUP BY warehouse_id HAVING COUNT(*) > 1) AS duplicates
ORDER BY 1;

-- Gold duplicate fact grains: customer/day, content/month, inventory/day
SELECT 'gold.fact_content_monthly_performance' AS table_name, COUNT(*) AS duplicate_grain_groups
FROM (SELECT content_key, month_key FROM gold.fact_content_monthly_performance
      GROUP BY content_key, month_key HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'gold.fact_customer_daily_activity' AS table_name, COUNT(*) AS duplicate_grain_groups
FROM (SELECT customer_key, date_key FROM gold.fact_customer_daily_activity
      GROUP BY customer_key, date_key HAVING COUNT(*) > 1) AS duplicates
UNION ALL
SELECT 'gold.fact_inventory_daily_utilisation' AS table_name, COUNT(*) AS duplicate_grain_groups
FROM (SELECT inventory_key, date_key FROM gold.fact_inventory_daily_utilisation
      GROUP BY inventory_key, date_key HAVING COUNT(*) > 1) AS duplicates
ORDER BY 1;

-- All declared Silver and Gold foreign-key / orphan checks
SELECT 'gold.fact_content_monthly_performance.content_key -> gold.dim_content.content_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_content_monthly_performance AS child
WHERE child.content_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_content AS parent WHERE parent.content_key = child.content_key)
UNION ALL
SELECT 'gold.fact_content_monthly_performance.month_key -> gold.dim_month.month_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_content_monthly_performance AS child
WHERE child.month_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_month AS parent WHERE parent.month_key = child.month_key)
UNION ALL
SELECT 'gold.fact_content_monthly_performance.content_type_key -> gold.dim_content_type.content_type_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_content_monthly_performance AS child
WHERE child.content_type_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_content_type AS parent WHERE parent.content_type_key = child.content_type_key)
UNION ALL
SELECT 'gold.fact_content_monthly_performance.genre_key -> gold.dim_genre.genre_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_content_monthly_performance AS child
WHERE child.genre_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_genre AS parent WHERE parent.genre_key = child.genre_key)
UNION ALL
SELECT 'gold.fact_customer_daily_activity.customer_key -> gold.dim_customer.customer_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_customer_daily_activity AS child
WHERE child.customer_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_customer AS parent WHERE parent.customer_key = child.customer_key)
UNION ALL
SELECT 'gold.fact_customer_daily_activity.date_key -> gold.dim_date.date_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_customer_daily_activity AS child
WHERE child.date_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_date AS parent WHERE parent.date_key = child.date_key)
UNION ALL
SELECT 'gold.fact_customer_daily_activity.location_key -> gold.dim_location.location_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_customer_daily_activity AS child
WHERE child.location_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_location AS parent WHERE parent.location_key = child.location_key)
UNION ALL
SELECT 'gold.fact_customer_daily_activity.subscription_plan_key -> gold.dim_subscription_plan.subscription_plan_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_customer_daily_activity AS child
WHERE child.subscription_plan_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_subscription_plan AS parent WHERE parent.subscription_plan_key = child.subscription_plan_key)
UNION ALL
SELECT 'gold.fact_inventory_daily_utilisation.inventory_key -> gold.dim_inventory.inventory_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_inventory_daily_utilisation AS child
WHERE child.inventory_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_inventory AS parent WHERE parent.inventory_key = child.inventory_key)
UNION ALL
SELECT 'gold.fact_inventory_daily_utilisation.date_key -> gold.dim_date.date_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_inventory_daily_utilisation AS child
WHERE child.date_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_date AS parent WHERE parent.date_key = child.date_key)
UNION ALL
SELECT 'gold.fact_inventory_daily_utilisation.content_key -> gold.dim_content.content_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_inventory_daily_utilisation AS child
WHERE child.content_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_content AS parent WHERE parent.content_key = child.content_key)
UNION ALL
SELECT 'gold.fact_inventory_daily_utilisation.warehouse_key -> gold.dim_warehouse.warehouse_key' AS relationship, COUNT(*) AS orphan_rows
FROM gold.fact_inventory_daily_utilisation AS child
WHERE child.warehouse_key IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM gold.dim_warehouse AS parent WHERE parent.warehouse_key = child.warehouse_key)
UNION ALL
SELECT 'silver.link_content_inventory.content_hk -> silver.hub_content.content_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.link_content_inventory AS child
WHERE child.content_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_content AS parent WHERE parent.content_hk = child.content_hk)
UNION ALL
SELECT 'silver.link_content_inventory.inventory_hk -> silver.hub_inventory.inventory_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.link_content_inventory AS child
WHERE child.inventory_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_inventory AS parent WHERE parent.inventory_hk = child.inventory_hk)
UNION ALL
SELECT 'silver.link_customer_payment.customer_hk -> silver.hub_customer.customer_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.link_customer_payment AS child
WHERE child.customer_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_customer AS parent WHERE parent.customer_hk = child.customer_hk)
UNION ALL
SELECT 'silver.link_customer_payment.payment_hk -> silver.hub_payment.payment_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.link_customer_payment AS child
WHERE child.payment_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_payment AS parent WHERE parent.payment_hk = child.payment_hk)
UNION ALL
SELECT 'silver.link_customer_rental.customer_hk -> silver.hub_customer.customer_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.link_customer_rental AS child
WHERE child.customer_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_customer AS parent WHERE parent.customer_hk = child.customer_hk)
UNION ALL
SELECT 'silver.link_customer_rental.rental_hk -> silver.hub_rental.rental_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.link_customer_rental AS child
WHERE child.rental_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_rental AS parent WHERE parent.rental_hk = child.rental_hk)
UNION ALL
SELECT 'silver.link_customer_subscription.customer_hk -> silver.hub_customer.customer_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.link_customer_subscription AS child
WHERE child.customer_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_customer AS parent WHERE parent.customer_hk = child.customer_hk)
UNION ALL
SELECT 'silver.link_customer_subscription.subscription_hk -> silver.hub_subscription.subscription_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.link_customer_subscription AS child
WHERE child.subscription_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_subscription AS parent WHERE parent.subscription_hk = child.subscription_hk)
UNION ALL
SELECT 'silver.sat_content.content_hk -> silver.hub_content.content_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.sat_content AS child
WHERE child.content_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_content AS parent WHERE parent.content_hk = child.content_hk)
UNION ALL
SELECT 'silver.sat_customer.customer_hk -> silver.hub_customer.customer_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.sat_customer AS child
WHERE child.customer_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_customer AS parent WHERE parent.customer_hk = child.customer_hk)
UNION ALL
SELECT 'silver.sat_inventory.inventory_hk -> silver.hub_inventory.inventory_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.sat_inventory AS child
WHERE child.inventory_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_inventory AS parent WHERE parent.inventory_hk = child.inventory_hk)
UNION ALL
SELECT 'silver.sat_payment.payment_hk -> silver.hub_payment.payment_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.sat_payment AS child
WHERE child.payment_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_payment AS parent WHERE parent.payment_hk = child.payment_hk)
UNION ALL
SELECT 'silver.sat_rental.rental_hk -> silver.hub_rental.rental_hk' AS relationship, COUNT(*) AS orphan_rows
FROM silver.sat_rental AS child
WHERE child.rental_hk IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM silver.hub_rental AS parent WHERE parent.rental_hk = child.rental_hk)
ORDER BY 1;

-- Silver hub coverage of non-null Bronze business keys
SELECT 'bronze.customer -> silver.hub_customer' AS relationship, COUNT(*) AS missing_hub_keys
FROM (SELECT DISTINCT customer_id FROM bronze.customer WHERE customer_id IS NOT NULL) AS b
WHERE NOT EXISTS (SELECT 1 FROM silver.hub_customer AS h WHERE h.customer_id = b.customer_id)
UNION ALL
SELECT 'bronze.content -> silver.hub_content' AS relationship, COUNT(*) AS missing_hub_keys
FROM (SELECT DISTINCT content_id FROM bronze.content WHERE content_id IS NOT NULL) AS b
WHERE NOT EXISTS (SELECT 1 FROM silver.hub_content AS h WHERE h.content_id = b.content_id)
UNION ALL
SELECT 'bronze.rental -> silver.hub_rental' AS relationship, COUNT(*) AS missing_hub_keys
FROM (SELECT DISTINCT rental_id FROM bronze.rental WHERE rental_id IS NOT NULL) AS b
WHERE NOT EXISTS (SELECT 1 FROM silver.hub_rental AS h WHERE h.rental_id = b.rental_id)
UNION ALL
SELECT 'bronze.inventory_item -> silver.hub_inventory' AS relationship, COUNT(*) AS missing_hub_keys
FROM (SELECT DISTINCT inventory_id FROM bronze.inventory_item WHERE inventory_id IS NOT NULL) AS b
WHERE NOT EXISTS (SELECT 1 FROM silver.hub_inventory AS h WHERE h.inventory_id = b.inventory_id)
UNION ALL
SELECT 'bronze.customer_subscription -> silver.hub_subscription' AS relationship, COUNT(*) AS missing_hub_keys
FROM (SELECT DISTINCT subscription_id FROM bronze.customer_subscription WHERE subscription_id IS NOT NULL) AS b
WHERE NOT EXISTS (SELECT 1 FROM silver.hub_subscription AS h WHERE h.subscription_id = b.subscription_id)
UNION ALL
SELECT 'bronze.payment -> silver.hub_payment' AS relationship, COUNT(*) AS missing_hub_keys
FROM (SELECT DISTINCT payment_id FROM bronze.payment WHERE payment_id IS NOT NULL) AS b
WHERE NOT EXISTS (SELECT 1 FROM silver.hub_payment AS h WHERE h.payment_id = b.payment_id)
ORDER BY 1;

-- Silver hubs without descriptive records: review after core loads finish
SELECT 'silver.hub_customer -> silver.sat_customer' AS relationship, COUNT(*) AS hubs_without_satellites
FROM silver.hub_customer AS h
WHERE NOT EXISTS (SELECT 1 FROM silver.sat_customer AS s WHERE s.customer_hk = h.customer_hk)
UNION ALL
SELECT 'silver.hub_content -> silver.sat_content' AS relationship, COUNT(*) AS hubs_without_satellites
FROM silver.hub_content AS h
WHERE NOT EXISTS (SELECT 1 FROM silver.sat_content AS s WHERE s.content_hk = h.content_hk)
UNION ALL
SELECT 'silver.hub_rental -> silver.sat_rental' AS relationship, COUNT(*) AS hubs_without_satellites
FROM silver.hub_rental AS h
WHERE NOT EXISTS (SELECT 1 FROM silver.sat_rental AS s WHERE s.rental_hk = h.rental_hk)
UNION ALL
SELECT 'silver.hub_inventory -> silver.sat_inventory' AS relationship, COUNT(*) AS hubs_without_satellites
FROM silver.hub_inventory AS h
WHERE NOT EXISTS (SELECT 1 FROM silver.sat_inventory AS s WHERE s.inventory_hk = h.inventory_hk)
UNION ALL
SELECT 'silver.hub_payment -> silver.sat_payment' AS relationship, COUNT(*) AS hubs_without_satellites
FROM silver.hub_payment AS h
WHERE NOT EXISTS (SELECT 1 FROM silver.sat_payment AS s WHERE s.payment_hk = h.payment_hk)
ORDER BY 1;

-- Silver expected links where both hubs exist; use with hub coverage checks
SELECT 'bronze.rental -> silver.link_customer_rental' AS relationship, COUNT(*) AS missing_link_pairs
FROM (SELECT DISTINCT a.customer_hk, z.rental_hk
      FROM bronze.rental AS b
      JOIN silver.hub_customer AS a ON a.customer_id = b.customer_id
      JOIN silver.hub_rental AS z ON z.rental_id = b.rental_id) AS expected
WHERE NOT EXISTS (SELECT 1 FROM silver.link_customer_rental AS l
                  WHERE l.customer_hk = expected.customer_hk AND l.rental_hk = expected.rental_hk)
UNION ALL
SELECT 'bronze.customer_subscription -> silver.link_customer_subscription' AS relationship, COUNT(*) AS missing_link_pairs
FROM (SELECT DISTINCT a.customer_hk, z.subscription_hk
      FROM bronze.customer_subscription AS b
      JOIN silver.hub_customer AS a ON a.customer_id = b.customer_id
      JOIN silver.hub_subscription AS z ON z.subscription_id = b.subscription_id) AS expected
WHERE NOT EXISTS (SELECT 1 FROM silver.link_customer_subscription AS l
                  WHERE l.customer_hk = expected.customer_hk AND l.subscription_hk = expected.subscription_hk)
UNION ALL
SELECT 'bronze.payment -> silver.link_customer_payment' AS relationship, COUNT(*) AS missing_link_pairs
FROM (SELECT DISTINCT a.customer_hk, z.payment_hk
      FROM bronze.payment AS b
      JOIN silver.hub_customer AS a ON a.customer_id = b.customer_id
      JOIN silver.hub_payment AS z ON z.payment_id = b.payment_id) AS expected
WHERE NOT EXISTS (SELECT 1 FROM silver.link_customer_payment AS l
                  WHERE l.customer_hk = expected.customer_hk AND l.payment_hk = expected.payment_hk)
UNION ALL
SELECT 'bronze.inventory_item -> silver.link_content_inventory' AS relationship, COUNT(*) AS missing_link_pairs
FROM (SELECT DISTINCT a.content_hk, z.inventory_hk
      FROM bronze.inventory_item AS b
      JOIN silver.hub_content AS a ON a.content_id = b.content_id
      JOIN silver.hub_inventory AS z ON z.inventory_id = b.inventory_id) AS expected
WHERE NOT EXISTS (SELECT 1 FROM silver.link_content_inventory AS l
                  WHERE l.content_hk = expected.content_hk AND l.inventory_hk = expected.inventory_hk)
ORDER BY 1;

COMMIT;
