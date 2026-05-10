# 🎧 Music Streaming Analysis (SQL Project)

## 📌 Project Overview
This project analyzes a music streaming dataset to identify key drivers of performance across artists, genres, labels, releases, and tracks. The goal is to simulate real-world business analysis and answer practical questions a music company would ask when making strategic decisions.

## 🎯 Business Problem
A music company wants to understand:
- Which artists drive the most streams
- Which genres perform best and most consistently
- Which labels are most successful and efficient
- What makes a successful release
- What track-level factors influence performance

## 🧱 Dataset & Schema
The dataset follows a MusicBrainz-style structure with the following tables:
- `artists`
- `releases`
- `tracks`
- `labels`
- `genres`
- `track_genres` (bridge table)
- `streaming_stats` (fact table)

Key relationships:
- artists → releases → tracks → streaming_stats
- tracks ↔ genres via track_genres

## 🛠️ Tools Used
- MySQL
- MySQL Workbench

## 🔍 Analysis & Key Questions

### 🎤 Artist Performance
- Top artists by total streams
- Market share of top artists
- Identification of underperforming artists

### 🎵 Genre Performance
- Total streams by genre
- Average streams per track (consistency)
- Volume vs performance comparison

### 🏷️ Label Performance
- Total streams by label
- Efficiency (streams per release)

### 💿 Release-Level Insights
- Top-performing releases
- Album vs single performance
- Country-level performance

### 🎼 Track-Level Signals
- Playlist adds vs streams
- Skip rate vs performance
- Track duration vs performance (short / medium / long)

## 📊 Key Insights
- Artist performance is somewhat concentrated, with top artists contributing a larger share of total streams
- Genre performance is relatively consistent, suggesting success is not genre-dependent
- Labels with fewer releases can still outperform via efficiency (streams per release)
- Release type impacts performance, with differences between albums and singles
- Playlist exposure strongly correlates with higher streams
- Higher skip rates tend to align with lower performance
- Track duration does not strongly determine success — performance is relatively balanced across duration groups

## 🧠 SQL Techniques Used
- Joins (multi-table joins)
- Aggregations (SUM, COUNT, AVG)
- GROUP BY and ORDER BY
- Subqueries
- CASE statements for segmentation

## 📁 Project Structure
Music_SQL_Project/

├── data_raw/
├── sql/
│   ├── 01_create_schema.sql
│   ├── 02_analysis_queries.sql



## 🚀 Next Steps
- Refactor queries using CTEs for readability
- Apply window functions for ranking and advanced insights
- Build a Power BI dashboard for visualization

## 💡 Key Learning
This project focuses on thinking like a data analyst:
- Translating business questions into SQL
- Structuring queries logically
- Interpreting results into actionable insights
