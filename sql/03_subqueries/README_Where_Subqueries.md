# SQL Subqueries — WHERE & HAVING Clause Analysis

This section of the project focuses on using SQL subqueries inside `WHERE` and `HAVING` clauses to answer business-oriented analytical questions using a music streaming dataset.

The analysis begins with simple benchmark comparisons and gradually progresses toward more advanced grouped performance analysis using nested aggregation logic.

## Skills Demonstrated

- Subqueries in `WHERE` clauses
- Subqueries in `HAVING` clauses
- Aggregate comparisons using `AVG()`, `SUM()`, and `COUNT()`
- Group-level benchmarking
- `IN`, `NOT IN`, and `NOT EXISTS`
- Nested aggregation logic
- Multi-table joins with grouped analysis
- Analytical filtering based on calculated benchmarks

## Key Business Questions Explored

### Streaming Performance Analysis
- Which streaming records perform above the platform average?
- Which tracks underperform in terms of stream count?
- Which tracks experience higher-than-average skip rates?
- Which tracks receive above-average playlist exposure?

### Artist & Release Performance
- Which artists generate above-average total streams?
- Which releases perform better than the average release?
- Which artists have at least one track performing above average?

### Genre & Label Analysis
- Which genres perform above the overall genre average?
- Which labels release music across multiple countries?
- Which genres are linked to multiple tracks?

### Data Quality & Existence Checks
- Which tracks have never appeared in streaming statistics?
- Which artists have released at least one release?
- Which artists have no releases?

## Analytical Highlights

A major focus of this section was learning how to compare grouped business metrics against platform-wide benchmarks using nested subqueries.

Examples include:
- Comparing artist totals against average artist performance
- Comparing release performance against average release performance
- Identifying genres with stronger-than-average streaming activity
- Detecting missing or unmatched records using `NOT IN` and `NOT EXISTS`

The analysis also introduced existence-based logic using:
- `IN`
- `NOT IN`
- `EXISTS`
- `NOT EXISTS`

These patterns are commonly used in real-world analytical workflows for filtering, validation, and benchmark analysis.

## Dataset Structure Used

The queries were built using a relational music streaming schema containing:

- `artists`
- `genres`
- `labels`
- `releases`
- `tracks`
- `streaming_stats`
- `track_genres`

The project involved both one-to-many and many-to-many relationships, including use of the `track_genres` bridge table.

## Key Takeaway

This phase strengthened my understanding of layered SQL logic and analytical filtering techniques. The progression from simple benchmark comparisons to grouped performance analysis helped build a stronger understanding of how subqueries can support business-focused reporting and decision-making.
