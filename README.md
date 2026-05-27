# Porto Export Lens — Port Wine Export Market Analysis

> A market intelligence tool built on public IVDP data to identify Port Wine export opportunities — framed from the perspective of a Key Account Manager.

**[→ View dashboard (EN)](https://andresousa.github.io/porto-export-lens/index-en.html)** · **[→ Ver dashboard (PT)](https://andresousa.github.io/porto-export-lens/index.html)**

![Porto Export Lens Dashboard](assets/dashboard_preview.png.png)

---

## The problem / O problema

**EN** — Port Wine exporters make market decisions based on historical experience and commercial intuition. The data exists — the IVDP publishes detailed export statistics by destination country since 2006 — but it is rarely processed systematically. A typical KAM cannot answer in 30 seconds: *"which market has grown the most in value per litre over the past 5 years?"*

**PT** — As exportadoras de Vinho do Porto tomam decisões de mercado com base em experiência histórica e intuição comercial. Os dados existem — o IVDP publica estatísticas detalhadas de exportação por país de destino desde 2006 — mas raramente são trabalhados de forma sistemática. Um KAM típico não consegue responder em 30 segundos a *"qual é o mercado que mais cresce em valor por litro nos últimos 5 anos?"*

This project answers three questions a KAM asks in any strategy meeting:

1. **Where are the untapped opportunities?** — markets growing below the radar
2. **Which markets are accelerating?** — value change 2024 vs 2025
3. **Where does Port achieve the highest price per litre?** — premium positioning by market

---

## Key findings / Principais conclusões

### 🟢 South Korea — premium and accelerating
Grew **+200% in value since 2019**, maintaining an average price of **€9.66/litre** in 2025 — the third highest of all markets. The only country appearing simultaneously in the growth top and price top. Ideal market profile for an expansion strategy with margin.

### 🟢 UAE — the world's most expensive market
At **€13.38/litre**, the UAE is where Port Wine commands the highest price — and growing **+38% in 2025**. Distribution via Dubai provides access to the entire Middle East from a single importer.

### 🟡 Mexico and Finland — strong growth from a low base
Mexico (**+57%**) and Finland (**+48%**) are the fastest-growing markets in 2025. Both are in the early penetration phase — exactly the moment to establish position before the competition.

### 🔴 USA — premium but contracting
Average price of **€9.55/litre** but volume declining since 2019. Fell from first to third place in absolute value. A warning signal for exporters with high dependence on this market.

---

## Dataset

| Field | Detail |
|---|---|
| Source | IVDP — Instituto dos Vinhos do Douro e Porto |
| Period | 2006–2025 |
| Records | 2,461 (after cleaning) |
| Countries | 187 destination markets |
| Variables | Country, year, volume (litres), value (€), average price (€/litre) |
| Scope | Bottled Port Wine — excludes bulk and special categories |

---

## Tech stack

```
Raw data (XLS/HTML)  →  Python + BeautifulSoup (ingestion & cleaning)  →  CSV
CSV                  →  DuckDB (SQL analysis)                           →  results
Results              →  Chart.js + HTML                                 →  dashboard
```

- **DuckDB** — chosen for its efficiency in running analytical (OLAP) queries directly on local CSV files, with no database infrastructure required. Ideal for datasets of this scale.
- **Python / BeautifulSoup** — ingestion and cleaning of IVDP files (published as HTML-disguised XLS)
- **Chart.js** — dashboard visualisations
- **GitHub Pages** — dashboard publishing, no infrastructure needed

No paid dependencies. No proprietary BI tools. Fully reproducible from the code in this repository.

---

## Repository structure

```
porto-export-lens/
├── assets/
│   └── dashboard_preview.png         # Dashboard screenshot
├── data/
│   ├── raw/                          # Original IVDP files
│   └── porto_exportacoes.csv         # Clean dataset (2,461 records)
├── sql/
│   ├── 01_top15_markets.sql          # Top 15 by value in 2025
│   ├── 02_accelerating_markets.sql   # Growth 2024 vs 2025
│   ├── 03_premium_markets.sql        # Average price per litre in 2025
│   └── 04_kpis_overview.sql          # Summary KPIs
├── index.html                        # Dashboard PT
├── index-en.html                     # Dashboard EN
├── .gitignore
└── README.md
```

---

## Key SQL queries

**Top 15 markets by value in 2025:**
```sql
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
```

**Accelerating markets — 2024 vs 2025:**
```sql
SELECT
    p25.pais                                      AS country,
    ROUND(p24.euros / 1000000.0, 2)               AS eur_2024,
    ROUND(p25.euros / 1000000.0, 2)               AS eur_2025,
    ROUND((p25.euros - p24.euros) /
           p24.euros * 100.0, 1)                  AS growth_pct
FROM porto_exportacoes p25
JOIN porto_exportacoes p24 ON p25.pais = p24.pais
WHERE p25.ano = 2025
  AND p24.ano = 2024
  AND p25.pais != 'Portugal'
  AND p24.euros > 500000  -- minimum threshold to exclude negligible markets
ORDER BY growth_pct DESC
LIMIT 15;
```

---

## Limitations

- Covers bottled Port Wine only — bulk and special categories (Tawny, LBV, Vintage) not included
- No total import data by country: Portuguese market share cannot be calculated
- Aggregate sector data — does not reflect individual exporter performance

---

## Next steps

- [ ] Integrate UN Comtrade API to calculate Portuguese market share by country
- [ ] Add special category analysis (Tawny, LBV, Vintage)
- [ ] Volume forecasting model with Facebook Prophet for top 10 markets
- [ ] Automated market brief by country via Claude API

---

## About / Sobre

**EN** — Project developed by **André Sousa**, Key Account Manager with experience in pharmaceutical exports. The market analysis methodology — opportunity identification, buyer profile segmentation, value vs. volume analysis — is transferred directly from B2B export experience into the Port Wine context. Based in Vila Nova de Gaia, at the heart of the Port Wine lodges.

**PT** — Projecto desenvolvido por **André Sousa**, Key Account Manager com experiência em exportação farmacêutica. A metodologia de análise de mercado — identificação de oportunidades, segmentação por perfil de comprador, análise de valor vs. volume — é transferida directamente da experiência em exportação B2B para o contexto do Vinho do Porto. Baseado em Vila Nova de Gaia, no coração das caves do Porto.

**LinkedIn:** [www.linkedin.com/in/andrepocasousa/](https://www.linkedin.com/in/andrepocasousa/)

---

*Data: IVDP — Instituto dos Vinhos do Douro e Porto. Series 2006–2025.*
