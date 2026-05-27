-- =============================================================
-- 02 — Accelerating markets: growth 2024 vs 2025
-- Purpose: identify markets gaining momentum — where to
--          prioritise prospecting and trade fair presence.
-- Filter: minimum €500,000 in 2024 to exclude negligible
--         markets where % growth is statistically misleading.
-- =============================================================

SELECT
    p25.pais                                      AS country,
    ROUND(p24.euros / 1000000.0, 2)               AS eur_2024,
    ROUND(p25.euros / 1000000.0, 2)               AS eur_2025,
    ROUND((p25.euros - p24.euros) /
           p24.euros * 100.0, 1)                  AS growth_pct
FROM porto_exportacoes p25
JOIN porto_exportacoes p24
    ON p25.pais = p24.pais
WHERE p25.ano = 2025
  AND p24.ano = 2024
  AND p25.pais != 'Portugal'
  AND p24.euros > 500000
ORDER BY growth_pct DESC
LIMIT 15;
