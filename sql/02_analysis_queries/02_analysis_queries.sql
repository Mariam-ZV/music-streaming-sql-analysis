/* Artist Performance — Question 1
“Which artists are driving the most total streams?”
*/

SELECT 
	a.artist_name,
    SUM(st.stream_count) AS total_streams
FROM artists a
JOIN releases r
	ON a.artist_id = r.artist_id
JOIN tracks t
	ON r.release_id = t.release_id
JOIN streaming_stats st
	ON t.track_id = st.track_id
GROUP BY artist_name
ORDER BY total_streams DESC;
------------------------------------------------------------------------------------

/*Artist Performance — Question 2
“Are a few artists dominating the platform, or is performance evenly distributed?”*/

SELECT 
	a.artist_name,
    SUM(stream_count) AS total_stream,
    SUM(stream_count) / (SELECT SUM(stream_count) FROM streaming_stats) As share_of_total
FROM artists a
JOIN releases r
	ON a.artist_id = r.artist_id
JOIN tracks t
	ON r.release_id = t.release_id
JOIN streaming_stats st
	ON t.track_id = st.track_id
GROUP BY artist_name
ORDER BY total_stream DESC;
------------------------------------------------------------------------------------

/* Artist Performance — Question 3
“Who are the underperforming artists?”*/

SELECT 
	a.artist_name,
    SUM(stream_count) AS total_stream,
    SUM(stream_count) / (SELECT SUM(stream_count) FROM streaming_stats) As share_of_total
FROM artists a
JOIN releases r
	ON a.artist_id = r.artist_id
JOIN tracks t
	ON r.release_id = t.release_id
JOIN streaming_stats st
	ON t.track_id = st.track_id
GROUP BY artist_name
ORDER BY total_stream ASC
LIMIT 5;
------------------------------------------------------------------------------------

/* Genre Performance - Quesion 1
“Which genres are driving the most streams?”*/

SELECT 
	g.genre_name,
    SUM(stream_count) AS total_stream
FROM genres g
JOIN track_genres tg
	ON g.genre_id = tg.genre_id
JOIN tracks t
    ON tg.track_id = t.track_id
JOIN streaming_stats st
	ON tg.track_id = st.track_id
GROUP BY g.genre_name
ORDER BY total_stream DESC;
------------------------------------------------------------------------------------

/*Genre Performance — Question 2
“Which genres are consistently strong vs. one-hit wonders?
that is to say: “On average, how much does each track in this genre perform?”*/

SELECT
	g.genre_name,
    SUM(st.stream_count)/COUNT(DISTINCT st.track_id) AS genre_performance
FROM genres g
JOIN track_genres tg
	ON g.genre_id = tg.genre_id
JOIN streaming_stats st
	ON tg.track_id = st.track_id
GROUP BY genre_name;
------------------------------------------------------------------------------------

/*🚀 Genre Performance - Quesion 3
“Which genres have the MOST tracks vs the MOST streams?”
👉 This checks:
popularity (volume)
vs performance (quality)*/

SELECT 
	g.genre_name,
    COUNT(DISTINCT st.track_id) AS track_number,
    SUM(st.stream_count) AS total_stream
FROM genres g
JOIN track_genres tg
	ON g.genre_id = tg.genre_id
JOIN tracks t
	ON tg.track_id = t.track_id
JOIN streaming_stats st
	ON t.track_id = st.track_id
GROUP BY genre_name;
------------------------------------------------------------------------------------

/*Label Performance — Question 1
“Which labels are driving the most streams?”*/

SELECT 
	l.label_name,
    SUM(st.stream_count) AS total_stream
FROM labels l
JOIN releases r
	ON l.label_id = r.label_id
JOIN tracks t
	ON r.release_id = t.release_id
JOIN streaming_stats st
	ON t.track_id = st.track_id
GROUP BY l.label_name
ORDER BY total_stream DESC;
------------------------------------------------------------------------------------

/*🎯 Label Performance — Question 2
“Which labels are most efficient (high performance per release)?”
Efficiency = “On average, each release gets how many streams?”*/

SELECT 
	l.label_name,
    SUM(st.stream_count)/COUNT(DISTINCT r.release_id) AS label_efficiency
FROM labels l
JOIN releases r
	ON l.label_id = r.label_id
JOIN tracks t
	ON r.release_id = t.release_id
JOIN streaming_stats st
	ON t.track_id = st.track_id
GROUP BY l.label_name
ORDER BY label_efficiency DESC;
------------------------------------------------------------------------------------

/* 🚀 Next: Release-Level Insights- Question 1
“Which releases generate the most total streams?”*/

SELECT 
	 r.release_title,
     SUM(st.stream_count) AS total_stream
FROM releases r
JOIN tracks t
	ON r.release_id = t.release_id
JOIN streaming_stats st
	ON t.track_id = st.track_id
GROUP BY r.release_title
ORDER BY total_stream DESC;
------------------------------------------------------------------------------------

/*Release-Level — Question 2
“Do albums or singles perform better?”*/

SELECT 
	r.release_type,
    SUM(st.stream_count) AS performance
FROM releases r
JOIN tracks t
	ON r.release_id = t. release_id
JOIN streaming_stats st
	ON t.track_id = st.track_id
GROUP BY r.release_type
ORDER BY performance DESC;
------------------------------------------------------------------------------------

/*Release-Level — Question 3 (final)
“Does country affect performance?” */

SELECT 
	r.release_country,
    SUM(st.stream_count) AS performance
FROM releases r
JOIN tracks t
	ON r.release_id = t.release_id
JOIN streaming_stats st
	ON t.track_id = st.track_id
GROUP BY r.release_country
ORDER BY performance DESC;
------------------------------------------------------------------------------------

/*Track-Level Signals - Question 1
“Do tracks with more playlist adds get more streams?” */


SELECT 
	track_id,
    SUM(playlist_adds) AS total_playlist_adds,
    SUM(stream_count) AS total_stream
FROM streaming_stats
GROUP BY track_id
ORDER BY total_stream DESC;

/*OR*/

SELECT 
    t.track_title,
    st.track_id,
    SUM(st.playlist_adds) AS total_playlist_adds,
    SUM(st.stream_count) AS total_stream
FROM streaming_stats st
JOIN tracks t
    ON st.track_id = t.track_id
GROUP BY t.track_title, st.track_id
ORDER BY total_stream DESC;
------------------------------------------------------------------------------------

/*Track-Level Signals - Question 2
“Does skip rate negatively impact streams?”*/

SELECT 
	t.track_id,
	t.track_title,
	AVG(st.skip_rate) AS average_skip_rate,
    SUM(st.stream_count) AS total_stream
FROM streaming_stats st
JOIN tracks t
	ON t.track_id = st.track_id
GROUP BY t.track_id,t.track_title
ORDER BY total_stream DESC;
------------------------------------------------------------------------------------

/*Track-Level Signals - Question 3
Do longer tracks perform better?*/

SELECT
	CASE
		WHEN t.duration_seconds < 180 THEN 'short'
        WHEN t.duration_seconds BETWEEN 180 AND 300 THEN 'medium'
        ELSE 'long'
	END AS category_duration,
    SUM(st.stream_count) / COUNT(DISTINCT t.track_id) AS avg_streams_per_track
FROM tracks t
JOIN streaming_statS st
	ON t.track_id = st.track_id
GROUP BY 
	CASE
		WHEN t.duration_seconds < 180 THEN 'short'
        WHEN t.duration_seconds BETWEEN 180 AND 300 THEN 'medium'
        ELSE 'long'
	END
ORDER BY avg_streams_per_track DESC;