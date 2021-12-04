# Lab | Making predictions with logistic regression

# In this lab, you will be using the [Sakila](https://dev.mysql.com/doc/sakila/en/) database of movie rentals.

# In order to optimize our inventory, we would like to know which films will be rented next month and we are asked to create a model to predict it.

### Instructions

#1. Create a query or queries to extract the information you think may be relevant for building the prediction model. It should include some film features and some rental features.
/*Old query*/
SELECT a.film_id, a.title, e.name AS category, a.release_year, a.language_id, a.rental_duration, a.rental_rate, a.replacement_cost, a.rating 
FROM sakila.film AS a LEFT JOIN sakila.inventory AS b ON a.film_id=b.film_id
JOIN sakila.rental AS c ON b.inventory_id = c.inventory_id
JOIN sakila.film_category AS d ON a.film_id=d.film_id
JOIN sakila.category AS e ON d.category_id=e.category_id
ORDER BY a.film_id;


SELECT c.rental_id, b.inventory_id, a.film_id, e.name AS category, a.release_year, a.language_id, a.rental_duration, a.rental_rate, a.replacement_cost, a.rating 
FROM sakila.film AS a LEFT JOIN sakila.inventory AS b ON a.film_id=b.film_id
JOIN sakila.rental AS c ON b.inventory_id = c.inventory_id
JOIN sakila.film_category AS d ON a.film_id=d.film_id
JOIN sakila.category AS e ON d.category_id=e.category_id
ORDER BY a.film_id;

#2. Read the data into a Pandas dataframe.
#3. Analyze extracted features and transform them. You may need to encode some categorical variables, or scale numerical variables.
#4. Create a query to get the list of films and a boolean indicating if it was rented last month. This would be our target variable.
SELECT a.film_id, c.rental_date FROM sakila.film AS a LEFT JOIN sakila.inventory AS b ON a.film_id=b.film_id
JOIN sakila.rental AS c ON b.inventory_id=c.inventory_id;

SELECT a.film_id, c.rental_date, YEAR(c.rental_date) AS rental_year, MONTH(c.rental_date) AS rental_month,
RANK() OVER(ORDER BY YEAR(c.rental_date) DESC, MONTH(c.rental_date) DESC) AS rank_months
FROM sakila.film AS a LEFT JOIN sakila.inventory AS b ON a.film_id=b.film_id
JOIN sakila.rental AS c ON b.inventory_id=c.inventory_id;

SELECT MONTH(rental_date) FROM sakila.rental
ORDER BY rental_date DESC
LIMIT 1;

SELECT YEAR(rental_date) FROM sakila.rental
ORDER BY rental_date DESC
LIMIT 1;

WITH cte1 AS (
SELECT a.film_id, c.rental_date, YEAR(c.rental_date) AS rental_year, MONTH(c.rental_date) AS rental_month,
RANK() OVER(ORDER BY YEAR(c.rental_date) DESC, MONTH(c.rental_date) DESC) AS rank_months
FROM sakila.film AS a LEFT JOIN sakila.inventory AS b ON a.film_id=b.film_id
JOIN sakila.rental AS c ON b.inventory_id=c.inventory_id
)
SELECT
IF (rank_months = 1,True,False) AS rented_last_month
FROM cte1
/*GROUP BY film_id*/
ORDER BY film_id;


#5. Create a logistic regression model to predict this variable from the cleaned data.
#6. Evaluate the results.