# SQL execution order

Use psql with `ON_ERROR_STOP=1`. Paths below assume the project root, or `/input` inside the Compose PostgreSQL container. See [setup notes](../docs/setup_notes.md) for database creation and CSV loading.

## 1. Operational tables

Run only on a new, empty source database: this script drops and recreates `public`.

```sql
\connect abc_hub_operational
\i sql/operational_schema.sql
```

Then load the operational CSVs using the setup notes.

## 2. Analytics tables

Run these scripts in this order against the existing `abc_hub_analytics` database:

```sql
\connect abc_hub_analytics
\i sql/setup.sql
\i sql/bronze_tables.sql
\i sql/silver_hubs.sql
\i sql/silver_links.sql
\i sql/silver_satellites.sql
\i sql/gold_dimensions.sql
\i sql/gold_facts.sql
\i sql/indexes_constraints.sql
```

This creates the three schemas and 54 tables: 26 Bronze, 15 Silver, and 13 Gold. Hubs precede links/satellites; dimensions precede facts; indexes come last. `IF NOT EXISTS` does not update an existing table definition.

## 3. Run ETL, then validate

NiFi loading order: **Bronze -> Silver Core -> Silver Links -> Gold Dimensions -> Gold Facts**. This is the data-loading order; it differs from table-creation order.

After all stages finish:

```sql
\connect abc_hub_analytics
\i sql/validation_queries.sql
```

Review row counts, duplicate keys, missing relationships, and fact grains. Compare with the source counts; empty tables passing checks do not prove a successful load. The validation script is read-only and reports issues without automatically failing on nonzero findings.
