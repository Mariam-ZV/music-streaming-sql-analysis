# 05 — Window Functions & Advanced Analytical SQL

This section focuses on advanced SQL analysis using window functions to perform ranking, trend analysis, benchmarking, cumulative calculations, and portfolio-style business analytics.

The work in this stage moves beyond basic querying and explores how SQL can be used for real analytical reporting and dashboard-oriented KPI analysis.

The analysis was built using a Music Streaming dataset containing artists, releases, tracks, genres, labels, and streaming performance metrics.

---

## Objectives

The goal of this stage was to:

- Develop a strong understanding of SQL window functions
- Perform advanced analytical calculations without collapsing row-level detail
- Analyse trends, rankings, growth, and contribution metrics
- Build dashboard-ready business KPIs
- Simulate real-world analytical reporting scenarios

---

## Key SQL Concepts Covered

### Window Functions
- `OVER()`
- `PARTITION BY`
- Ordered windows

### Ranking Functions
- `ROW_NUMBER()`
- `RANK()`
- `DENSE_RANK()`

### Value Functions
- `FIRST_VALUE()`
- `LAST_VALUE()`

### Time-Based Analysis
- `LAG()`
- `LEAD()`

### Running & Rolling Metrics
- Running totals
- Running averages
- Rolling 3-month averages
- Cumulative metrics

### Analytical Benchmarking
- Contribution analysis
- Benchmark comparisons
- Growth analysis
- Trend analysis
- KPI-style metrics

---

# Stage 1 — Window Function Foundations

Introduced the core concept of window functions using `OVER()`.

Key analyses included:
- Overall average streams beside each row
- Total releases across the dataset
- Stream contribution percentages
- Aggregate calculations without collapsing rows

Focus:
- Difference between `GROUP BY` and window functions
- Row-level analytical calculations

Files:
- `01_window_function_basics.sql`

---

# Stage 2 — Ranking & Value Analysis

Built advanced ranking and comparison logic using ranking and value window functions.

Key analyses included:
- Ranking artists by total streams
- Top tracks per platform
- Top releases within countries
- Genre performance ranking
- Most streamed track per artist
- Highest and lowest performing entities within partitions

Functions used:
- `RANK()`
- `DENSE_RANK()`
- `ROW_NUMBER()`
- `FIRST_VALUE()`
- `LAST_VALUE()`

Focus:
- Partitioned ranking
- Top-N analysis
- Comparative performance analysis

Files:
- `02_ranking_functions.sql`

---

# Stage 3 — Trend Analysis with LAG & LEAD

Focused on month-over-month comparisons and time-series analysis.

Key analyses included:
- Comparing monthly streams with previous months
- Growth and decline analysis
- Playlist-add trend analysis
- Detecting stream increases over time
- Artist popularity trend analysis

Functions used:
- `LAG()`
- `LEAD()`

Focus:
- Temporal analysis
- KPI trend tracking
- Time-based business reporting

Files:
- `03_lag_lead_analysis.sql`

---

# Stage 4 — Running Totals & Rolling Metrics

Developed dashboard-style cumulative and rolling metrics.

Key analyses included:
- Running stream totals over time
- Platform-specific running totals
- Running averages
- Rolling 3-month stream averages
- Cumulative playlist additions
- Running totals per artist

Functions used:
- `SUM() OVER()`
- `AVG() OVER()`
- Ordered window frames

Focus:
- Cumulative KPI tracking
- Rolling trend analysis
- Dashboard-oriented calculations

Files:
- `04_running_totals.sql`

---

# Stage 5 — Advanced Partition Analysis

Focused on benchmark and contribution analysis using deeper partition logic.

Key analyses included:
- Track contribution within artists
- Artist contribution within countries
- Comparing tracks against genre averages
- Comparing releases against label averages
- Identifying artists outperforming country averages

Focus:
- Benchmark metrics
- Comparative analytics
- Contribution analysis
- Group-level performance analysis

Files:
- `05_partition_analysis.sql`

---

# Stage 6 — Portfolio-Grade Analytics

Built real-world analytical queries designed for portfolio presentation and dashboard integration.

Key analyses included:
- Top growing artists over time
- Platform dominance analysis
- Most consistent artists
- Skip-rate risk analysis
- Artist momentum metrics
- Genre trend analysis
- Best-performing labels by country
- Stream-to-playlist conversion analysis

Focus:
- Business storytelling
- Dashboard KPI development
- Portfolio-ready analytical reporting

Files:
- `06_portfolio_analytics.sql`

---

## Skills Demonstrated

- Advanced SQL querying
- Analytical thinking
- KPI development
- Trend analysis
- Window function mastery
- Business-focused data analysis
- Benchmark and contribution analysis
- Time-series analysis
- Query structuring using CTEs
- Defensive SQL using `NULLIF()`
- Portfolio-grade analytical reporting

---

## Tools Used

- MySQL
- MySQL Workbench

---

## Next Step

The next phase of this project is building interactive Power BI dashboards using the analytical outputs developed in this SQL stage.
