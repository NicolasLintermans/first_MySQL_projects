# 4) MySQL challenges

# Challenge 1: reward retention --> so: find oldest 5 user profiles

SELECT *
FROM users
ORDER BY created_at    # ASC (in datetime) by default
LIMIT 5;


# Challenge 2: schedule ad campaign --> so: on what days of the week do most users register on? (~ user activeness)

SELECT 
    DAYNAME(created_at) AS day,
    COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC;


# Challenge 3: target inactive users with email campaign --> so: find uses that have never posted a photo

SELECT username
FROM users
LEFT JOIN photos
    ON users.id = photos.user_id
WHERE photos.id IS NULL;


# Challenge 4: reward user that has the most likes on a single photo --> so: find the user that has the photo with the most likes 

SELECT 
    username,
    photos.id,
    photos.image_url, 
    COUNT(*) AS total
FROM photos
INNER JOIN likes
    ON likes.photo_id = photos.id
INNER JOIN users
    ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 1;


# Challenge 5: How widely adopted is our app? --> so: what's the average number of photos per user?

SELECT 
    (SELECT Count(*) FROM photos) / 
    (SELECT Count(*) FROM users) 
    AS avg; 


# Challenge 6: a marketing brand wants to know which hashtags to use in a post to get the most exposure --> so: what are the top 5 most commonly used hashtags?

SELECT tags.tag_name, 
       COUNT(*) AS total 
FROM   photo_tags 
       JOIN tags 
         ON photo_tags.tag_id = tags.id 
GROUP BY tags.id 
ORDER BY total DESC 
LIMIT 5; 


# Challenge 7: get rid of bots --> so: find all the users that have liked every single photo on the website

SELECT username, 
       COUNT(*) AS num_likes 
FROM users 
     INNER JOIN likes 
             ON users.id = likes.user_id 
GROUP BY likes.user_id 
HAVING num_likes = (SELECT Count(*)    # need to use 'HAVING' instead of 'WHERE' because it comes after the 'GROUP BY' statement
                    FROM photos); 
