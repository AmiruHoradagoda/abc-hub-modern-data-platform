# ABC Hub Modern Data Platform

**From streaming and rental records to customer, content, and inventory analytics.**

[Setup guide](docs/setup_notes.md) · [SQL execution order](sql/README.md) · [NiFi flow](nifi/ABC_HUB_ETL.json) · [Architecture](#3-architecture) · [Data models](#6-data-models) · [Pipeline screenshots](#7-etl-flow) · [Project report](docs/Final_Report.pdf)

## 1. Project Overview

A data engineering learning project built with **Apache NiFi and PostgreSQL**. It brings digital streaming and physical rental data through three warehouse layers: Bronze ingestion, Silver Data Vault, and Gold Kimball models.

| Source data | Warehouse | Analytical outputs |
| --- | --- | --- |
| 26 operational tables | 54 tables across 3 layers | 3 fact tables |
| 99 anonymized sample rows | 2 PostgreSQL databases | Customer, content, and inventory analysis |

The repository includes SQL, an importable NiFi flow, Docker configuration, sample CSVs, diagrams, and the final report.

## 2. Business Problem

Streaming, rentals, subscriptions, payments, and support each capture part of ABC Hub's activity. Combining them helps answer:

- **Customers:** How do engagement, rental activity, and spending change each day?
- **Content:** Which titles attract streams, rentals, revenue, and positive ratings?
- **Inventory:** How much is each physical item used, and where is capacity available?

![ABC Hub operational systems and customer interactions](docs/diagrams/source_systems_architecture.png)

*Source systems behind streaming, subscriptions, rentals, and customer support.*

## 3. Architecture

**Operational PostgreSQL → NiFi → Bronze → Silver Data Vault → Gold Kimball**

![End-to-end ABC Hub data platform architecture](docs/diagrams/end_to_end_data_platform.png)

*Platform design from operational sources through the warehouse to analytical use cases.*

`abc_hub_operational` stores source records. `abc_hub_analytics` contains the `bronze`, `silver`, and `gold` schemas. Some Gold transformations also read Bronze directly.

## 4. Tech Stack

| Technology | Role |
| --- | --- |
| Apache NiFi 2.10.0 | Visual ETL flows and database transfers |
| PostgreSQL + SQL | Operational storage, warehouse models, and validation |
| Docker / Compose | Run NiFi and optional PostgreSQL locally |
| PostgreSQL JDBC 42.7.12 | NiFi database connectivity; included in the Docker image |
| Data Vault + Kimball | Integrated business history and dimensional analytics |

## 5. Data Pipeline

### 5.1 Bronze Layer

**26 source-aligned tables** retain operational identifiers and ingestion metadata, giving downstream transformations a traceable source layer.

### 5.2 Silver Data Vault

**6 hubs, 4 links, and 5 satellites** separate business identities, relationships, and descriptive history. Hubs cover customer, content, rental, inventory, subscription, and payment.

![Silver Data Vault model with hubs, links, and satellites](docs/diagrams/data_vault_model.png)

*Business identities, their relationships, and descriptive history in Silver.*

### 5.3 Gold Kimball Layer

**10 dimensions and 3 facts** organize measures around customer, content, inventory, location, and time, making analytical queries easier to write.

## 6. Data Models

### 6.1 Customer Daily Activity

**Grain: one customer per day.** Measures streaming sessions and duration, rentals, returns, spending, and support tickets.

![Customer daily activity star schema](docs/diagrams/star_schema.png)

*Daily customer measures connected to customer, date, location, and subscription plan dimensions.*

### 6.2 Content Monthly Performance

**Grain: one content item per month.** Measures streams, rentals, revenue, average ratings, and wishlist additions.

![Content monthly performance star schema](docs/diagrams/content_monthly_performance_star_schema.png)

*Monthly content measures connected to content, month, content type, and genre dimensions.*

### 6.3 Inventory Daily Utilisation

**Grain: one inventory item per day.** Measures rentals, returns, availability, and utilisation, with content and warehouse context.

![Inventory daily utilisation star schema](docs/diagrams/inventory_daily_utilisation_star_schema.png)

*Daily inventory measures connected to inventory, date, content, and warehouse dimensions.*

## 7. ETL Flow

Import [ABC_HUB_ETL.json](nifi/ABC_HUB_ETL.json) to access the complete NiFi process group.

![Apache NiFi pipeline](docs/pipeline/nifi_pipeline.png)

*Overall NiFi process group, followed by the three layer views below. Screenshots are from the final report.*

### 7.1 Bronze Ingestion

Reads operational tables and writes source records to Bronze. Check ingestion results before continuing.

![Apache NiFi Bronze ingestion processors](docs/pipeline/bronze_flow.png)

*Operational-to-Bronze ingestion flow captured in the project report.*

### 7.2 Silver Core and Links

Run `CORE_TRIGGER` for hubs and satellites, then `LINK_TRIGGER` after hub keys exist.

![Apache NiFi Silver Core and Links flows](docs/pipeline/silver_flow.png)

*Separate Core and Link stages organize the Data Vault loads.*

### 7.3 Gold Dimensions and Facts

Run `DIMENSION_TRIGGER` first, then `FACT_TRIGGER` after dimension keys are available.

![Apache NiFi Gold Dimensions and Facts flows](docs/pipeline/gold_flow.png)

*Separate Dimension and Fact stages organize the dimensional loads.*

## 8. Project Structure

```text
abc-hub-modern-data-platform/
|-- data/                         # 26 sample CSVs
|-- docs/
|   |-- setup_notes.md            # Docker, JDBC, databases, CSV loading
|   |-- Final_Report.pdf          # Final project report
|   |-- operational_er_diagram.pdf
|   |-- diagrams/                 # Architecture and data models
|   `-- pipeline/                 # NiFi screenshots
|-- nifi/ABC_HUB_ETL.json          # Importable ETL flow
|-- sql/                          # DDL, validation, and execution guide
|-- Dockerfile                    # NiFi with PostgreSQL JDBC
|-- compose.yaml                  # Local NiFi and PostgreSQL services
`-- README.md
```

## 9. How to Run

1. **Start the services:** follow the [setup guide](docs/setup_notes.md) for Docker and local configuration.
2. **Prepare the databases:** create operational tables, load CSVs with `\copy`, and follow the [SQL execution order](sql/README.md) for warehouse tables.
3. **Configure NiFi:** import the flow and enable the database connection pools and record services.
4. **Run ETL in order:** Bronze → Silver Core → Silver Links → Gold Dimensions → Gold Facts. Verify each stage before starting the next.
5. **Validate:** run [validation_queries.sql](sql/validation_queries.sql) against `abc_hub_analytics`; review row counts, duplicate keys, missing relationships, and fact grains.

**Verified so far:** the documented sample import loaded 99 rows across 26 source tables, and the warehouse scripts created 54 tables in an isolated PostgreSQL container.

## 10. Key Engineering Decisions

- **Separate databases** keep operational records apart from analytical transformations.
- **Three warehouse layers** support source traceability, business integration, and dimensional reporting.
- **NiFi with a bundled JDBC driver** makes the local runtime easier to reproduce; database setup and CSV loading remain manual.
- **Small, related samples** make the project easier to try while keeping the full course dataset outside the repository.

## 11. Known Limitations

- Complete change capture, safe repeated loads, and automatic stage coordination are not implemented. Independent triggers require controlled execution.
- Date/month generation covers **2020–2030**; persisted ETL monitoring is not implemented.
- End-to-end NiFi execution has not been independently verified here. Screenshots capture flow state, not data reconciliation.
- Validation reports issues without automatically failing on findings. Report diagrams may differ from the implemented SQL.

## 12. Future Improvements

Reliable incremental loads and retries · Stage coordination · Automated quality checks · ETL monitoring · BI dashboards

## 13. Project Report

The [final project report (PDF)](docs/Final_Report.pdf) documents the design and implementation. Explore the [operational ER diagram](docs/operational_er_diagram.pdf) and the pipeline screenshots linked above for supporting detail.
