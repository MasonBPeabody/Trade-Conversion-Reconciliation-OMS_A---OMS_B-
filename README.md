# Trade Conversion Reconciliation (CRD -> Aladdin) | Postgres SQL

## Overview
SQL-based reconciliation framework to validate trade completeness and field-level accuracy during a Charles River (CRD) to BlackRock Aladdin conversion. Produces an audit-ready exception register, break taxonomy, and dashboard-friendly summaries for controlled migration sign-off.

## Core Outputs
- recon_breaks: exception register with severity, ownership, and traceable details
- recon_daily_summary: daily trending and tie-out summary
- views: open breaks aging + break summary for BI

## Repo Structure
- sql/: schema, loads, recon checks, reports, views
- docs/: conversion scope, mapping spec, rules catalog
- data/: sample CSVs (optional)

## How to Run (Postgres)
Run in this order:
1) sql/00_schema.sql
2) sql/01_load_sample_data.sql
3) sql/02_recon_checks.sql
4) sql/03_reports.sql
5) sql/04_views.sql

## Documentation
- docs/conversion_scope.md
- docs/field_mapping.md
- docs/recon_rules_catalog.md

## Notes
Uses synthetic/sample data structures to demonstrate OMS conversion reconciliation patterns without exposing proprietary information.

---

# Conversion Control Framework & Architecture

## Control Philosophy

This framework is structured around three core migration control pillars:

1. **Completeness** – Every eligible CRD trade must exist in Aladdin.
2. **Accuracy** – All key economic and static attributes must match within defined tolerances.
3. **Governance** – All exceptions must be classified, owned, tracked, and resolved prior to sign-off.

This design mirrors institutional OMS migration validation practices used in hedge funds and asset managers.

---

## High-Level Architecture

Source Extracts -> Normalization -> Reconciliation Engine -> Exception Register -> Sign-Off


---

## Control Layers

### Layer 1: Population Definition
- Define in-scope CRD trade population
- Apply conversion window and eligibility filters
- Ensure extract completeness

### Layer 2: Identifier Normalization
- Map CRD account_id to Aladdin account_id
- Map CRD security_id to Aladdin security_id
- Detect mapping gaps before accuracy checks

### Layer 3: Deterministic Matching
Primary key:
- legacy_trade_id

Fallback (optional enhancement):
- economic fingerprint matching

### Layer 4: Field-Level Validation
Validate:
- Side
- Quantity
- Price (tolerance)
- Gross Amount (tolerance)
- Trade Date
- Settle Date

### Layer 5: Exception Governance
- Break taxonomy with severity and owner
- Timestamped exception capture
- Daily summary and trending
- Explicit sign-off requirements

---

## Break Lifecycle Model

OPEN -> Investigation -> Remediation -> Retest -> CLOSED

Each break includes:
- Break code
- Severity
- Owner team
- Trade identifiers
- Diagnostic detail
- Detection timestamp

This structure supports operational transparency and audit defensibility.

---

## Production Readiness Model

A migration is considered production-ready when:

- 100% population completeness achieved (or approved exclusions documented)
- 0 OPEN HIGH severity breaks
- Accuracy thresholds achieved per defined tolerances
- Daily summary report validated and archived
- Formal sign-off memo executed (see release_signoff.md)

---

## Extension Model

This control framework is extensible to:

- Allocation reconciliation (EMS -> OMS)
- Settlement reconciliation (OMS -> Custodian)
- Pricing/vendor migration validation
- Data warehouse tie-outs (Source -> Reporting layer)
- Multi-day parallel run validation

---




