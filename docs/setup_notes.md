# Setup notes

## 1. Start NiFi and PostgreSQL

Install Docker Desktop. For Compose, create a local `.env` file in the project root with these settings:

```dotenv
POSTGRES_USER=abc_hub
POSTGRES_PASSWORD=
POSTGRES_PORT=5433
NIFI_USERNAME=admin
NIFI_PASSWORD=
NIFI_SENSITIVE_PROPS_KEY=
NIFI_PORT=9443
ABC_HUB_DATA_DIR=./data
```

Fill the three blank values with private values: separate PostgreSQL and NiFi passwords (NiFi requires at least 12 characters), and a stable sensitive-properties key. Keep that key unchanged when reusing NiFi volumes. Do not commit `.env`. Run from the project root in PowerShell:

```powershell
docker compose up --build -d
docker compose ps
```

The [Dockerfile](../Dockerfile) installs NiFi 2.10.0 and the PostgreSQL JDBC driver automatically. No separate driver download is needed. Open **https://localhost:9443/nifi/** and sign in with `NIFI_USERNAME` / `NIFI_PASSWORD` from `.env`. The local certificate is self-signed. PostgreSQL is available on host port **5433**; Compose preserves service data in named volumes.

## 2. Create databases and operational tables

Open psql in the container (replace `abc_hub` if you changed `POSTGRES_USER`):

```powershell
docker compose exec postgres psql -X -v ON_ERROR_STOP=1 -U abc_hub -d postgres
```

On a fresh Compose volume, `abc_hub_operational` already exists. Create analytics and load the operational schema:

```sql
\cd /input
CREATE DATABASE abc_hub_analytics;
\connect abc_hub_operational
\i sql/operational_schema.sql
```

Skip database creation if it already exists. **The operational schema drops and recreates `public`; use it only on an empty operational database.** If your source is already populated, skip schema creation and CSV loading.

## 3. Load operational CSVs

In the same psql session, run the following on empty tables. `\copy` reads the mounted CSVs in parent-before-child order; it is a psql command, not generic SQL.

```sql
BEGIN;
\copy public.country FROM 'data/country_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.city FROM 'data/city_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.content_type FROM 'data/content_type_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.genre FROM 'data/genre_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.artist FROM 'data/artist_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.device FROM 'data/device_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.payment_method FROM 'data/payment_method_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.support_category FROM 'data/support_category_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.courier FROM 'data/courier_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.warehouse FROM 'data/warehouse_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.subscription_plan FROM 'data/subscription_plan_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.customer FROM 'data/customer_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.customer_address FROM 'data/customer_address_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.customer_subscription FROM 'data/customer_subscription_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.content FROM 'data/content_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.content_genre FROM 'data/content_genre_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.content_artist FROM 'data/content_artist_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.inventory_item FROM 'data/inventory_item_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.streaming_session FROM 'data/streaming_session_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.rental FROM 'data/rental_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.delivery FROM 'data/delivery_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.payment FROM 'data/payment_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.review FROM 'data/review_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.wishlist FROM 'data/wishlist_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.support_ticket FROM 'data/support_ticket_sample.csv' WITH (FORMAT csv, HEADER true)
\copy public.recommendation FROM 'data/recommendation_sample.csv' WITH (FORMAT csv, HEADER true)
COMMIT;
```

If loading fails, run `ROLLBACK;`, correct the input, and retry the full transaction. The samples contain 99 rows selected from the course package with required parent rows. Personal fields are anonymized; 11 duration values were formatted as integers without changing their values.

For **full course data**, set `ABC_HUB_DATA_DIR` to the folder containing the 26 original CSVs and rerun `docker compose up -d`. Remove `_sample` from the filenames above. Replace the content copy line with this block because raw durations can be written as `4.0`:

```sql
CREATE TEMP TABLE content_import (LIKE public.content);
ALTER TABLE content_import ALTER COLUMN duration_minutes TYPE NUMERIC;
ALTER TABLE content_import ADD CHECK (duration_minutes = trunc(duration_minutes));
\copy content_import FROM 'data/content.csv' WITH (FORMAT csv, HEADER true)
INSERT INTO public.content SELECT * FROM content_import;
DROP TABLE content_import;
```

## 4. Create warehouse tables

Follow [SQL execution order](../sql/README.md#2-analytics-tables) in the same psql session. This creates the Bronze, Silver, and Gold tables before NiFi runs.

## 5. Import NiFi and configure JDBC

Import [ABC_HUB_ETL.json](../nifi/ABC_HUB_ETL.json) as a process group. Keep processors stopped and configure its two DBCP controller services:

| Setting | Operational pool | Analytics pool |
| --- | --- | --- |
| Database Connection URL | `jdbc:postgresql://postgres:5432/abc_hub_operational` | `jdbc:postgresql://postgres:5432/abc_hub_analytics` |
| Database Driver Class Name | `org.postgresql.Driver` | `org.postgresql.Driver` |
| Database Driver Locations | `/opt/nifi/drivers/postgresql-42.7.12.jar` | `/opt/nifi/drivers/postgresql-42.7.12.jar` |
| Database User / Password | PostgreSQL credentials from `.env` | Same credentials |

Enter credentials in NiFi; `.env` does not configure these pools automatically. Enable both pools, `AvroReader`, and `AvroRecordSetWriter`. Resolve validation errors, then follow the [ETL run order](../README.md#10-how-to-run). Keep the independent triggers controlled and wait for each stage to finish.

## Alternative: NiFi with existing PostgreSQL

Use this instead of Compose when PostgreSQL already runs on your computer:

```powershell
docker build -t abc-hub-nifi .
docker run -d --name abc-hub-nifi -p 127.0.0.1:9443:8443 --add-host host.docker.internal:host-gateway -e NIFI_WEB_HTTPS_HOST=0.0.0.0 -e NIFI_WEB_PROXY_HOST=localhost:9443,127.0.0.1:9443 -e NIFI_JVM_HEAP_INIT=512m -e NIFI_JVM_HEAP_MAX=1g abc-hub-nifi
docker logs abc-hub-nifi 2>&1 | Select-String 'Generated Username|Generated Password'
```

Use the generated login locally. Set the JDBC host/port to `host.docker.internal:5432` (adjust to your PostgreSQL port). PostgreSQL must accept connections from Docker. The driver path stays the same.

For database setup, open local `psql` from the project root, create `abc_hub_operational` if missing, and follow steps 2-4 **without** `\cd /input`; local `sql/` and `data/` paths are used. Resume this NiFi container with `docker stop abc-hub-nifi` / `docker start abc-hub-nifi`.
