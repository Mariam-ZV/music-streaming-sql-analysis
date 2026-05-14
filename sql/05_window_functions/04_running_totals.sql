/* Question 1
“Running total of streams over time.” */
    
SELECT
	listen_month,
    SUM(stream_count) AS total_stream,
    SUM(SUM(stream_count)) OVER(ORDER BY listen_month)
		AS running_total
FROM streaming_stats
GROUP BY listen_month;
--------------------------------------------------------------------------

/* Question 2
“Running total by platform.” */

SELECT
	platform,
    listen_month,
    SUM(stream_count) AS total_stream,
    SUM(SUM(stream_count)) OVER(PARTITION BY platform ORDER BY listen_month)
		AS running_platform_streams
FROM streaming_stats
GROUP BY 
	platform,
    listen_month;
 --------------------------------------------------------------------------   
 
 /*Question 3
“Calculate the running average of monthly streams over time.”*/

SELECT
	listen_month,
    SUM(stream_count) AS total_stream,
    AVG(SUM(stream_count)) OVER(ORDER BY listen_month)
		AS monthly_running_average
FROM streaming_stats
GROUP BY listen_month;
 --------------------------------------------------------------------------
  
  /* Question 4
“Rolling 3-month average streams.” */

SELECT
	listen_month,
	SUM(stream_count) AS total_stream,
	AVG(SUM(stream_count)) OVER(
		ORDER BY listen_month
		ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
			AS rolling_3_month_avg
FROM streaming_stats
GROUP BY listen_month;
--------------------------------------------------------------------------

/*Question 5
“Cumulative playlist adds.”*/

SELECT
	listen_month,
    SUM(playlist_adds) AS total_playlist_adds,
	SUM(SUM(playlist_adds)) OVER(ORDER BY listen_month)
		AS running_total_playlist_adds
FROM streaming_stats
GROUP BY
	listen_month;
--------------------------------------------------------------------------

/* Question 6
“Running total per artist.”*/

SELECT
	a.artist_id,
    a.artist_name,
    st.listen_month,
    SUM(st.stream_count) AS total_stream,
    SUM(SUM(st.stream_count)) OVER(PARTITION BY a.artist_id ORDER BY listen_month)
		AS running_total_artist
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
    st.listen_month;
