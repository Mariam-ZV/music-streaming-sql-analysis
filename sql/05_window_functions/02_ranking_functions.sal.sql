/* Question 1
“Rank artists by total streams.” */

SELECT
	a.artist_id,
    a.artist_name,
    SUM(st.stream_count) AS total_stream,
    RANK() OVER(ORDER BY SUM(st.stream_count) DESC)
		AS artist_rank
FROM artists a
JOIN releases r
	ON a.artist_id = r.artist_id
JOIN tracks t
	ON t.release_id = r.release_id
JOIN streaming_stats st
	ON st.track_id = t.track_id
GROUP BY 
	a.artist_id, 
    a.artist_name;
-------------------------------------------------------------------------------

/*Question 2
“Rank tracks by stream count.”*/

SELECT
	track_id,
    SUM(stream_count) total_stream,
    RANK() OVER(ORDER BY SUM(stream_count) DESC) 
		AS track_rank
	FROM streaming_stats
    GROUP BY track_id;
-------------------------------------------------------------------------------

/*Question 3
“Find top 3 tracks per platform.”*/

WITH track_ranking AS (
		SELECT
			track_id,
			platform,
			SUM(stream_count) AS total_stream,
			RANK() OVER(PARTITION BY platform ORDER BY SUM(stream_count) DESC) 
				AS track_rank
		FROM streaming_stats
		GROUP BY track_id, platform)
SELECT
	track_id,
    platform,
    total_stream,
    track_rank
FROM track_ranking
WHERE track_rank <= 3;
-------------------------------------------------------------------------------

/* Question 4
“Find top releases within each country.”*/

SELECT
	r.release_id,
    r.release_title,
    r.release_country,
    SUM(st.stream_count) AS total_stream,
    RANK() OVER(PARTITION BY r.release_country ORDER BY SUM(st.stream_count) DESC)
		AS release_rank
FROM releases r
JOIN tracks t
	ON t.release_id = r.release_id
JOIN streaming_stats st
	ON st.track_id = t.track_id
GROUP BY 
	r.release_id,
    r.release_title,
    r.release_country;
-------------------------------------------------------------------------------

/* Question 5
“Rank genres based on average streams.” */

SELECT
	g.genre_id,
    g.genre_name,
    AVG(st.stream_count) AS average_stream,
    RANK() OVER(ORDER BY AVG(st.stream_count) DESC)
			AS 	genre_rank
	FROM genres g
JOIN track_genres tg
	ON tg.genre_id = g.genre_id
JOIN streaming_stats st
	ON st.track_id = tg.track_id
GROUP BY 
	g.genre_id,
    g.genre_name;
-------------------------------------------------------------------------------

    /*Question 6
“Show most streamed track for each artist.”*/

WITH track_ranking AS (
    SELECT
        t.track_id,
        a.artist_id,
        a.artist_name,
        SUM(st.stream_count) AS total_stream,
        RANK() OVER(
            PARTITION BY a.artist_id
            ORDER BY SUM(st.stream_count) DESC
        ) AS track_rank
    FROM artists a
    JOIN releases r
        ON a.artist_id = r.artist_id
    JOIN tracks t
        ON t.release_id = r.release_id
    JOIN streaming_stats st
        ON st.track_id = t.track_id
    GROUP BY
        t.track_id,
        a.artist_id,
        a.artist_name
)

SELECT
    track_id,
    artist_id,
    artist_name,
    total_stream,
    track_rank
FROM track_ranking
WHERE track_rank = 1;
-------------------------------------------------------------------------------

/*Question 7
“Assign a unique row number to tracks based on stream count”*/

SELECT
	track_id,
    ROW_NUMBER () OVER(ORDER BY stream_count DESC)
		AS row_num
FROM streaming_stats;
-------------------------------------------------------------------------------

/*Question 8
“Show the latest release per artist using row numbers.”*/

WITH latest_release_order AS (
SELECT 
	artist_id,
    release_title,
    ROW_NUMBER() OVER(PARTITION BY artist_id ORDER BY release_date DESC)
		AS latest_release
FROM releases)
SELECT
	artist_id,
    release_title,
    latest_release
FROM latest_release_order
WHERE latest_release = 1;

-- OR 

WITH latest_release_order AS (
SELECT 
	artist_id,
    release_title,
    RANK() OVER(PARTITION BY artist_id ORDER BY release_date DESC)
		AS latest_release
FROM releases)
SELECT
	artist_id,
    release_title,
    latest_release
FROM latest_release_order
WHERE latest_release = 1;
-------------------------------------------------------------------------------

/*Question 9
“Rank artists by total streams without skipping rank numbers.”*/

SELECT 
	a.artist_id,
    a.artist_name,
    SUM(st.stream_count) AS total_stream,
    DENSE_RANK() OVER(ORDER BY SUM(st.stream_count)DESC) AS artist_rank
FROM artists a
JOIN releases r
	ON r.artist_id = a.artist_id
JOIN tracks t
	ON t.release_id = r.release_id
JOIN streaming_stats st
	ON st.track_id = t.track_id
GROUP BY 	
	a.artist_id,
    a.artist_name;
-------------------------------------------------------------------------------

/* Question 10 
“Rank genres by average streams using dense ranking.” */

SELECT
	g.genre_id,
    g.genre_name,
    AVG(st.stream_count) AS average_stream,
    DENSE_RANK() OVER(ORDER BY AVG(st.stream_count)DESC) AS average_rank
FROM genres g
JOIN track_genres tg
	ON g.genre_id = tg.genre_id
JOIN streaming_stats st
	ON st.track_id = tg.track_id
GROUP BY
	g.genre_id,
    g.genre_name;
-------------------------------------------------------------------------------

/* Question 11
“Show the highest-streamed track within each platform beside every track.”*/

SELECT
	track_id,
    platform,
    SUM(stream_count) AS total_stream,
    FIRST_VALUE(track_id) OVER(PARTITION BY platform ORDER BY SUM(stream_count) DESC)
			AS top_track
FROM streaming_stats
GROUP BY 
	track_id,
    platform;
-------------------------------------------------------------------------------

/* Question 12 
“Show the top-performing release within each country beside all releases.”*/

SELECT 
	r.release_id,
    r.release_title,
    r.release_country,
    SUM(st.stream_count) AS total_stream,
    FIRST_VALUE(r.release_id)OVER(PARTITION BY r.release_country ORDER BY SUM(st.stream_count)DESC)
			AS top_performing_release
 FROM releases r
JOIN tracks t
	ON t.release_id = r.release_id
JOIN streaming_stats st
	ON st.track_id = t.track_id
GROUP BY 
	r.release_id,
    r.release_title,
    r.release_country;
    
-- RANK()
WITH top_release_rank AS(
		SELECT 
			r.release_id,
			r.release_title,
			r.release_country,
			SUM(st.stream_count) AS total_stream,
			RANK() OVER(PARTITION BY r.release_country ORDER BY SUM(st.stream_count)DESC)
					AS top_release
		FROM releases r
		JOIN tracks t
			ON t.release_id = r.release_id
		JOIN streaming_stats st
			ON st.track_id = t.track_id
		GROUP BY 
			r.release_id,
			r.release_title,
			r.release_country)
SELECT 
	release_id,
	release_title,
	release_country,
	total_stream,
	top_release
FROM top_release_rank
WHERE top_release = 1;
-------------------------------------------------------------------------------

/* Question 13
“Show the lowest-streamed track within each platform beside every track.” */

SELECT 
	track_id,
    platform,
    SUM(stream_count) AS total_stream,
    LAST_VALUE(track_id)OVER(PARTITION BY platform ORDER BY SUM(stream_count)
				ROWS BETWEEN 
				UNBOUNDED PRECEDING 
				AND UNBOUNDED FOLLOWING)
				AS lowest_streamed_track
FROM streaming_stats
GROUP BY 
	track_id,
    platform;
-------------------------------------------------------------------------------

/* Question 14 
“Compare each track against the weakest performer in its genre.”*/

SELECT
	st.track_id,
    g.genre_name,
    SUM(st.stream_count) AS total_stream,
    LAST_VALUE(st.track_id)OVER(PARTITION BY g.genre_name ORDER BY SUM(st.stream_count) 
			ROWS BETWEEN UNBOUNDED PRECEDING 
			AND UNBOUNDED FOLLOWING)
            AS weakest_track
From genres g
JOIN track_genres tg
	ON tg.genre_id = g.genre_id 
JOIN streaming_stats st
	ON st.track_id = tg.track_id
GROUP BY 
	st.track_id,
    g.genre_name;
