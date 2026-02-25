# Conversion Scope and Sign-Off Criteria (CRD -> Aladdin)

## Objective
Validate trade migration results from Charles River (CRD) to BlackRock Aladdin by proving:
1) completeness of the migrated population
2) accuracy of key economic and static attributes
3) controlled governance of exceptions and sign-off

## Conversion Window
- Start date: 2026-01-01
- End date: 2026-01-31
- Time basis: trade_date (primary); settle_date used for secondary checks

## In-Scope Population
Trades in CRD that meet ALL criteria:
- trade_date between start and end date
- status in: CONFIRMED (and optionally ALLOCATED if your operating model requires)
- instrument types: all (unless exclusions apply below)
- currency: all

## Out-of-Scope (Typical Exclusions)
- cancelled/voided trades not expected to convert
- test trades
- duplicates created by upstream replay/backfill runs (must be de-duplicated by agreed rule)
- post-cutover corrections handled through normal BAU amend/cancel workflows

## System-of-Record Assumptions
- CRD extract is the authoritative source for conversion population definition
- Aladdin extract is the authoritative target population for post-cutover existence
- Matching key: `aladdin_trades.legacy_trade_id = crd_trades.crd_trade_id`

## Matching Strategy
Primary match:
- legacy_trade_id (preferred for deterministic conversion checks)

Fallback match (optional enhancement for unmapped legacy ids):
- fingerprint match on:
  - trade_date, mapped account_id, mapped security_id, side, quantity, price (tolerance-based)

## Tolerances
- price tolerance: 0.0001
- gross amount tolerance: 1.00 (in trade currency units)
- quantity tolerance: exact match (unless product-specific rounding rules are documented)

## Sign-Off Criteria (Example)
- Completeness: 100% of in-scope CRD trades present in Aladdin OR documented exceptions with approvals
- Accuracy: 99.5%+ match rate across key economics (qty, price, gross) OR documented exceptions with approvals
- Governance: 0 OPEN HIGH-severity breaks at sign-off (or approved waivers with evidence)

## Evidence and Auditability
- Exception register contains: break_code, severity, owner, trade ids, timestamps, and diagnostic details
- Daily summary supports trending and operational readiness reporting
