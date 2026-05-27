-- =============================================================
-- 03 — Premium markets: average price per litre (2025)
-- Purpose: identify where Port Wine commands the highest
--          value per litre — key for premium range strategy.
-- Filter: minimum €1,000,000 in total value to ensure the
--         price signal is based on meaningful volume.
-- =============================================================

SELECT
    pais                              AS country,
    ROUND(euros / 1000000.0, 2)       AS million_eur,
    ROUND(litros / 1000000.0, 2)      AS million_litres,
    ROUND(euros_por_litro, 2)         AS price_per_litre
FROM porto_exportacoes
WHERE ano = 2025
  AND pais != 'Portugal'
  AND euros > 1000000
ORDER BY euros_por_litro DESC
LIMIT 15;
