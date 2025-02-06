-- ЗАДАНИЕ 2

-- Название и продолжительность самого длительного трека.
SELECT title, duration FROM songs
ORDER BY duration DESC
LIMIT 1;
-- или можно так
SELECT title, duration FROM songs
WHERE duration = (select MAX(duration) from songs);


-- Название треков, продолжительность которых не менее 3,5 минут
SELECT title FROM songs
WHERE duration > '00:03:30'; 

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT title FROM collection
WHERE release_date BETWEEN '2018-01-01' and '2020-01-31';

-- Исполнители, чьё имя состоит из одного слова.
SELECT name FROM artists
WHERE name NOT LIKE '% %';

-- Название треков, которые содержат слово «мой» или «my».
SELECT title FROM songs
WHERE title ilike '%my%' or title ilike '%мой%';



-- ЗАДАНИЕ 3

-- Количество исполнителей в каждом жанре.
--  COUNT(artist_styles.artist_id) AS artist_count  СКОЛЬКО РАЗ ПОЯВИЛОСЯ конкретное artist_id
SELECT styles.style_name, COUNT(artist_styles.artist_id) AS artist_count
FROM styles
LEFT JOIN artist_styles ON styles.style_id = artist_styles.style_id -- объединили две таблицы
GROUP BY styles.style_name  -- сгрупировали по названию жанра
ORDER BY artist_count DESC;	-- отсортировали по убыванию

-- Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT albums.title, albums.release_date, COUNT(songs.album_id)
FROM albums
JOIN songs ON albums.album_id = songs.album_id
WHERE albums.release_date BETWEEN '2019-01-01' AND '2020-12-31'
GROUP BY albums.title, albums.release_date;

-- Средняя продолжительность треков по каждому альбому.
SELECT albums.title, AVG(songs.duration)
FROM albums
JOIN songs ON albums.album_id = songs.album_id
GROUP BY albums.title, albums.release_date;

-- Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT artists.name 
FROM artists 
LEFT JOIN artist_albums ON artists.artist_id = artist_albums.artist_id
LEFT JOIN albums ON artist_albums.album_id = albums.album_id 
WHERE albums.release_date IS NULL OR date_part('year', albums.release_date) != 2019
GROUP BY artists.name;


-- Названия сборников, в которых присутствует конкретный исполнитель (drake).
SELECT collection.title 
FROM collection 
JOIN collection_songs ON collection.collection_id = collection_songs.collection_id
JOIN songs ON collection_songs.song_id = songs.song_id 
JOIN albums ON songs.album_id = albums.album_id 
JOIN artist_albums ON albums.album_id = artist_albums.album_id
JOIN artists ON artist_albums.artist_id = artists.artist_id
WHERE artists.artist_id = '1'
















