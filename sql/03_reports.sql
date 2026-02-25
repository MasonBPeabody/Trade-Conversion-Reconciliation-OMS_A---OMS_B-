-- Break register (audit-ready)
SELECT
  b.break_id,
  b.detected_at,
  b.status,
  b.break_code,
  t.severity,
  t.owner_team,
  b.crd_trade_id,
  b.aladdin_trade_id,
  b.details
FROM recon_breaks b
JOIN break_taxonomy t ON t.break_code = b.break_code
ORDER BY detected_at DESC, t.severity, b.break_code;

-- Daily summary for dashboarding
INSERT INTO recon_daily_summary (as_of_date, break_code, severity, owner_team, break_count, open_count, closed_count)
SELECT
  CURRENT_DATE AS as_of_date,
  b.break_code,
  t.severity,
  t.owner_team,
  COUNT(*) AS break_count,
  SUM(CASE WHEN b.status = 'OPEN' THEN 1 ELSE 0 END) AS open_count,
  SUM(CASE WHEN b.status = 'CLOSED' THEN 1 ELSE 0 END) AS closed_count
FROM recon_breaks b
JOIN break_taxonomy t ON t.break_code = b.break_code
GROUP BY b.break_code, t.severity, t.owner_team
ON CONFLICT (as_of_date, break_code) DO UPDATE
SET
  break_count = EXCLUDED.break_count,
  open_count = EXCLUDED.open_count,
  closed_count = EXCLUDED.closed_count;
