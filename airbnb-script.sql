#tabel listings
ALTER TABLE `listings`
  ADD PRIMARY KEY (`id`);
 
 ALTER TABLE `listings`
  drop column Column1;

 #tabel nieghbourhood
   ALTER TABLE nieghbourhood 
  ADD PRIMARY KEY (`neighbourhood`);

#add foreign key
#fk table listings
ALTER TABLE listings 
ADD CONSTRAINT fk_neighbourhood
FOREIGN KEY(neighbourhood) 
REFERENCES nieghbourhood(neighbourhood);

#fk table reviews
ALTER TABLE reviews  
ADD CONSTRAINT fk_listings
FOREIGN KEY(listing_id) 
REFERENCES listings(id);

#cleansing
select id, name, price, from listings WHERE price=0;
delete from listings WHERE price=0;


#total rents from 2018-2022
select count(listing_id) as total_reviews
from  reviews 
	#by date
SELECT count(listing_id) as total_listing, date
FROM reviews  
group by date
order by date
	#by year
SELECT count(listing_id) as total_listing, year(date)
FROM reviews  
group by year(date)
order by year(date)

#how many listings are there?
select count(id) as total_listings
from listings 

#what is the total listing per region?
SELECT n.neighbourhood_group, count(l.id) as total_listings
FROM nieghbourhood n join listings l 
ON n.neighbourhood = l.neighbourhood 
group by n.neighbourhood_group 
order by total_listings desc

#what is the total listings per neighborhood?
SELECT l.neighbourhood,n.neighbourhood_group, count(l.id) as total_listings
FROM nieghbourhood n join listings l 
ON n.neighbourhood = l.neighbourhood 
group by n.neighbourhood
order by total_listings desc

#total listing per room type
select room_type, count(id) as total_listings, concat(round((count(id)/4160*100),2),'%') AS percentage
from listings 
group by room_type 

#distribution of listings from maps
SELECT l.name ,l.latitude , l.longitude , l.price ,l.neighbourhood , n.neighbourhood_group 
FROM listings l JOIN nieghbourhood n 
on l.neighbourhood = n.neighbourhood 

#number of reviews (rentals) per region
SELECT  n.neighbourhood_group , count(listing_id) as total_reviews, 
concat(round((count(listing_id)/49695*100),2),'%') AS percentage
FROM listings l JOIN reviews r
ON l.id = r.listing_id 
join nieghbourhood n 
on l.neighbourhood = n.neighbourhood
group by n.neighbourhood_group  
order by total_reviews desc 

#number of reviews(rents) per neighborhood
SELECT  l.neighbourhood , n.neighbourhood_group , count(listing_id) as total_reviews, 
concat(round((count(listing_id)/49695*100),2),'%') AS percentage
FROM listings l JOIN reviews r
ON l.id = r.listing_id 
join nieghbourhood n 
on l.neighbourhood = n.neighbourhood
group by n.neighbourhood
order by total_reviews desc 

#Does room_type affect how busy or not (number of reviews) a listing is?
SELECT l.room_type, count(listing_id) as total_reviews, concat(round((count(listing_id)/49695*100),2),'%') AS percentage
FROM listings l JOIN reviews r
ON l.id = r.listing_id 
group by l.room_type 

#id and name listing which has the most number of reviews?
SELECT l.id, l.name, l.neighbourhood, n.neighbourhood_group , count(listing_id) as total_reviews
FROM listings l JOIN reviews r
ON l.id = r.listing_id 
join nieghbourhood n 
on l.neighbourhood = n.neighbourhood
group by l.id 
order by total_reviews desc 
limit 5 

#what host_id and host_name have the most number of listings?
SELECT l.host_id, l.host_name,n.neighbourhood_group, count(host_id) as host_listing 
FROM listings l JOIN nieghbourhood n 
on l.neighbourhood = n.neighbourhood 
group by l.host_id 
order by host_listing desc 
limit 5

#What is the average and median price of the listings overall?
	#mean
SELECT AVG(price) AS AveragePrice FROM listings ;

	#median
SET @row_index := -1; #create index

SELECT AVG(subq.price) as median_price
FROM (
	#show row index and price order by price ascending
    SELECT @row_index:=@row_index + 1 AS row_index, price
    FROM listings 
    ORDER BY price
  ) AS subq
  WHERE subq.row_index 
  IN (FLOOR(@row_index / 2) , CEIL(@row_index / 2));
 
#What is the average listing price per region?
SELECT n.neighbourhood_group, avg(l.price) as AVG_price
FROM nieghbourhood n join listings l 
ON n.neighbourhood = l.neighbourhood 
group by n.neighbourhood_group 
order by AVG_price 

#What is the average listing price per neighborhood?
SELECT l.neighbourhood, n.neighbourhood_group , avg(l.price) as AVG_price
FROM listings l  join nieghbourhood n 
ON l.neighbourhood = n.neighbourhood 
group by l.neighbourhood  

#What is the average listing price per room type?
select room_type ,avg(price) as AVG_price
from listings
group by room_type 

