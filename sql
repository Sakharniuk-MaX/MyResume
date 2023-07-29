Skill SQL папа

1 Show all usernames in the next format
https://gyazo.com/41b95749c9eb8f0dc9d59b8406207133

SELECT 'First Name:' + ' ' + FirstName  + '; ' + 'Last Name:' + ' ' + LastName + '; 
' + 'FullName:' +FirstName + ' ' + LastName ';' 
FROM Users

2 Order videos by Views count and show videos and weren’t removed first
a. First should go videos with the highest views count that are not removed
b. Then videos with less views that are not removed
c. Then videos with the highest views count that are deleted
d. Then videos with the lowest views count that are deleted

https://gyazo.com/ab8b9c75eaa4f97541f4b8f86cafa1f5

SELECT * FROM Video
ORDER BY IsDeleted,Views DESC

3 Find all deleted videos

SELECT * FROM Video
WHERE IsDeleted = 1

4 Find all videos with 3 or more ‘likes’ and 0 ‘dislikes’ that are not deleted

SELECT * FROM Video
WHERE Likes <= 3 AND Dislikes = 0 AND IsDeleted = 0

5 Find all users and their channels.
Find all users and their channels. If user doesn’t have channel, we still want to see the user in the results list. 
If the user has more than one channel, we want to see multiple rows for every channel. Order the results by channel name.

https://gyazo.com/668c50055c935be57e93b6bbaa2ae94d

SELECT FirstName , LastName , Title, Description
FROM Users 
FULL OUTER JOIN Channel
ON Users.Id = Channel.UserId
ORDER BY Title ASC

6 Find all users and show their videos.
Find all users and show their videos. Don’t show users that don’t have any videos in their channels. 
Order them by views count starting from he highest.

https://gyazo.com/73e48220604b2a149d46002a7b78e4f1

SELECT FirstName, LastName , .Channel.Title , Video.Title ,  Views 
FROM Video , Users
INNER JOIN Channel
On Channel.UserId = Users.Id
WHERE Channel.IsDeleted = 0
ORDER BY Views DESC

7 Calculate number of items inside all playlists in the system

https://gyazo.com/34350040c556363076649bc93911f34a

SELECT COUNT(Playlist.Id)
FROM Playlist
INNER JOIN PlaylistItem
ON PlaylistItem.PlaylistId = Playlist.Id

8 Calculate number of items inside of all playlists of user with name “Test Test”

https://gyazo.com/28cadc6804d0bbd516d20fd6e83fc534

SELECT COUNT(Playlist.Id)
FROM Playlist
INNER JOIN PlaylistItem
ON PlaylistItem.PlaylistId = Playlist.Id
INNER JOIN Users
ON Playlist.UserId = Users.Id
WHERE Users.FirstName = 'Test' AND Users.LastName = 'Test'

9 Calculate count of videos for every channel

https://gyazo.com/e33f5e77f765a0fc6b35749413ae01bc

SELECT Channel.Title , COUNT(Video.ChannelId)
FROM Video
INNER JOIN Channel
ON Video.ChannelId = Channel.Id
GROUP BY Channel.Title

10 Calculate count of videos for every not deleted user and show users’ full name

https://gyazo.com/ccbe8881bd7bbc3614683702d62dd62a

SELECT FirstName + ' ' + LastName AS 'FullName ' , COUNT(Video.Id) AS CountVideo
FROM Video 
INNER JOIN Channel
ON Video.ChannelId = Channel.Id
INNER JOIN Users
ON Users.Id = Channel.UserId
WHERE users.IsDeleted = 0 
GROUP BY FirstName , LastName
ORDER BY CountVideo DESC

11 Calculate count of likes for every video in the system

https://gyazo.com/3bd288a97379b98d829346ae198e1fdd

Notes: [dbo].[Rating] is 1 means ‘like’
[dbo].[Rating] is 2 means ‘dislike’
We can not use Likes and Dislikes columns in [Video] table in this ticket for calculation
SELECT Video.Title , SUM(CASE WHEN Rating = 1 THEN Rating ELSE '0'  END) AS Likes

FROM Video
FULL OUTER JOIN Rating
ON Rating.VideoId = Video.Id
GROUP BY Title ,  Rating
ORDER BY Likes DESC

12 Calculate count of dislikes for every video in the system

https://gyazo.com/ae85bb13a92fd19836937fc342a8136f

Notes: [dbo].[Rating] is 1 means ‘like’
[dbo].[Rating] is 2 means ‘dislike’

We can not use Likes and Dislikes columns in [Video] table in this ticket for calculation
SELECT Video.Title , SUM(CASE WHEN Rating = 2 THEN Rating ELSE '0'  END) AS Dislikes

FROM Video
FULL OUTER JOIN Rating
ON Rating.VideoId = Video.Id
GROUP BY Title ,  Rating
ORDER BY Dislikes DESC

13 Show users who have exactly one channel (no more, no less)
https://gyazo.com/c3fdb30315e26961c4891f2d1d262e38

SELECT FirstName + ' ' + LastName  AS FullName 
FROM Users
INNER JOIN Channel
ON Users.Id = Channel.UserId
GROUP BY FirstName, LastName
HAVING COUNT(*) = 1

14 Calculate length of every comment in the system
https://gyazo.com/4c39a3332dfa04995f502cf4c7d390e8

SELECT Comment.Text , LEN(Comment.Text) AS SC
FROM Comment
ORDER BY Comment.Text DESC

15 Show only those comments which length is shorter than 35 symbols, 
show users and videos which they belong to and order them from longer to shorter

https://gyazo.com/d2be62f6fd5bfb4ef21b42fc3bc44be2

SELECT Comment.Text , FirstName + ' ' + LastName AS 'FullName', Video.Title , LEN(Comment.Text) AS SC
FROM Comment
INNER JOIN Users
ON Users.Id = Comment.UserId
INNER JOIN Video
ON Video.Id = Comment.VideoId
WHERE LEN(Text) < 35
GROUP BY Comment.Text , FirstName , LastName, Title

16 For every row from Task #15 show how many likes every video has (query from Task #11)

https://gyazo.com/42aa32b81a4203b2bd3af3dfc6dc0899

SELECT Comment.Text , FirstName + ' ' + LastName AS 'FullName', Video.Title , LEN(Comment.Text) AS SC , SUM(CASE WHEN Rating = 1 THEN Rating ELSE '0'  END) AS Likes
FROM Comment
INNER JOIN Users
ON Users.Id = Comment.UserId
INNER JOIN Video
ON Video.Id = Comment.VideoId
FULL OUTER JOIN Rating
ON Rating.VideoId = Video.Id
WHERE LEN(Text) < 35 
GROUP BY Comment.Text , FirstName , LastName, Title
ORDER BY Likes DESC

17 For query from Task #13, add the name of the channel to the results
https://gyazo.com/e63cde99fd829f8811982e0a375cab7f
SELECT FirstName + ' ' + LastName  AS FullName , Channel.Title
FROM Users
INNER JOIN Channel
ON Users.Id = Channel.UserId
GROUP BY FirstName, LastName, Title
HAVING COUNT(*) = 1

18 Show User Names, Video Titles and Channel Titles in the same query like on the screenshot.
Also order the items by their ids

https://gyazo.com/a49b04b353c01794d83b121a3ebac3b9

SELECT Users.Id , 
	FirstName AS Name , 
	'Users' AS Type
FROM Users

UNION ALL

SELECT Video.Id,
	Video.Title,
	'Video' AS Type
FROM Video

UNION ALL

SELECT Channel.Id,
	Channel.Title,
		'Titel'
FROM Channel

ORDER BY Users.Id ASC
