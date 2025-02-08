-- заполняем таблицу styles
insert into styles (style_name)
VALUES ('Pop'), ('Rock'), ('Hip-Hop'), ('Jazz'), ('Classical');

-- Добавляем исполнителей в таблицу artists
insert into singers (name)
VALUES ('Ariana Grande'),('Ed Sheeran'),('Drake'),('Beyoncé');
 
-- Заполнение таблицы albums (альбомы)
INSERT INTO albums (title, release_date) 
VALUES ('Thank U, Next', '2019-02-08'), ('Divide', '2017-03-03'), ('Scorpion', '2018-06-29'), ('Lemonade', '2016-04-23');

INSERT INTO albums (title, release_date) 
VALUES ('testss', '2020-02-08');

-- Заполнение таблицы songs (треки)
INSERT INTO songs (title, duration, album_id) VALUES
('Imagine', '00:03:32', 1),  -- Thank U, Next
('No Tears Left to Cry', '00:03:25', 1),
('Shape of You', '00:03:53', 2),  -- Divide
('Castle on the Hill', '00:04:21', 2),
('God''s Plan', '00:03:19', 3),  -- Scorpion
('In My Feelings', '00:03:38', 3),
('Formation', '00:03:26', 4),  -- Lemonade
('Sorry', '00:03:20', 4);

INSERT INTO songs (title, duration, album_id) values
('premyne', '00:02:15', 4),
('my nerv', '00:01:10', 1);

-- Заполнение таблицы collection (сборники)
INSERT INTO collection (title, year) VALUES
('Top Hits 2020', 2020),
('Best of Pop', 2019),
('Rock Classics', 2018),
('Hip-Hop Essentials', 2021);

-- Заполнение связующей таблицы singer_genres
INSERT INTO singer_styles (singer_id, style_id) VALUES
(1, 1),  -- Ariana Grande - Pop
(1, 4),  -- Ariana Grande - Jazz
(2, 1),  -- Ed Sheeran - Pop
(2, 2),  -- Ed Sheeran - Rock
(3, 3),  -- Drake - Hip-Hop
(4, 1),  -- Beyoncé - Pop
(4, 2);  -- Beyoncé - Rock

-- Заполнение связующей таблицы singer_albums
INSERT INTO singer_albums (singer_id, album_id) VALUES
(1, 1),  -- Ariana Grande - Thank U, Next
(2, 2),  -- Ed Sheeran - Divide
(3, 3),  -- Drake - Scorpion
(4, 4);  -- Beyoncé - Lemonade

INSERT INTO singer_albums (singer_id, album_id) VALUES
(1, 5);

-- Заполнение связующей таблицы compilation_songs
INSERT INTO collection_songs (collection_id, song_id) VALUES
(1, 1),  -- Top Hits 2020 - Imagine
(1, 3),  -- Top Hits 2020 - Shape of You
(2, 2),  -- Best of Pop - No Tears Left to Cry
(2, 4),  -- Best of Pop - Castle on the Hill
(3, 5),  -- Rock Classics - God's Plan
(3, 6),  -- Rock Classics - In My Feelings
(4, 7),  -- Hip-Hop Essentials - Formation
(4, 8);  -- Hip-Hop Essentials - Sorry