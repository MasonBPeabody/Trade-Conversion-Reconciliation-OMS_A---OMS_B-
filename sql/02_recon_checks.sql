-- 02_recon_checks.sql
-- Set your conversion window here:
-- (Adjust these dates to your cutover period)
WITH params AS (
  SELECT DATE '2026-01-01' AS start_date, DATE '2026-01-31' AS end_date
),

-- Normalize CRD into "expected Aladdin" keys via mapping tables
crd_norm AS (
  SELECT
    c.crd_trade_id,
    c.trade_date,
    c.settle_date,
    am.aladdin_account_id AS exp_account_id,
    sm.aladdin_security_id AS exp_security_id,
    c.side,
    c.quantity,
    c.price,
    c.gross_amount,
    c.currency,
    c.trader,
    c.status
  FROM crd_trades c
  JOIN params p
    ON c.trade_date BETWEEN p.start_date AND p.end_date
  LEFT JOIN account_map am
    ON am.crd_account_id = c.account_id
  LEFT JOIN security_map sm
    ON sm.crd_security_id = c.security_id
),

ald AS (
  SELECT *
  FROM aladdin_trades a
  JOIN params p
    ON a.trade_date BETWEEN p.start_date AND p.end_date
)

-- 1) Completeness: CRD trades missing in Aladdin
SELECT
  'MISSING_IN_ALADDIN' AS check_name,
  c.crd_trade_id
FROM crd_norm c
LEFT JOIN ald a
  ON a.legacy_trade_id = c.crd_trade_id
WHERE a.legacy_trade_id IS NULL;

-- 2) Completeness: Aladdin trades without a CRD legacy id (unexpected)
-- (Run separately)
-- SELECT 'NO_LEGACY_ID' AS check_name, aladdin_trade_id
-- FROM ald
-- WHERE legacy_trade_id IS NULL OR legacy_trade_id = '';

-- 3) Duplicates: multiple Aladdin rows for one CRD trade id
-- SELECT legacy_trade_id, COUNT(*) AS aladdin_rows
-- FROM ald
-- WHERE legacy_trade_id IS NOT NULL
-- GROUP BY legacy_trade_id
-- HAVING COUNT(*) > 1;

-- 4) Accuracy: field-level mismatches (account/security/side/date/qty/price/amount)
-- Tolerances: price_tol, amount_tol
-- (Run separately; keep as a "break report" query)
