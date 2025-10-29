CREATE DATABASE International_Hotel_Bookings;
USE International_Hotel_Bookings;

-- creating table for all hotels
CREATE TABLE INT_Hotels (
hotel_id INTEGER AUTO_INCREMENT PRIMARY KEY,
hotel_name VARCHAR(50),
city TEXT,
country TEXT,
star_rating INTEGER,
latitude FLOAT,
longitude FLOAT,
cleanliness_base FLOAT,
comfort_base FLOAT,
facilities_base FLOAT,
location_base FLOAT,
staff_base FLOAT,
value_for_money_base FLOAT);

-- creating table for all hotel reviews by customers
CREATE TABLE reviews (
review_id INTEGER PRIMARY KEY,
user_id INTEGER,
hotel_id INTEGER, 
review_date DATE,
score_overall FLOAT,
score_cleanliness FLOAT,
score_comfort FLOAT,
score_facilities FLOAT,
score_location FLOAT,
score_staff FLOAT,
score_value_for_money_base FLOAT,
review_text TEXT);

-- creating table for hotel users (NB: Automatically created by database while importing)
CREATE TABLE users (
user_id INTEGER PRIMARY KEY,
user_gender TEXT, 
country VARCHAR(50),
age_group VARCHAR(10),
traveller_type TEXT,
join_date DATE
);

-- Q1. selecting all information recorded on 5 star hotels
SELECT * 
FROM INT_Hotels AS ih
INNER JOIN reviews AS r
ON ih.hotel_id = r.review_id
INNER JOIN users AS u
ON r.review_id = u.user_id
WHERE ih.star_rating = 5;
 
 -- Q2. Count number of hotels by country
SELECT country, COUNT(country) AS total_hotels
FROM INT_Hotels
GROUP BY country
ORDER BY total_hotels DESC;

-- Q3. Top 10 hotels with cleanliness score greater than Avg cleankiness score
SELECT ih.hotel_name, ROUND(AVG(r.score_cleanliness),2) AS avg_cleanliness
FROM INT_Hotels AS ih
JOIN reviews AS r 
  ON ih.hotel_id = r.hotel_id
GROUP BY ih.hotel_name
HAVING AVG(r.score_cleanliness) > (
    SELECT AVG(score_cleanliness) 
    FROM reviews
)
ORDER BY avg_cleanliness DESC
LIMIT 10;

-- Q4. Average overall review score per hotel
SELECT ih.hotel_name, ROUND(AVG(r.score_overall),2) AS avg_overall_score
FROM INT_Hotels AS ih
JOIN reviews AS r 
ON ih.hotel_id = r.hotel_id
GROUP BY ih.hotel_name
ORDER BY avg_overall_score DESC;

-- Q5. Gender distribution of users
SELECT user_gender, COUNT(*) AS total_users
FROM users
GROUP BY user_gender;

-- Q6. Average review score by traveler type
SELECT u.traveller_type, AVG(r.score_overall) AS avg_score
FROM users AS u
JOIN reviews AS r 
ON u.user_id = r.user_id
GROUP BY u.traveller_type
ORDER BY avg_score DESC;

-- Q7. Total number of travelled times by traveller type per reviews
SELECT u.traveller_type, COUNT(ih.country) AS count_countries
FROM users AS u
JOIN reviews AS r 
ON u.user_id = r.user_id
JOIN INT_Hotels AS ih 
ON r.hotel_id = ih.hotel_id
GROUP BY u.traveller_type;

-- Q8. Total countries visited by traveler type 
SELECT u.traveller_type, COUNT(ih.country) AS count_countries 
FROM INT_Hotels AS ih 
JOIN users AS u 
ON ih.hotel_id = u.user_id 
GROUP BY u.traveller_type;

-- Q9. Most reviewed hotels
SELECT ih.hotel_name, COUNT(r.review_id) AS total_reviews
FROM INT_Hotels AS ih
JOIN reviews r 
ON ih.hotel_id = r.hotel_id
GROUP BY ih.hotel_name
ORDER BY total_reviews DESC
LIMIT 5;

-- Q10. Top 5 Hotels with highest staff ratings
SELECT ih.hotel_name, ROUND(AVG(r.score_staff),2) AS avg_staff
FROM INT_Hotels AS ih
JOIN reviews AS r 
ON ih.hotel_id = r.hotel_id
GROUP BY ih.hotel_name
ORDER BY avg_staff DESC
LIMIT 5;

-- Q11. Average score by country of user
SELECT u.country, ROUND(AVG(r.score_overall),2) AS avg_score
FROM users AS u
JOIN reviews AS r 
ON u.user_id = r.user_id
GROUP BY u.country
ORDER BY avg_score DESC;

-- Q12. Average hotel rating by age group
SELECT u.age_group, ROUND(AVG(r.score_overall),2) AS avg_score
FROM users AS u
JOIN reviews AS r 
ON u.user_id = r.user_id
GROUP BY u.age_group
ORDER BY u.age_group;

-- Q13. Traveller type per age group per country visited and hotel lodged
SELECT u.traveller_type, u.age_group, ih.hotel_name, ih.country 
FROM INT_Hotels AS ih 
JOIN users AS u 
ON ih.hotel_id = u.user_id 
GROUP BY u.traveller_type, u.age_group, ih.hotel_name, ih.country 
ORDER BY u.age_group;

-- Q14. Hotels with best value-for-money scores
SELECT ih.hotel_name, ROUND(AVG(r.score_value_for_money_base),2) AS avg_value
FROM INT_Hotels AS ih
JOIN reviews AS r 
ON ih.hotel_id = r.hotel_id
GROUP BY ih.hotel_name
ORDER BY avg_value DESC
LIMIT 5;

-- Q15. Top countries of users by review count
SELECT u.country, COUNT(r.review_id) AS total_reviews
FROM users AS u
JOIN reviews AS r 
ON u.user_id = r.user_id
GROUP BY u.country
ORDER BY total_reviews DESC
LIMIT 5;

-- 16. Average location score by city
SELECT ih.city, ROUND(AVG(r.score_location),2) AS avg_location
FROM INT_Hotels AS ih
JOIN reviews AS r 
ON ih.hotel_id = r.hotel_id
GROUP BY ih.city
ORDER BY avg_location DESC;

-- 17. Most active users by number of reviews written
SELECT u.user_id, u.country, COUNT(r.review_id) AS reviews_written
FROM users AS u
JOIN reviews AS r 
ON u.user_id = r.user_id
GROUP BY u.user_id, u.country
ORDER BY reviews_written DESC
LIMIT 10;

-- 19. Average scores for each category per hotel
SELECT ih.hotel_name, ih.city, AVG(r.score_cleanliness) AS cleanliness,
AVG(r.score_comfort) AS comfort,
AVG(r.score_facilities) AS facilities, 
AVG(r.score_staff) AS staff 
FROM INT_Hotels AS ih
JOIN reviews AS r 
ON ih.hotel_id = r.hotel_id
GROUP BY ih.hotel_name, ih.city
LIMIT 5;