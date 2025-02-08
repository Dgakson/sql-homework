-- Создание базы данных
CREATE DATABASE music_collection;

-- Таблица для исполнителей
CREATE TABLE if not exists singers (
    singer_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
	styles_id INT
);

-- Таблица для жанров
CREATE TABLE IF NOT EXISTS styles (
    style_id SERIAL PRIMARY KEY,
    style_name VARCHAR(100) NOT NULL UNIQUE
);

-- Таблица для альбомов
CREATE TABLE IF NOT EXISTS albums (
    album_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_date DATE
);

-- Таблица для треков
CREATE TABLE IF NOT EXISTS songs (
    song_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    duration TIME,
    album_id INT,
    FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE CASCADE
);

-- Таблица для сборников
CREATE TABLE IF NOT EXISTS collection (
    collection_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    year INT
);

-- Связующая таблица для отношения многие-ко-многим между исполнителями и жанрами
CREATE TABLE IF NOT EXISTS singer_styles (
    singer_id INT,
    style_id INT,
    PRIMARY KEY (singer_id, style_id),
    FOREIGN KEY (singer_id) REFERENCES singers(singer_id) ON DELETE CASCADE,
    FOREIGN KEY (style_id) REFERENCES styles(style_id) ON DELETE CASCADE
);

-- Связующая таблица для отношения многие-ко-многим между исполнителями и альбомами
CREATE TABLE IF NOT EXISTS singer_albums (
    singer_id INT,
    album_id INT,
    PRIMARY KEY (singer_id, album_id),
    FOREIGN KEY (singer_id) REFERENCES singers(singer_id) ON DELETE CASCADE,
    FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE CASCADE
);

-- Связующая таблица для отношения многие-ко-многим между сборниками и треками
CREATE TABLE IF NOT EXISTS collection_songs (
    collection_id INT,
    song_id INT,
    PRIMARY KEY (collection_id, song_id),
    FOREIGN KEY (collection_id) REFERENCES collection(collection_id) ON DELETE CASCADE,
    FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE
);