# 04_CTE_Analysis.sql

## Common Table Expressions (CTEs) — Music Streaming SQL Analysis

This section focuses on Common Table Expressions (CTEs) using a business-first analytical approach. The goal was not only to learn CTE syntax, but also to develop structured analytical thinking by breaking complex business problems into reusable logical steps.

The analysis progresses from simple reusable calculations to layered KPI-style analytical pipelines commonly used in real-world reporting and dashboard development.

## Skills Demonstrated

- Writing and structuring Common Table Expressions (CTEs)
- Replacing nested subqueries with readable analytical workflows
- Building reusable temporary result sets
- Aggregating and benchmarking business metrics
- Multi-step KPI analysis
- Analytical comparison against global averages
- Performance and efficiency calculations
- Multi-table joins and bridge-table analysis
- Structured SQL problem solving

## Business Questions Solved

### Level 1 — Simple CTE Replacement
- Which streaming records have stream_count higher than the overall average?
- Which tracks have longer-than-average duration?
- Which streaming records have higher-than-average skip rates?
- Which tracks have never appeared in streaming_stats?
- Which artists have at least one release?

### Level 2 — Aggregate CTEs
- Which artists have above-average total streams?
- Which releases perform better than the average release?
- Which genres have higher-than-average stream performance?
- Which labels release music in more than one country?

### Level 3 — Analytical Context CTEs
- For each artist, show total streams and percentage contribution to total platform streams.
- For each genre, show total streams and share of overall platform streams.
- Compare track performance against the global average.

### Level 4 — Multi-CTE Analytical Pipelines
- Find labels with above-average streams per release.
- Identify genres with strong average performance per track.

## Key Analytical Concepts Applied

### Reusable Metrics
Several analyses were built by first creating reusable business metrics inside CTEs before performing comparisons or benchmarking.

Examples:
- Total streams per artist
- Streams per release
- Streams per genre
- Average performance per track
- Platform-wide stream contribution percentages

### KPI & Benchmarking Logic
The project applies dashboard-style KPI thinking by comparing:
- artists vs overall platform performance
- genres vs average genre performance
- releases vs average release performance
- tracks vs global track benchmarks
- labels vs average operational efficiency

### Multi-Stage Analytical Pipelines
More advanced questions were solved using layered CTE pipelines where:
1. metrics were calculated,
2. KPIs were derived,
3. benchmarks were generated,
4. and final business comparisons were performed.

This mirrors how analytical reporting is often developed in production environments.

## Tools Used

- MySQL
- MySQL Workbench

## Dataset Structure Used

The analysis was built using a Music Streaming relational database containing:
- artists
- releases
- tracks
- streaming_stats
- genres
- track_genres
- labels

The project includes one-to-many and many-to-many relationships, allowing for realistic analytical workflows across multiple business entities.

## Next Steps

The next phase of the project focuses on:
- Window Functions
- Ranking Analysis
- Running Totals
- Moving Averages
- Partition-Based Analytics
- Top-N Performer Analysis

The final stage of the project will move into Power BI dashboard development for interactive reporting and business storytelling.
