/* Question 1
“Top growing artists over time.” */

WITH monthly_performance AS (
		SELECT
			a.artist_id,
			a.artist_name,
			st.listen_month,
			SUM(stream_count) AS current_month_performance,
			LAG(SUM(stream_count)) OVER(PARTITION BY a.artist_id  ORDER BY st.listen_month)
				AS previous_month_performance

		FROM artists a
		JOIN releases r
			ON r.artist_id = a.artist_id
		JOIN tracks t
			ON t.release_id = r.release_id
		JOIN streaming_stats st
			ON st.track_id = t.track_id
		GROUP BY
			a.artist_id,
			a.artist_name,
			st.listen_month),

performance_trends AS (
		SELECT
			artist_id,
			artist_name,
			listen_month,
			previous_month_performance,
			current_month_performance,
			current_month_performance - previous_month_performance
				AS stream_growth
		FROM monthly_performance)

SELECT
	artist_id,
	artist_name,
	listen_month,
	previous_month_performance,
	current_month_performance,
	stream_growth,
    RANK() OVER(ORDER BY stream_growth DESC) AS growth_rank
FROM performance_trends;
------------------------------------------------------------------------------------------

/* Question 2
“Platform dominance analysis.”*/

WITH platform_performance AS(
		SELECT
			platform,
			SUM(stream_count) AS stream_per_platform,
			SUM(SUM(stream_count)) OVER()
				AS platforms_total_stream
		FROM streaming_stats 
		GROUP BY platform)

SELECT
	platform,
    stream_per_platform,
    platforms_total_stream,
    ROUND(
    (stream_per_platform / platforms_total_stream) * 100, 2) 
		AS market_share
FROM platform_performance;
------------------------------------------------------------------------------------------

/* Question 3
“Most consistent artists.” */

WITH monthly_artist_streams AS (
		SELECT
			a.artist_id,
			a.artist_name,
			st.listen_month,
			SUM(st.stream_count) AS monthly_streams
		FROM artists a
		JOIN releases r
			ON r.artist_id = a.artist_id
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
	ROUND(STDDEV(monthly_streams), 2) 
		AS stream_consistency
FROM monthly_artist_streams
GROUP BY
	artist_id,
	artist_name
ORDER BY stream_consistency;
------------------------------------------------------------------------------------------

/* Question 4
“Highest skip-rate risk tracks.”*/

SELECT
	track_id,
    SUM(skip_rate) AS skip_rate_per_track,
    RANK() OVER(ORDER BY SUM(skip_rate) DESC)
		AS skip_rate_rank
FROM streaming_stats
GROUP BY track_id;
------------------------------------------------------------------------------------------

/* Question 5
“Artist momentum dashboard metrics.”
Better version:
“For each artist, compare current month streams with previous month streams and calculate growth percentage.”*/

WITH monthly_performance AS (
		SELECT
			a.artist_id,
			a.artist_name,
			st.listen_month,
			SUM(stream_count) AS current_month_performance,
			LAG(SUM(stream_count)) OVER(PARTITION BY a.artist_id  ORDER BY st.listen_month)
				AS previous_month_performance
		FROM artists a
		JOIN releases r
			ON r.artist_id = a.artist_id
		JOIN tracks t
			ON t.release_id = r.release_id
		JOIN streaming_stats st
			ON st.track_id = t.track_id
		GROUP BY
			a.artist_id,
			a.artist_name,
			st.listen_month),

performance_trends AS (
		SELECT
			artist_id,
			artist_name,
			listen_month,
			previous_month_performance,
			current_month_performance,
			ROUND(
            (current_month_performance - previous_month_performance) /
				NULLIF(previous_month_performance, 0) * 100, 2)
			-- “Return previous_month_performance normally, unless it equals 0 — in that case return NULL instead.”
				AS stream_growth_percentage
		FROM monthly_performance)

SELECT
	artist_id,
	artist_name,
	listen_month,
	previous_month_performance,
	current_month_performance,
	stream_growth_percentage,
    CASE
		WHEN stream_growth_percentage > 0 THEN "growth"
        WHEN stream_growth_percentage < 0 THEN "decline"
        ELSE "no change" END AS artist_momentum
   FROM performance_trends;
------------------------------------------------------------------------------------------

/*Question 6
“Genre trend analysis over time.”*/

WITH genre_monthly_performance AS (
		SELECT
			g.genre_id,
			g.genre_name,
			st.listen_month,
			SUM(stream_count) AS current_month_genre_performance,
            LAG(SUM(stream_count)) OVER(PARTITION BY g.genre_id ORDER BY st.listen_month)
				AS previous_month_genre_performance
		FROM genres g
		JOIN track_genres tg
			ON tg.genre_id = g.genre_id
		JOIN streaming_stats st
			ON st.track_id = tg.track_id
		GROUP BY 
			g.genre_id,
			g.genre_name,
			st.listen_month),

genre_performance_trend AS (
		SELECT
			genre_id,
			genre_name,
			listen_month,
			previous_month_genre_performance,
			current_month_genre_performance,
            ROUND(
            (current_month_genre_performance - previous_month_genre_performance) /
				NULLIF(previous_month_genre_performance, 0) * 100, 2)
                AS genre_trend_percentage
            
		FROM genre_monthly_performance)
        
SELECT
	genre_id,
    genre_name,
    listen_month,
    previous_month_genre_performance,
    current_month_genre_performance,
    genre_trend_percentage
FROM genre_performance_trend;
------------------------------------------------------------------------------------------

/* Question 7
“Best-performing labels by country.”*/

WITH label_performance AS(
		SELECT 
			l.label_id,
			l.label_name,
			l.country,
			SUM(st.stream_count) AS label_total_stream,
			RANK() OVER(PARTITION BY l.country ORDER BY SUM(st.stream_count)DESC)
				AS label_rank
		FROM labels l
		JOIN releases r
			ON r.label_id = l.label_id
		JOIN tracks t
			ON t.release_id = r.release_id
		JOIN streaming_stats st
			ON st.track_id = t.track_id
		GROUP BY 
			l.label_id,
			l.label_name,
			l.country)
SELECT
	label_id,
    label_name,
    country,
    label_total_stream,
    label_rank
FROM label_performance
ORDER BY country, label_rank;
------------------------------------------------------------------------------------------

/* Question 8
“Stream-to-playlist conversion analysis.” */

SELECT
	track_id,
	SUM(stream_count) AS total_track_stream,
	SUM(playlist_adds) AS total_playlist_adds,
    
    ROUND(
		(SUM(playlist_adds) / NULLIF(SUM(stream_count), 0)) * 100, 2)
			AS conversion_rate_percentage

FROM streaming_stats
GROUP BY track_id
ORDER BY conversion_rate_percentage DESC;
  

	
		