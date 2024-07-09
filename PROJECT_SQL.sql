select * from invoice

--who is the senior most based on the job title?
select first_name,last_name,levels from employee order by levels desc limit 1 

-- which country have most invoices?
select billing_country, count(*) as c from invoice group by billing_country
 order by c desc

--what are the top 3 values of total voices?
select total, billing_address from invoice order by total desc limit 3

--which city has the best customers ? we would like to throw a promotional music 
--festival in the city we made the most money. write a query that returns one city 
--that are highest sum of invoice totals. return both the city name and sum of all invoice total

select * from invoice

select billing_city, sum(total) as total_amount 
from invoice 
group by billing_city
order by total_amount
desc limit 1

---who is the best customer. thecustomer who spent the most money will be declared the best customer.
--write a query that returns the person who has spent most money.


select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

--moderate
--write a query to return email, first_name, last_name & genre of all rock music listeners.
-- return your list ordered alphabetically by email starting with A.

select distinct email, first_name, last_name
from customer
join  invoice on customer.customer_id=invoice.customer_id
join  invoice_line on invoice.invoice_id=invoice_line.invoice_id 
where track_id in(
	select track_id from track
	join genre on track.genre_id=genre.genre_id
	where genre.name Ilike 'rock'
)
order by email;

--lets invite the artists who have written the most rock music in our dataset. write a query
--that returns the artist name and total track count of top 10 rock bands

select artist.name ,artist.artist_id ,count(track.track_id) as number_of_songs
from artist
join album on artist.artist_id=album.artist_id
join track on album.album_id=track.album_id
join genre on track.genre_id=genre.genre_id
where genre.name Ilike '%ROCK%'
group by artist.name, artist.artist_id
order by number_of_songs desc
LIMIT 10


--RETURN ALL THE TRACK NAMES THAT HAVE A SONG LENGTH LONGER THAN THE AVERAGE SONG LENGTH.
--RETURN THE NAME AND MILLISECONDS FOR EACH TRACK. ORDER BY THE SONG LENGTH WITH THE LONGEST 
--SONGS LISTED FIRST.


WITH CTE AS (SELECT AVG(TRACK.MILLISECONDS) AS AVG_DURATION FROM TRACK)
SELECT TRACK.NAME, TRACK.MILLISECONDS FROM TRACK, CTE
WHERE TRACK.MILLISECONDS> CTE.AVG_DURATION
ORDER BY TRACK.MILLISECONDS DESC
 

--advance
--find out how much amount spent by each customer on artists? write a query to return customer name, 
--artist name and total spent.

select ar.artist_id, ar.name, sum(il.unit_price*il.quantity) as amountspent
from customer cu, invoice inv, invoice_line il , track tr,album al, artist ar
where cu.customer_id =inv.customer_id and inv.invoice_id=il.invoice_id and il.track_id=tr.track_id
and tr.album_id=al.album_id and al.artist_id=ar.artist_id
group by ar.artist_id
order by 3 desc
LIMIT 1

-- WE WANT TO FIND OUT THE MOST POPULAR MUSIC GENRE FOR EACH COUNTRY . WE DETERMINE THE MOST POPULAR GENRE
--AS THE GENRE WITH THE HIGHEST AMOUNT OF PURCHASES. WRITE A QUERY THAT RETURNS EACH COUNTRY ALONG WITH 
-- THE TOP GENRE .FOR COUNTRIES WHERE THE MAXIMUM NUMBER OF PURCHASES IS SHARED RETURN ALL GENRE.

WITH POPULAR_GENRE AS
(
	SELECT COUNT(INVOICE_LINE.QUANTITY) AS PURCHASES, CUSTOMER.COUNTRY, GENRE.NAME,GENRE.GENRE_ID,
	ROW_NUMBER() OVER(PARTITION BY CUSTOMER.COUNTRY ORDER BY COUNT(INVOICE_LINE.QUANTITY) DESC) AS ROWNO
	FROM INVOICE_LINE
	JOIN INVOICE ON INVOICE.INVOICE_ID=INVOICE_LINE.INVOICE_ID
	JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID=INVOICE.CUSTOMER_ID
	JOIN TRACK ON TRACK.TRACK_ID=INVOICE_LINE.TRACK_ID
	JOIN GENRE ON GENRE.GENRE_ID=TRACK.GENRE_ID
	GROUP BY 2,3,4
	ORDER BY 2 ASC,1 DESC
)
SELECT * FROM POPULAR_GENRE WHERE ROWNO <=1


'''WRITE A QUERY THAT DETERMINES THE CUSTOMERS THAT HAS SPENT THE MOST ON THE MUSIC FOR EACH COUNTRY. WRITE 
	A QUERY THAT RETURNS THE COUNTRY ALONG WITH THE TOP CUSTOMER AND HOW MUCH THEY SPENT. FOR COUNTRIES WHERE 
	THE TOP AMOUNT SPENT IS SHARED, PROVIDE ALL CUSTOMERS WHO SPENT THIS AMOUNT'''

WITH CUSTOMER_WITH_COUNTRY AS (
	SELECT CUSTOMER.CUSTOMER_ID, FIRST_NAME, LAST_NAME, BILLING_COUNTRY, SUM(TOTAL) AS TOTAL_SPENDING,
	ROW_NUMBER() OVER (PARTITION BY BILLING_COUNTRY ORDER BY SUM(TOTAL) DESC) AS ROWNO
	FROM INVOICE
	JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID=INVOICE.CUSTOMER_ID
	GROUP BY 1,2,3,4
	ORDER BY 4 ASC,5 DESC)
SELECT * FROM CUSTOMER_WITH_COUNTRY WHERE ROWNO <=1







