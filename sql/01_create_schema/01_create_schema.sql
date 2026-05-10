CREATE DATABASE IF NOT EXISTS music_portfolio;
USE music_portfolio;

DROP TABLE IF EXISTS streaming_stats;
DROP TABLE IF EXISTS track_genres;
DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS releases;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS labels;
DROP TABLE IF EXISTS artists;

CREATE TABLE artists (
  artist_id INT PRIMARY KEY,
  artist_name VARCHAR(100) NOT NULL,
  country VARCHAR(60),
  artist_type VARCHAR(30),
  start_year INT
);

CREATE TABLE labels (
  label_id INT PRIMARY KEY,
  label_name VARCHAR(100) NOT NULL,
  country VARCHAR(60),
  founded_year INT
);

CREATE TABLE releases (
  release_id INT PRIMARY KEY,
  release_title VARCHAR(120) NOT NULL,
  artist_id INT NOT NULL,
  label_id INT NOT NULL,
  release_date DATE,
  release_country VARCHAR(60),
  release_type VARCHAR(30),
  FOREIGN KEY (artist_id) REFERENCES artists(artist_id),
  FOREIGN KEY (label_id) REFERENCES labels(label_id)
);

CREATE TABLE tracks (
  track_id INT PRIMARY KEY,
  release_id INT NOT NULL,
  track_title VARCHAR(120) NOT NULL,
  track_number INT,
  duration_seconds INT,
  FOREIGN KEY (release_id) REFERENCES releases(release_id)
);

CREATE TABLE genres (
  genre_id INT PRIMARY KEY,
  genre_name VARCHAR(60) NOT NULL
);

CREATE TABLE track_genres (
  track_id INT NOT NULL,
  genre_id INT NOT NULL,
  PRIMARY KEY (track_id, genre_id),
  FOREIGN KEY (track_id) REFERENCES tracks(track_id),
  FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE streaming_stats (
  stat_id INT AUTO_INCREMENT PRIMARY KEY,
  track_id INT NOT NULL,
  platform VARCHAR(50) NOT NULL,
  listen_month DATE NOT NULL,
  stream_count INT NOT NULL,
  skip_rate DECIMAL(5,3),
  playlist_adds INT,
  FOREIGN KEY (track_id) REFERENCES tracks(track_id)
);
