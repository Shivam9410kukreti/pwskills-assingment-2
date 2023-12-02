  -- Retrieve the total number of rentals made in the Sakila database --
   Select Count(*) as total_rentals from rental;
   
   -- Find the average rental duration (in days) of movies rented from the Sakila database--
   Select avg(datediff(return_date, rental_date)) as average_rental_duration from rental;
   
   -- Display the first name and last name of customers in uppercase --
   Select upper(first_name) as upper_first_name, upper(last_name) as upper_last_name from customer;
   
   -- Extract the month from the rental date and display it alongside the rental ID --
   Select rental_id, month(rental_date) as rental_month from rental;
   
   -- Retrieve the count of rentals for each customer (display customer ID and the count of rentals) -- 
   Select customer_id, count(rental_id) as rental_count from rental group by customer_id;

-- Find the total revenue generated by each store --
Select store.store_id, sum(amount) as total_revenue from store left join staff on store.store_id left join payment on staff.staff_id group by store.store_id;

-- Display the title of the movie, customer s first name, and last name who rented it. 
select
    film.title as MovieTitle,
    customer.first_name as CustomerFirstName,
    customer.last_name as CustomerLastName
from 
    rental
join
    inventory on rental.inventory_id = inventory.inventory_id
join
    film on inventory.film_id = film.film_id
join 
    customer on rental.customer_id = customer.customer_id;

-- Retrieve the names of all actors who have appeared in the film "Gone with the Wind." 
select
    actor.first_name as ActorFirstName,
    actor.last_name as ActorLastName
from 
    film_actor
join 
    film on film_actor.film_id = film.film_id
join 
    actor on film_actor.actor_id = actor.actor_id
where
    film.title = 'Gone with the Wind';

-- Determine the total number of rentals for each category of movies. 
select
    film_category.category_id,
    Count(*) as RentalCount
from 
    rental
join
    inventory on rental.inventory_id = inventory.inventory_id
join
    film on inventory.film_id = film.film_id
join
    film_category on film.film_id = film_category.film_id
group by 
    film_category.category_id;
    
    -- Find the average rental rate of movies in each language. 
select
    language.name as LanguageName,
    avg(film.rental_rate) as AverageRentalRate
from 
    film
join
    language on film.language_id = language.language_id
group by
    language.name;
    
    -- Retrieve the customer names along with the total amount they've spent on rentals.
    select
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    sum(payment.amount) as TotalAmountSpent
from 
    customer
join
    payment on customer.customer_id = payment.customer_id
group by 
    customer.customer_id, customer.first_name, customer.last_name;
    
    -- List the titles of movies rented by each customer in a particular city (e.g., 'London'). 
Select
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    film.title as MovieTitle
from
    customer
join 
    address on customer.address_id = address.address_id
join
    city on address.city_id = city.city_id
join
    rental on customer.customer_id = rental.customer_id
join
    inventory on rental.inventory_id = inventory.inventory_id
join
    film on inventory.film_id = film.film_id
where
    city.city = 'London'
order by 
    customer.customer_id, film.title;

-- Display the top 5 rented movies along with the number of times they've been rented. 
Select
    film.title as MovieTitle,
    count(rental.rental_id) as RentalCount
from 
    film
join
    inventory on film.film_id = inventory.film_id
join
    rental on inventory.inventory_id = rental.inventory_id
group by 
    film.title
order by
    RentalCount desc
limit 5;

-- Determine the customers who have rented movies from both stores (store ID 1 and store ID 2). 
Select 
    customer.customer_id,
    customer.first_name,
    customer.last_name
from 
    customer
join
    rental on customer.customer_id = rental.customer_id
join
    inventory on rental.inventory_id = inventory.inventory_id
join
    store on inventory.store_id = store.store_id
where
    store.store_id in (1, 2)
group by 
    customer.customer_id, customer.first_name, customer.last_name
having
    COUNT(distinct store.store_id) = 2;