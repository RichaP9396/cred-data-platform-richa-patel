# cred-data-platform-richa-patel
Data Platform for Large-Scale Analytics
CRED Data Platform – Take-Home Assignment
Overview
This project demonstrates how I would design and build a scalable data pipeline and warehouse layer to support analytics and AI use cases for large-scale event data. The goal was to create a reliable and modular data workflow using BigQuery and dbt, showing how raw events can be turned into curated daily metrics ready for dashboards or machine-learning models.

Tech Stack
Google Cloud Platform (GCP) – Pub/Sub, BigQuery
dbt (Data Build Tool) – transformations, testing, and data lineage
Python + SQL – logic, data quality checks
Optional: GitHub Actions or Airflow for orchestration and CI/CD

Pipeline Design
Raw Events (Pub/Sub / CSV Upload)
BigQuery Raw Layer (events_raw)

Staging Layer (dbt: stg_events)
- Cleans and flattens data
- Extracts JSON fields (e.g. metadata.amount)
- Validates datatypes
Fact / Curated Layer (dbt: fact_user_activity)
- Aggregates per user
  • first_event  
  • last_event  
  • total_events  
  • total_amount  
- Incremental + partitioned
GraphQL API / ML Feature Store
- Feeds dashboards & models
- Daily or near real-time refresh
This setup allows smooth scaling as data grows from thousands to billions of events while keeping cost and query performance in control through partitioning and clustering.

Data Model Summary
1. events_raw
Raw ingested event data from apps or services.
Column	Type	Description
user_id	STRING	Unique ID for the user
event_type	STRING	Type of event (purchase, click, etc.)
event_timestamp	TIMESTAMP	When the event happened
metadata	JSON	Extra info (e.g. amount, device)

2. stg_events
Cleaned and flattened version of events_raw.
•	Extracts metadata.amount
•	Ensures timestamps are in UTC
•	Filters out invalid records

3. fact_user_activity
Aggregated daily metrics for each user.
Metric	Description
first_event	Earliest activity date
last_event	Latest activity date
total_events	Count of all user events
total_amount	Total purchase amount
This table is incrementally built, partitioned by event_date, and ready to power dashboards or feed ML features.

Data Quality Tests
The following dbt tests ensure data reliability:
•	Unique and non-null user_id
•	Non-null first_event, last_event, total_amount, total_events
All tests passed successfully:
PASS=6  WARN=0  ERROR=0

How to Run Locally
Install dependencies
pip install dbt-bigquery
Set up your dbt profile (~/.dbt/profiles.yml)
cred_pipeline:
target: dev
outputs:
dev:
type: bigquery
method: service-account
project: your-gcp-project
dataset: cred_analytics
keyfile: /path/to/service_account.json
threads: 4
Run the pipeline
dbt run
Run data quality tests
dbt test --select fact_user_activity

Scalability & Future Ideas
Add streaming ingestion (Pub/Sub → Dataflow → BigQuery)
Integrate CI/CD using dbt Cloud or GitHub Actions
Enable data lineage tracking and automatic documentation
Connect curated data to a feature store (like Feast)
