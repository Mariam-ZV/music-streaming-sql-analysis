/* Question 1
“Compare each month’s streams with previous month.” */

WITH monthly_streams AS (
		SELECT
			listen_month,
			SUM(stream_count) AS total_stream,
			LAG(SUM(stream_count))OVER(ORDER BY listen_month)
					AS previous_stream
		FROM streaming_stats
		GROUP BY 
			listen_month)
SELECT
    listen_month,
    total_stream,
    previous_stream
FROM monthly_streams;
----------------------------------------------------------------------------------

/*Question 2
“Calculate monthly growth/decline in streams.”*/

WITH monthly_stream AS (
		SELECT
			listen_month,
			SUM(stream_count) AS total_stream,
			LAG(SUM(stream_count))OVER(ORDER BY listen_month) AS previous_stream
		FROM streaming_stats
		GROUP BY listen_month)
SELECT
	listen_month,
    total_stream,
    previous_stream,
    total_stream - previous_stream AS stream_difference,
    CASE
		WHEN (total_stream - previous_stream) < 0 THEN "decline"
        ELSE "growth" END AS trend
FROM monthly_stream;
----------------------------------------------------------------------------------

/* Question 3
“Compare playlist adds with previous month.”*/
 
 WITH monthly_playlist AS (
		SELECT
			listen_month,
			SUM(playlist_adds) AS total_playlist_adds,
			LAG(SUM(playlist_adds)) OVER(ORDER BY listen_month) 
				AS previous_playlist_adds
		FROM streaming_stats 
        GROUP BY listen_month)
SELECT
	listen_month,
    total_playlist_adds,
    previous_playlist_adds,
    CASE
		WHEN total_playlist_adds > previous_playlist_adds THEN "increased"
		WHEN total_playlist_adds < previous_playlist_adds THEN "decreased"
		ELSE "no change"
		END AS trend
 FROM monthly_playlist;
----------------------------------------------------------------------------------

/* Question 4
“Detect biggest stream increase between months.”*/

WITH monthly_stream AS (
		SELECT
			listen_month,
			SUM(stream_count) AS total_stream,
			LAG(SUM(stream_count)) OVER(ORDER BY listen_month)
					AS previous_stream
		FROM streaming_stats
		GROUP BY listen_month),
        
        
stream_trend AS (
		SELECT
			listen_month,
            total_stream - previous_stream AS stream_change,
			RANK() OVER(ORDER BY total_stream - previous_stream DESC) 
					AS stream_rank
		FROM monthly_stream)
SELECT 
	ms.listen_month,
    ms.total_stream,
    ms.previous_stream,
    st.stream_change,
    st.stream_rank
FROM monthly_stream ms
JOIN stream_trend st
	ON ms.listen_month = st.listen_month
WHERE stream_rank = 1;
----------------------------------------------------------------------------------

/* Question 5
“Find artists losing popularity over time.” */

WITH stream_trend AS (
		SELECT
			a.artist_id,
			a.artist_name,
			st.listen_month,
			SUM(st.stream_count) AS total_stream,
			LEAD(SUM(st.stream_count)) OVER(PARTITION BY a.artist_id ORDER BY listen_month) 
					AS next_month_stream
		FROM artists a
		JOIN releases r
			ON r.artist_id = a. artist_id
		JOIN tracks t
			ON t.release_id = r.release_id
		JOIN streaming_stats st
			ON st.track_id = t.track_id
		GROUP BY 
			a.artist_id,
			a.artist_name,
			st.listen_month)
            
SELECT
	artist_id, 
    artist_name,
    listen_month,
    total_stream,
    next_month_stream,
    CASE
		WHEN next_month_stream > total_stream THEN "more_popular"
        WHEN next_month_stream < total_stream THEN "less_popular"
        ELSE "no change" END AS trend
	FROM stream_trend;