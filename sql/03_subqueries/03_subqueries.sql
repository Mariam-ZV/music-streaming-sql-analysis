/* WHERE Subqueries — Filtering & Benchmark Comparisons */
-----------------------------------------------------------------------------

/* Subqueries— Question 1
“Which streaming records are performing above average in terms of total streams?”*/

SELECT
	track_id,
	stream_count
FROM streaming_stats
WHERE stream_count > 
	(SELECT AVG(stream_count)FROM streaming_stats);
-----------------------------------------------------------------------------

/* Question 2: 
“Which streaming records are underperforming in terms of listener retention 
(i.e. have higher-than-average skip rates)?”
Plain English: We want to find tracks that people skip more than usual. */

SELECT
	track_id,
    skip_rate
FROM streaming_stats
WHERE skip_rate > 
	(SELECT AVG(skip_rate)FROM streaming_stats);
-----------------------------------------------------------------------------

/* Question 3:
“Which streaming records are gaining more playlist exposure than average?”
Plain English: We want tracks that are added to playlists more than usual.*/

SELECT 
	track_id,
    playlist_adds
FROM streaming_stats
WHERE playlist_adds >
	(SELECT AVG(playlist_adds)FROM streaming_stats);
-----------------------------------------------------------------------------

/* Question 4 (Business version)
“Which streaming records are underperforming in terms of total streams compared to the platform average?”
Plain English: We want tracks that are getting fewer streams than usual.*/

SELECT
	track_id, 
    stream_count
FROM streaming_stats
WHERE stream_count <
	(SELECT AVG(stream_count)FROM streaming_stats);
-----------------------------------------------------------------------------

/* Question 5: 
“Which tracks are longer than the typical track duration on the platform?”
Plain English: We want tracks whose duration is above average.*/

SELECT
	track_id, 
    duration_seconds
FROM tracks
WHERE duration_seconds >
	(SELECT AVG(duration_seconds)FROM tracks);
-----------------------------------------------------------------------------

/* Question 6:
Which artists have above-average total streams?
HAVING SUM(st.stream_count) > (average of all artists)*/

SELECT
	a.artist_name,
    SUM(st.stream_count) AS total_stream
FROM artists a
JOIN releases r
	ON a.artist_id = r.artist_id
JOIN tracks t
	ON r.release_id = t.release_id
JOIN streaming_stats st
    ON t.track_id = st.track_id
GROUP BY a.artist_name
HAVING SUM(st.stream_count) >
	(SELECT
		AVG(total_stream)
        FROM (
				SELECT
					a.artist_name,
					SUM(st.stream_count) AS total_stream
				FROM artists a
				JOIN releases r
					ON a.artist_id = r.artist_id
				JOIN tracks t
					ON r.release_id = t.release_id
				JOIN streaming_stats st
					ON t.track_id = st.track_id
				GROUP BY a.artist_name) AS total_stream_per_artist
	);
-----------------------------------------------------------------------------

/* Question 7
Which tracks have more streams than the overall average track?*/

SELECT 
	track_id,
    SUM(stream_count) AS total_stream
FROM streaming_stats
GROUP BY track_id
HAVING SUM(stream_count) > 
	(SELECT 
		AVG(total_stream) 
	 FROM (SELECT 
				track_id,
				SUM(stream_count) AS total_stream
			FROM streaming_stats
			GROUP BY track_id) AS total_stream_by_track
	);
-----------------------------------------------------------------------------

/* Question 8
Which releases performed better than the average release?
*/
	
SELECT 
	r.release_id,
    r.release_title,
    SUM(stream_count) AS total_stream
FROM releases r
JOIN tracks t
	ON r.release_id = t.release_id
JOIN streaming_stats st
	ON t.track_id = st.track_id
GROUP BY r.release_id, r.release_title
HAVING total_stream >
		(SELECT
			AVG(total_stream)
		 FROM(SELECT 
				r.release_id,
				r.release_title,
				SUM(stream_count) AS total_stream
			  FROM releases r
			  JOIN tracks t
				  ON r.release_id = t.release_id
			  JOIN streaming_stats st
				  ON t.track_id = st.track_id
			  GROUP BY r.release_id, r.release_title) AS total_stream_per_release
		);
-----------------------------------------------------------------------------

/*Question 9
"Which genres have higher average streams than overall genre average?"
In plain English:
“Is this genre’s average performance higher than the typical genre’s average?”*/

SELECT
	g.genre_id,
	g.genre_name,
    AVG(st.stream_count) AS average_stream
FROM genres g
JOIN track_genres tg
	ON g.genre_id = tg.genre_id
JOIN streaming_stats st
	ON tg.track_id = st.track_id
GROUP BY g.genre_id, g.genre_name
HAVING average_stream >
	(SELECT AVG(average_stream)
     FROM(SELECT
		g.genre_id,
		g.genre_name,
		AVG(st.stream_count) AS average_stream
	 FROM genres g
	 JOIN track_genres tg
		 ON g.genre_id = tg.genre_id
	 JOIN streaming_stats st
		 ON tg.track_id = st.track_id
	 GROUP BY g.genre_id, g.genre_name) AS average_stream_per_genre			
    );
-----------------------------------------------------------------------------

/*Question 10
"Which artists have at least one track above average performance?" */
    
SELECT DISTINCT
    a.artist_name
FROM artists a
JOIN releases r
    ON a.artist_id = r.artist_id
JOIN tracks t
    ON r.release_id = t.release_id
JOIN streaming_stats st
    ON t.track_id = st.track_id
WHERE st.stream_count >
    (SELECT AVG(stream_count) FROM streaming_stats);
-----------------------------------------------------------------------------

/* Question 11
"Which tracks belong to genres that are linked to more than one track?" */

SELECT 
    t.track_id,
    t.track_title
FROM tracks t
JOIN track_genres tg
    ON t.track_id = tg.track_id
WHERE tg.genre_id IN (
    SELECT genre_id
    FROM track_genres
    GROUP BY genre_id
    HAVING COUNT(track_id) > 1
);
-----------------------------------------------------------------------------

/* Question 12
"Which artists have released at least one release?" */

SELECT 
	artist_id,
    artist_name
FROM artists 
WHERE artist_id IN (
	SELECT artist_id
    FROM releases);
-----------------------------------------------------------------------------
/* Question 13
"Which artists have no releases?"*/

SELECT 
    artist_id,
    artist_name
FROM artists
WHERE artist_id NOT IN (
    SELECT artist_id
    FROM releases
);
-----------------------------------------------------------------------------

/* Question 14
Which labels have released music in more than one country? */

SELECT
	l.label_id,
    l.label_name
FROM labels l
WHERE l.label_id IN (
			SELECT r.label_id
            From releases r
            GROUP BY r.label_id
            HAVING COUNT(DISTINCT release_country) > 1);
-----------------------------------------------------------------------------

/* Question 15
"Which tracks have never appeared in streaming_stats?" */

SELECT 
	t.track_id,
    t.track_title
FROM tracks t
WHERE t.track_id NOT IN (
			SELECT 
				track_id
			FROM streaming_stats);
            
-- OR

SELECT
	t.track_id,
    t.track_title
FROM tracks t
WHERE NOT EXISTS (
    SELECT 1
    FROM streaming_stats st
    WHERE t.track_id = st.track_id
);
-----------------------------------------------------------------------------
/* SELECT Subqueries — Adding Context */
-----------------------------------------------------------------------------

/*Question 16
"For each artist, show total streams and their percentage of total platform streams."*/

SELECT
	a.artist_name,
    SUM(st.stream_count) AS total_stream,
    ROUND(
		   SUM(st.stream_count) * 100/
		   (SELECT SUM(stream_count)FROM streaming_stats),2
		 ) AS percentage_total_platform
FROM artists a
JOIN releases r
	ON r.artist_id = a.artist_id
JOIN tracks t
	ON t.release_id = r.release_id
JOIN streaming_stats st
	ON st.track_id = t.track_id
GROUP BY a.artist_id;
-----------------------------------------------------------------------------

/* Question 17
"For each track, show its stream count and how it compares to the global average."*/

SELECT
	t.track_id,
    t.track_title,
    SUM(st.stream_count) AS total_streams,
    SUM(st.stream_count) - (SELECT
								AVG(total_stream)
							FROM (SELECT
									track_id,
									SUM(stream_count)AS total_stream
								  FROM streaming_stats
								  GROUP BY track_id) AS total_stream_per_track
							)AS comparison_to_global_average				   
    
FROM tracks t
JOIN streaming_stats st
	ON st.track_id = t.track_id
GROUP BY t.track_id, t.track_title;
-----------------------------------------------------------------------------

/*Question 18
"For each label, show its total streams alongside the overall platform total."*/

SELECT
	l.label_id,
    l.label_name,
    SUM(st.stream_count) AS total_stream,
    (SELECT SUM(stream_count) FROM streaming_stats) AS overal_platform
    
FROM labels l
JOIN releases r
	ON r.label_id = l.label_id
JOIN tracks t
	on t.release_id = r.release_id
JOIN streaming_stats st
	ON st.track_id = t.track_id
GROUP BY l.label_id, l.label_name;
-----------------------------------------------------------------------------

/*Question 19
"For each genre, show total streams and its share of overall streams."*/

SELECT
	g.genre_id,
    g.genre_name,
    SUM(st.stream_count) AS total_stream,
    ROUND(
    SUM(st.stream_count) * 100 /
		(SELECT SUM(stream_count) FROM streaming_stats),2) AS share_of_overal_stream
    
FROM genres g
JOIN track_genres tg
	ON tg.genre_id = g.genre_id
JOIN streaming_stats st
	ON st.track_id = tg.track_id
GROUP BY g.genre_id, g.genre_name;
-----------------------------------------------------------------------------

/* Question 20
"For each streaming record, show the difference between its stream count and the average stream count."*/
/*
For each record, show:
its stream count
the global average
the difference between them
*/

SELECT
    track_id,
    stream_count,
    (SELECT AVG(stream_count)
     FROM streaming_stats) AS global_average,
     
    stream_count -
    (SELECT AVG(stream_count)
     FROM streaming_stats) AS difference_from_average

FROM streaming_stats;
-----------------------------------------------------------------------------
/* FROM Subqueries — Derived Tables */
-----------------------------------------------------------------------------

/* Question 21
"Rank artists based on total streams."*/

SELECT
	*
FROM (
		SELECT
			a.artist_id,
			a.artist_name,
			SUM(st.stream_count) AS total_streams
		FROM artists a
		JOIN releases r
			ON r.artist_id = a.artist_id
		JOIN tracks t
			ON t.release_id = r.release_id
		JOIN streaming_stats st
			ON st.track_id = t.track_id
		GROUP BY a.artist_id, a.artist_name
	 ) AS artist_stream
ORDER BY total_streams DESC;
-----------------------------------------------------------------------------

/* Question 22
"Find labels with above-average streams per release."*/

-- 1) find labels:
SELECT 
	l.label_id,
    l.label_name
FROM labels l;

-- 2) find average of total stream per release: 
-- 2a) total_stream per label
SELECT
	l.label_id,
	l.label_name,
	SUM(st.stream_count) AS total_stream
FROM labels l
JOIN releases r
	ON r.label_id = l.label_id
JOIN tracks t
	ON t.release_id = r.release_id
JOIN streaming_stats st
	ON st.track_id = t.track_id
GROUP BY l.label_id, l.label_name;

-- 2b) average of total stream per label

SELECT
	l.label_id,
	l.label_name,
	SUM(st.stream_count) / 
		COUNT(DISTINCT r. release_id) 
		AS avg_streams_per_release
FROM labels l
JOIN releases r
	ON r.label_id = l.label_id
JOIN tracks t
	ON t.release_id = r.release_id
JOIN streaming_stats st
	ON st.track_id = t.track_id
GROUP BY l.label_id, l.label_name;	 


-- 3) above-average streams per release

SELECT *
FROM (
        SELECT
            l.label_id,
            l.label_name,
            SUM(st.stream_count) / COUNT(DISTINCT r.release_id)
                AS avg_streams_per_release

        FROM labels l
        JOIN releases r
            ON r.label_id = l.label_id
        JOIN tracks t
            ON t.release_id = r.release_id
        JOIN streaming_stats st
            ON st.track_id = t.track_id

        GROUP BY l.label_id, l.label_name

     ) AS label_performance
     

WHERE avg_streams_per_release >


    (
        SELECT AVG(avg_streams_per_release)
        FROM (
                SELECT
                    l.label_id,
                    l.label_name,
                    SUM(st.stream_count) / COUNT(DISTINCT r.release_id)
                        AS avg_streams_per_release

                FROM labels l
                JOIN releases r
                    ON r.label_id = l.label_id
                JOIN tracks t
                    ON t.release_id = r.release_id
                JOIN streaming_stats st
                    ON st.track_id = t.track_id

                GROUP BY l.label_id, l.label_name

             ) AS label_average
    );
-----------------------------------------------------------------------------

/*Question 23
"Identify genres that have strong average performance per track."

Steps: 
1- calculate average performance per track for each genre.
2- calculate the average of those genre performances.
3- keep only genres performing above that benchmark.*/


SELECT *
FROM (

    SELECT
        g.genre_id,
        g.genre_name,
        SUM(st.stream_count) /
            COUNT(DISTINCT tg.track_id)
            AS avg_streams_per_track

    FROM genres g
    JOIN track_genres tg
        ON tg.genre_id = g.genre_id
    JOIN streaming_stats st
        ON st.track_id = tg.track_id

    GROUP BY g.genre_id, g.genre_name

) AS genre_performance

WHERE avg_streams_per_track >

(
    SELECT AVG(avg_streams_per_track)

    FROM (

        SELECT
            g.genre_id,
            g.genre_name,
            SUM(st.stream_count) /
                COUNT(DISTINCT tg.track_id)
                AS avg_streams_per_track

        FROM genres g
        JOIN track_genres tg
            ON tg.genre_id = g.genre_id
        JOIN streaming_stats st
            ON st.track_id = tg.track_id

        GROUP BY g.genre_id, g.genre_name

    ) AS genre_average
);










            


