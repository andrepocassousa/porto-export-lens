-- =============================================================
-- 04 — Summary KPIs: 2025 vs 2024
-- Purpose: top-line figures for the dashboard header.
-- Excludes Portugal (domestic market) from all aggregates.
-- =============================================================

SELECT
    -- Total value
    ROUND(SUM(CASE WHEN ano = 2025 THEN euros END)
          / 1000000.0, 1)                         AS total_eur_2025,
    ROUND(SUM(CASE WHEN ano = 2024 THEN euros END)
          / 1000000.0, 1)                         AS total_eur_2024,

    -- YoY change (%)
    ROUND((SUM(CASE WHEN ano = 2025 THEN euros END) -
           SUM(CASE WHEN ano = 2024 THEN euros END)) /
           SUM(CASE WHEN ano = 2024 THEN euros END) * 100.0, 1)
                                                  AS yoy_change_pct,

    -- Average price per litre
    ROUND(SUM(CASE WHEN ano = 2025 THEN euros END) /
          SUM(CASE WHEN ano = 2025 THEN litros END), 2)
                                                  AS avg_price_per_litre_2025,

    -- Active markets
    COUNT(DISTINCT CASE WHEN ano = 2025
          AND euros > 0 THEN pais END)            AS active_markets_2025,

    -- Total volume
    ROUND(SUM(CASE WHEN ano = 2025 THEN litros END)
          / 1000000.0, 1)                         AS total_litres_2025

FROM porto_exportacoes
WHERE pais != 'Portugal';
