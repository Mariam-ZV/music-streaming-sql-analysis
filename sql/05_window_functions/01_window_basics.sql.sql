/* Question 1
““Show every streaming record, along with the overall average stream count beside each row.”” */

SELECT
    track_id,
    platform,
    stream_count,
    AVG(stream_count) OVER() AS overall_avg_stream
FROM streaming_stats;
--------------------------------------------------------------------------

/*Question 2:
"Show each artist’s total streams alongside platform average streams."*/

SELECT
	a.artist_id,
    a.artist_name,
    st.platform,
    SUM(st.stream_count) AS total_stream,
    AVG(SUM(st.stream_count)) OVER() AS avg_artist_streams
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
		st.platform ;
--------------------------------------------------------------------------

/*Question 3:
"Show each release and total releases within the dataset."*/

SELECT
	release_id,
    release_title,
    COUNT(release_id) OVER() AS release_count
FROM releases;
--------------------------------------------------------------------------

/*Question 4:
"Show each track’s stream count and percentage contribution to total streams."*/

SELECT
	track_id,
    stream_count,
    SUM(stream_count) OVER() AS total_stream,
    ROUND((stream_count / SUM(stream_count) OVER()) * 100, 2) 
		AS stream_contribution
    FROM streaming_stats;
    

