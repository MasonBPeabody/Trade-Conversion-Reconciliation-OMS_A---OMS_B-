# Trade-Conversion-Reconciliation Charles River to Blackrock Aladdin (SQL Base)
Migrated from Charles River to Blackrock Aladdin and provided trade completeness and accuracy across the conversion window.

SQL-based reconciliation framework for a trade migration from Charles River (CRD) to BlackRock Aladdin. Validates trade completeness and field-level accuracy across a defined conversion window, classifies breaks, and produces audit-ready exception reports and tie-outs for operations and controls.

# Trade Conversion Reconciliation (Charles River -> BlackRock Aladdin) | SQL Framework

## Purpose
This repository provides a SQL-based reconciliation framework to validate **trade completeness and field-level accuracy** during a Charles River (CRD) to BlackRock Aladdin migration. It is designed to support operational control requirements, conversion sign-off, and audit-ready documentation across a defined conversion window.

## Business Context
During OMS migrations, conversion risk typically falls into three categories:
1. **Completeness**: every eligible source trade exists in the target system
2. **Accuracy**: key economic and static attributes are converted correctly (within tolerances)
3. **Governance**: breaks are classified, owned, aged, and resolved under controlled sign-off

## Scope
- Object: Trades (extensible to allocations, confirms, and settlements)
- Window: configurable conversion dates (see `docs/conversion_scope.md`)
- Output: break tables, break reports, and summary tie-outs for stakeholders (FO/Ops/Tech)

## Architecture
**Inputs**
- CRD trades extract (source of record for conversion population)
- Aladdin trades extract (target population; includes `legacy_trade_id` when available)
- Mapping tables (accounts, securities) required to normalize identifiers

**Processing**
- Normalize CRD trades into expected Aladdin identifiers
- Run completeness checks and field-level accuracy checks
- Classify breaks using a break taxonomy aligned to ownership and severity

**Outputs**
- `recon_breaks`: audit-ready exception register
- `recon_daily_summary`: daily tie-out and break trending (dashboard-friendly)

## Reconciliation Controls
### Completeness Controls
- CRD trades missing in Aladdin by `legacy_trade_id`
- Aladdin trades missing `legacy_trade_id` (unexpected in a conversion)
- Duplicate mapping: multiple target trades per source trade

### Accuracy Controls (field-level)
- Account mapping mismatch
- Security mapping mismatch
- Side mismatch
- Quantity mismatch
- Price mismatch (tolerance-based)
- Gross amount mismatch (tolerance-based)
- Trade date / settle date mismatch

## How to Run (Postgres recommended)
1. Create schema:
   - run `sql/00_schema.sql`
2. Load sample data:
   - run `sql/01_load_sample_data.sql`
3. Run recon + populate breaks:
   - run `sql/02_recon_checks.sql`
4. Generate reports:
   - run `sql/03_reports.sql`

## Deliverables Produced
- Exception register with severity, owner, and traceable details (`recon_breaks`)
- Daily tie-out / trending summary (`recon_daily_summary`)
- Rules catalog and mapping specification pack (`docs/`)

## Extension Roadmap
- Allocation reconciliation: EMS executions vs OMS allocations
- Settlement reconciliation: OMS vs custodian/prime
- Data warehouse tie-outs: curated layer vs source extracts
- Automated export for Power BI / Tableau dashboards

## Disclaimer
This repository uses synthetic/sample data structures to demonstrate conversion reconciliation patterns without exposing proprietary information.

