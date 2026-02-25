# Field Mapping Specification (CRD -> Aladdin)

## Purpose
Defines canonical field mappings and normalization rules used to reconcile CRD trades to Aladdin trades during conversion. This document supports traceability between business requirements and reconciliation outputs.

## Identifier Normalization
CRD identifiers must be normalized to expected Aladdin identifiers using mapping tables.

### Mapping Tables
- account_map: `crd_account_id -> aladdin_account_id`
- security_map: `crd_security_id -> aladdin_security_id`

### Trade Match Key
Primary match:
- `aladdin_trades.legacy_trade_id = crd_trades.crd_trade_id`

## Field Mapping Table
| Domain | CRD Field | Aladdin Field | Rule |
|---|---|---|---|
| Trade Key | crd_trade_id | legacy_trade_id | exact |
| Trade Date | trade_date | trade_date | exact |
| Settle Date | settle_date | settle_date | exact |
| Account | account_id | account_id | match after mapping |
| Security | security_id | security_id | match after mapping |
| Side | side | side | exact |
| Quantity | quantity | quantity | exact |
| Price | price | price | abs(diff) <= price_tol |
| Gross Amount | gross_amount | gross_amount | abs(diff) <= gross_tol |
| Currency | currency | currency | exact |
| Trader | trader | trader | informational (optional check) |
| Status | status | status | informational (optional check) |

## Notes on Common Conversion Differences
- Price representation: rounding differences may exist depending on precision and vendor conventions
- Gross amount: some systems store computed gross; reconcile using tolerance and document rounding policy
- Security identifiers: conversions often rely on cross-reference tables (CUSIP/ISIN/internal ids); mapping completeness is critical

## Required Data Quality Preconditions
- account_map must cover 100% of in-scope CRD accounts (or exceptions documented)
- security_map must cover 100% of in-scope CRD securities (or exceptions documented)
- legacy_trade_id population in Aladdin should be complete for deterministic matching
