-- ЗАДАНИЕ 2

-- Название и продолжительность самого длительного трека.

-- SELECT title, duration FROM songs
-- ORDER BY duration DESC
-- LIMIT 1;

-- или можно так
SELECT title, duration FROM songs
WHERE duration = (select MAX(duration) from songs);


-- Название треков, продолжительность которых не менее 3,5 минут
SELECT title FROM songs
WHERE duration > '00:03:30'; 

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT title FROM collection
WHERE year BETWEEN 2018 and 2020;

-- Исполнители, чьё имя состоит из одного слова.
SELECT name FROM singers
WHERE name NOT LIKE '% %';

-- Название треков, которые содержат слово «мой» или «my».
SELECT title FROM songs
WHERE title ILIKE '% мой %' OR title ILIKE '% my %'
   OR title ILIKE 'мой %' OR title ILIKE 'my %'
   OR title ILIKE '% мой' OR title ILIKE '% my';


-- ЗАДАНИЕ 3

-- Количество исполнителей в каждом жанре.
--  COUNT(singer_styles.singer_id) AS singer_count  СКОЛЬКО РАЗ ПОЯВИЛОСЯ конкретное artist_id
SELECT styles.style_name, COUNT(singer_styles.singer_id) AS singer_count
FROM styles
LEFT JOIN singer_styles ON styles.style_id = singer_styles.style_id -- объединили две таблицы
GROUP BY styles.style_name  -- сгрупировали по названию жанра
ORDER BY singer_count DESC;	-- отсортировали по убыванию

-- Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT COUNT(songs.album_id) as count_songs_2019_2020
FROM albums
JOIN songs ON albums.album_id = songs.album_id
WHERE release_date BETWEEN '2019-01-01' AND '2020-12-31';

-- Средняя продолжительность треков по каждому альбому.
SELECT albums.title, AVG(songs.duration)
FROM albums
JOIN songs ON albums.album_id = songs.album_id
GROUP BY albums.title, albums.release_date;

-- Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT singers.name /* Получаем имена исполнителей */
FROM singers  /* Из таблицы исполнителей */
WHERE singers.name NOT IN ( /* Где имя исполнителя не входит в вложенную выборку */
    SELECT singers.name /* Получаем имена исполнителей */
    FROM singers /* Из таблицы исполнителей */
    LEFT JOIN singer_albums ON singers.singer_id = singer_albums.singer_id /* Объединяем с промежуточной таблицей */
    LEFT JOIN albums ON singer_albums.album_id = albums.album_id /* Объединяем с таблицей альбомов */
    WHERE albums.release_date IS NULL OR date_part('year', albums.release_date) = 2020 /* Где год альбома равен 2020 */
);


-- Названия сборников, в которых присутствует конкретный исполнитель (drake).
SELECT distinct collection.title 
FROM collection 
JOIN collection_songs ON collection.collection_id = collection_songs.collection_id
JOIN songs ON collection_songs.song_id = songs.song_id 
JOIN albums ON songs.album_id = albums.album_id 
JOIN singer_albums ON albums.album_id = singer_albums.album_id
JOIN singers ON singer_albums.singer_id = singers.singer_id
WHERE singers.name = 'Drake'