-- =============================================================
-- 01 — Top 15 markets by export value (2025)
-- Purpose: identify the largest buyers of bottled Port Wine
--          and their average price per litre positioning.
-- Note: Portugal excluded as it represents the domestic market,
--       not international export activity.
-- =============================================================

SELECT
    pais                              AS country,
    ROUND(euros / 1000000.0, 2)       AS million_eur,
    ROUND(litros / 1000000.0, 2)      AS million_litres,
    ROUND(euros_por_litro, 2)         AS price_per_litre
FROM porto_exportacoes
WHERE ano = 2025
  AND pais != 'Portugal'
  AND euros > 0
ORDER BY euros DESC
LIMIT 15;
