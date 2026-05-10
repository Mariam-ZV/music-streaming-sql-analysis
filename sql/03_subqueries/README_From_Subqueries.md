# SQL Subqueries — FROM Clause (Derived Tables) Analysis

This section of the project focuses on using SQL subqueries inside the `FROM` clause to create derived tables for layered analytical reporting within a music streaming dataset.

The analysis introduces structured multi-step querying by building temporary aggregated datasets and then performing secondary analysis on top of those results.

## Skills Demonstrated

- Derived tables using subqueries in the `FROM` clause
- Multi-layer analytical querying
- Nested aggregation logic
- Benchmark comparisons using derived datasets
- Ranking and performance analysis
- Group-level KPI calculations
- Multi-table joins with advanced aggregation
- Structured analytical problem solving

## Key Business Questions Explored

### Artist Ranking Analysis
- Rank artists based on their total streams.

### Label Performance Analysis
- Identify labels with above-average streams generated per release.

### Genre Performance Analysis
- Identify genres with strong average performance per track.

## Analytical Highlights

A major focus of this section was learning how to break complex analytical problems into smaller logical steps using derived tables.

Examples include:
- Creating temporary artist performance tables for ranking analysis
- Calculating streams per release before comparing labels against platform benchmarks
- Measuring average streams per track for each genre before evaluating genre strength

This section also introduced the concept of:
- temporary analytical datasets
- layered aggregation
- analysing calculated metrics using secondary queries

The use of derived tables helped structure complex calculations more clearly before transitioning toward Common Table Expressions (CTEs).

## Example Concepts Practiced

### Ranking Analysis
Creating temporary artist performance datasets and sorting them by total streams.

### Efficiency Metrics
Evaluating labels based on streams generated per release rather than total volume alone.

### Multi-Step Benchmarking
Building aggregated genre performance tables and comparing them against overall platform averages.

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

This phase strengthened my understanding of layered analytical SQL logic. Using derived tables inside the `FROM` clause improved my ability to structure complex calculations and prepared the foundation for learning Common Table Expressions (CTEs).
