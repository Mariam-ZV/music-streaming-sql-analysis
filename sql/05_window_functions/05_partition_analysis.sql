/* Question 1
“Each track’s share within its artist.”*/

WITH artist_total_streams AS (
		SELECT
			a.artist_id,
			a.artist_name,
			st.track_id,
			SUM(st.stream_count) AS total_stream,
			SUM(SUM(st.stream_count)) OVER(PARTITION BY a.artist_id)
					AS artist_stream
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
			st.track_id)
            
SELECT 
	track_id,
    total_stream,
    artist_stream,
    ROUND(
		total_stream / artist_stream,2) AS artist_share
FROM artist_total_streams;
----------------------------------------------------------------------

/* Question 2
“Each artist’s contribution within their country.” */

WITH artist_country_streams AS (
		SELECT
			a.artist_id,
			a.artist_name,
			a.country,
			SUM(st.stream_count) AS artist_total_stream,
			SUM(SUM(st.stream_count)) OVER(PARTITION BY a.country)
					AS country_stream_total
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
			a.country)

SELECT 
	artist_id,
	artist_name,
	country,
	artist_total_stream,
	country_stream_total,
    ROUND(
			(artist_total_stream / country_stream_total) * 100, 2) 
            AS artist_share
FROM artist_country_streams;
----------------------------------------------------------------------

/* Question 3
“Compare tracks against genre averages.” */

WITH track_genre_streams AS (
		SELECT
			st.track_id,
			g.genre_id,
			g.genre_name,
			SUM(st.stream_count) AS track_total_stream,
            ROUND(
			AVG(SUM(st.stream_count)) OVER(PARTITION BY g.genre_id), 2) 
				AS genre_avg_stream
		FROM streaming_stats st
		JOIN track_genres tg
			ON st.track_id = tg.track_id
		JOIN genres g
			ON g.genre_id = tg.genre_id
		GROUP BY 
			st.track_id,
			g.genre_id,
			g.genre_name)
            
SELECT
	track_id,
	genre_id,
	genre_name,
    track_total_stream,
    genre_avg_stream,
    CASE
		WHEN track_total_stream > genre_avg_stream THEN "above"
        WHEN track_total_stream < genre_avg_stream THEN "below"
        ELSE "no change" END AS track_vs_genre_avg
        
FROM track_genre_streams;
----------------------------------------------------------------------

/* Question 4
“Compare releases against label averages.”*/

WITH release_vs_label_stream AS (
		SELECT
			r.release_id,
			r.release_title,
			r.label_id,
			SUM(st.stream_count) AS release_total_stream,
			round(
			AVG(SUM(st.stream_count)) OVER (PARTITION BY  r.label_id), 2)
					AS label_avg_stream
		FROM releases r
		JOIN  tracks t  
			ON t.release_id = r.release_id
		JOIN streaming_stats st
			ON st.track_id = t.track_id
		GROUP BY 
			r.release_id,
			r.release_title,
			r.label_id)
            
SELECT
	release_id,
	release_title,
	label_id,
    release_total_stream,
    label_avg_stream,
    CASE 
		WHEN release_total_stream > label_avg_stream THEN "above"
        WHEN release_total_stream < label_avg_stream THEN "below"
        ELSE "no change" END AS trend
FROM release_vs_label_stream;
----------------------------------------------------------------------

/* Question 5
“Find artists outperforming country average.” */

WITH artist_vs_country_avg AS (
		SELECT
			a.artist_id,
			a.artist_name,
			a.country,
			SUM(st.stream_count) AS artist_total_stream,
            ROUND(
			AVG(SUM(st.stream_count)) OVER(PARTITION BY a.country), 2)
				AS country_avg_stream
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
			a.country)

SELECT
	artist_id,
	artist_name,
	country,
	artist_total_stream,
	country_avg_stream
FROM artist_vs_country_avg
WHERE artist_total_stream > country_avg_stream;
    