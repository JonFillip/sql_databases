-- CREATE TABLE FOR ALBUMS
CREATE TABLE albums (
	album_id bigserial,
	album_catalogue_code varchar(100), -- CAN ALSO BE USED AS A NATURAL PRIMARY KEY
	album_title text NOT NULL,
	album_artist text NOT NULL,
	album_release_date date NOT NULL,
	album_genre varchar(40),
	album_description text,
	CONSTRAINT album_id_key PRIMARY KEY (album_id),
	CONSTRAINT album_code_key UNIQUE (album_catalogue_code)
);

-- CREATE TABLE FOR SONGS IN ALBUMS
CREATE TABLE songs (
	song_id bigserial,
	song_title text,
	song_artist text,
	album_id bigint REFERENCES albums (album_id),
	CONSTRAINT song_id_key PRIMARY KEY (song_id, album_id)
);

-- CREATE INDEXES FOR SPECIFIC COLUMNS
CREATE INDEX artists_indx ON songs (song_artist);

CREATE INDEX album_artists_indx ON albums (album_artist);

CREATE INDEX album_title_indx ON albums (album_title);