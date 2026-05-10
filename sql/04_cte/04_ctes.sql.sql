/* Question 1
“Which streaming records have stream_count higher than the overall average?” */

-- CTE: 
WITH average_streams AS (
	SELECT
		AVG(stream_count) AS avg_stream_count
	FROM streaming_stats
)

SELECT
	st.track_id,
	st.stream_count
FROM streaming_stats st
JOIN average_streams a
WHERE st.stream_count > a.avg_stream_count;


-- Subquery:
SELECT 
	track_id,
    stream_count
FROM streaming_stats
WHERE stream_count > (SELECT AVG(stream_count) FROM streaming_stats);
---------------------------------------------------------------------

/*Question 2
"Which tracks have longer-than-average duration?"*/

-- CTE:
WITH average_duration AS
	(SELECT 
		AVG(duration_seconds) AS average_duration_seconds
     FROM tracks)
SELECT
	track_id,
    duration_seconds
FROM tracks
JOIN average_duration
WHERE duration_seconds >
	average_duration_seconds;
	
-- Subquery:
SELECT

	track_id, 
    duration_seconds
FROM tracks
	WHERE duration_seconds >
		(SELECT
			AVG(duration_seconds) 
         FROM tracks);
---------------------------------------------------------------------

/* Question 3
"Which streaming records have higher-than-average skip rates?"*/

-- CTE:
WITH average_skip AS
	(SELECT
		AVG(skip_rate) AS average_skip_rate
     FROM streaming_stats) 
SELECT
	st.track_id,
    st.skip_rate
FROM streaming_stats st
JOIN average_skip a
WHERE st.skip_rate > a.average_skip_rate;
     
     
-- Subquery:
SELECT
	st.track_id,
    st.skip_rate
FROM streaming_stats st
WHERE skip_rate >
	(SELECT
		AVG(skip_rate)
     FROM streaming_stats);
---------------------------------------------------------------------

/*Question 4
"Which artists have above-average total streams?" */

WITH total_stream_per_artist AS (
		SELECT 
			a.artist_id,
			a.artist_name,
			SUM(st.stream_count) AS total_stream
		FROM artists a
		JOIN releases r
			ON r.artist_id = a.artist_id
		JOIN tracks t
			ON t.release_id = r.release_id
		JOIN streaming_stats st
			ON st.track_id = t.track_id
		GROUP BY a.artist_id, a.artist_name)
SELECT 
	artist_id,
    artist_name,
    total_stream
FROM total_stream_per_artist
WHERE total_stream >
	(SELECT
		AVG(total_stream)
     FROM total_stream_per_artist);
---------------------------------------------------------------------

/* Question 5
"Which releases perform better than the average release?"*/

WITH release_performance AS (   
		SELECT
			r.release_id,
			r.release_title,
			SUM(st.stream_count) AS total_stream
		FROM releases r
		JOIN tracks t
			ON t.release_id = r.release_id
		JOIN streaming_stats st
			ON st.track_id = t.track_id
		GROUP BY r.release_id, r.release_title)
SELECT 
	release_id,
    release_title,
    total_stream
FROM release_performance
WHERE total_stream >
	(SELECT 
		AVG(total_stream)
     FROM release_performance);
---------------------------------------------------------------------

/*Question 6
Which genres have higher-than-average stream performance? */

WITH genre_performance AS (
		SELECT
			g.genre_id,
			g.genre_name,
			SUM(st.stream_count) AS total_performance
		FROM genres g
		JOIN track_genres tg
			ON tg.genre_id = g.genre_id
		JOIN tracks t
			ON t.track_id = tg.track_id
		JOIN streaming_stats st
			ON st.track_id = t.track_id
		GROUP BY g.genre_id, g.genre_name)
SELECT
	genre_id,
    genre_name,
    total_performance
FROM genre_performance
WHERE total_performance >
(SELECT 
	AVG(total_performance)
FROM genre_performance);
---------------------------------------------------------------------

/*Question 7
"For each artist, show total streams and percentage contribution to total platform streams."*/

-- total streams PER artist
SELECT
	a.artist_id,
    a.artist_name,
    SUM(st.stream_count) AS total_stream_per_artist
FROM artists a
JOIN releases r
	ON r.artist_id = a.artist_id
JOIN tracks t
	ON t.release_id = r.release_id
JOIN streaming_stats st
	ON st.track_id = t.track_id
GROUP BY a.artist_id, a.artist_name;

-- total platform streams
SELECT 
    SUM(st.stream_count) AS total_stream_per_platform
FROM streaming_stats st;


-- CTE
WITH artist_stream AS
		(SELECT
			a.artist_id,
			a.artist_name,
			SUM(st.stream_count) AS total_stream_per_artist
		FROM artists a
		JOIN releases r
			ON r.artist_id = a.artist_id
		JOIN tracks t
			ON t.release_id = r.release_id
		JOIN streaming_stats st
			ON st.track_id = t.track_id
		GROUP BY a.artist_id, a.artist_name),
        
platform_stream AS
(SELECT
    SUM(st.stream_count) AS total_stream_per_platform
FROM streaming_stats st)
        
SELECT 
	artist_id,
    artist_name,
    total_stream_per_artist,
    ROUND
    (total_stream_per_artist * 100 / 
    total_stream_per_platform, 2) AS artist_contribution_to_total_stream
FROM artist_stream
JOIN platform_stream;
---------------------------------------------------------------------

/*Question 8
"For each genre, show total streams and share of overall platform streams."*/
	
-- total streams PER genre
SELECT
	g.genre_id,
    g.genre_name,
    SUM(st.stream_count) AS total_stream_per_genre
FROM genres g
JOIN track_genres tg
	ON tg.genre_id = g.genre_id
JOIN streaming_stats st
	ON st.track_id = tg.track_id
GROUP BY g.genre_id, g.genre_name;

-- total platform streams
SELECT
	SUM(st.stream_count) AS total_platform_stream
FROM streaming_stats st;

-- CTE
WITH genre_performance AS
		(SELECT
			g.genre_id,
			g.genre_name,
			SUM(st.stream_count) AS total_stream_per_genre
		FROM genres g
		JOIN track_genres tg
			ON tg.genre_id = g.genre_id
		JOIN streaming_stats st
			ON st.track_id = tg.track_id
		GROUP BY g.genre_id, g.genre_name),

platform_performance AS
		(SELECT
			SUM(st.stream_count) AS total_platform_stream
		FROM streaming_stats st)

SELECT 
	genre_id,
    genre_name,
    total_stream_per_genre,
    ROUND
		(total_stream_per_genre *100/
			total_platform_stream,2) AS genre_contribution_to_total_stream
FROM genre_performance
JOIN platform_performance;
---------------------------------------------------------------------

/* Question 9
"Compare track performance against the global average."*/

WITH track_total_performance AS (
			SELECT 
				track_id,
				SUM(stream_count) AS track_performance
			FROM streaming_stats
			GROUP BY track_id),
            
global_average_performance AS (
			SELECT
				AVG(track_performance) AS global_average
			FROM track_total_performance)

SELECT 
	track_id,
    track_performance,
    global_average,
    CASE
		WHEN track_performance > global_average
			THEN 'Above Average'
			ELSE 'Below Average'
	END AS performance_vs_average

FROM track_total_performance
JOIN global_average_performance;
---------------------------------------------------------------------

/* Question 10
"Find labels with above-average streams per release."*/

WITH label_streams AS (
		SELECT
			labels.label_id,
			labels.label_name,
			SUM(streaming_stats.stream_count) AS total_stream
		FROM labels
		JOIN releases
			ON releases.label_id = labels.label_id
		JOIN tracks
			ON tracks.release_id = releases.release_id
		JOIN streaming_stats
			ON streaming_stats.track_id = tracks.track_id
		GROUP BY labels.label_id, labels.label_name
),

release_counts AS (
		SELECT
			label_id,
			COUNT(release_id) AS release_count
		FROM releases
		GROUP BY label_id
),

label_kpi AS (
		SELECT
			label_streams.label_id,
			label_streams.label_name,
			label_streams.total_stream,
			release_counts.release_count,
			label_streams.total_stream / release_counts.release_count AS streams_per_release
		FROM label_streams
		JOIN release_counts
			ON release_counts.label_id = label_streams.label_id
)

SELECT
	label_id,
	label_name,
	total_stream,
	release_count,
	streams_per_release
FROM label_kpi
WHERE streams_per_release >
	(
		SELECT
			AVG(streams_per_release)
		FROM label_kpi
	);
---------------------------------------------------------------------

/* Question 11
"Identify genres with strong average performance per track."*/

WITH genres_performance AS (
		SELECT
			g.genre_id,
            g.genre_name,
            SUM(st.stream_count) AS total_stream
		FROM genres g
        JOIN track_genres tg
			ON tg.genre_id = g.genre_id
		JOIN streaming_stats st
			ON st.track_id = tg.track_id
		GROUP BY g.genre_id, g.genre_name),

track_counts AS (
		SELECT 
			genre_id,
			COUNT(track_id) AS track_count
		FROM track_genres
		GROUP BY genre_id),
        
genre_kpi AS (
		SELECT
			genres_performance.genre_id,
			genres_performance.genre_name,
			genres_performance.total_stream,
			track_counts.track_count,
            genres_performance.total_stream /
				track_counts.track_count AS streams_per_track
			FROM genres_performance
            JOIN track_counts
				ON track_counts.genre_id = genres_performance.genre_id)
                
SELECT 
	genre_id, 
    genre_name,
    total_stream,
    track_count,
    streams_per_track
FROM genre_kpi
WHERE streams_per_track >
	(SELECT 
		AVG(streams_per_track)
	 FROM genre_kpi);


