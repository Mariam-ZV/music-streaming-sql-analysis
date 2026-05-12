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





