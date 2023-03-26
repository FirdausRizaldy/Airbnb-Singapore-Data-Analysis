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


#total penyewaan dari tahun 2018-2022
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

#berapa banyak jumlah listing yang ada?
select count(id) as total_listings
from listings 

#bagaimana total listing per region?
SELECT n.neighbourhood_group, count(l.id) as total_listings
FROM nieghbourhood n join listings l 
ON n.neighbourhood = l.neighbourhood 
group by n.neighbourhood_group 
order by total_listings desc

#bagaimana total listing per neighbourhood?
SELECT l.neighbourhood,n.neighbourhood_group, count(l.id) as total_listings
FROM nieghbourhood n join listings l 
ON n.neighbourhood = l.neighbourhood 
group by n.neighbourhood
order by total_listings desc

#total listing per room type
select room_type, count(id) as total_listings, concat(round((count(id)/4160*100),2),'%') AS percentage
from listings 
group by room_type 

#sebaran listing dari maps
SELECT l.name ,l.latitude , l.longitude , l.price ,l.neighbourhood , n.neighbourhood_group 
FROM listings l JOIN nieghbourhood n 
on l.neighbourhood = n.neighbourhood 

#jumlah reviews(penyewaan) per region
SELECT  n.neighbourhood_group , count(listing_id) as total_reviews, 
concat(round((count(listing_id)/49695*100),2),'%') AS percentage
FROM listings l JOIN reviews r
ON l.id = r.listing_id 
join nieghbourhood n 
on l.neighbourhood = n.neighbourhood
group by n.neighbourhood_group  
order by total_reviews desc 

#jumlah reviews(penyewaan) per neighbourhood
SELECT  l.neighbourhood , n.neighbourhood_group , count(listing_id) as total_reviews, 
concat(round((count(listing_id)/49695*100),2),'%') AS percentage
FROM listings l JOIN reviews r
ON l.id = r.listing_id 
join nieghbourhood n 
on l.neighbourhood = n.neighbourhood
group by n.neighbourhood
order by total_reviews desc 

#Apakah room_type berpengaruh pada ramai atau tidaknya (number of reviews)suatu listing?
SELECT l.room_type, count(listing_id) as total_reviews, concat(round((count(listing_id)/49695*100),2),'%') AS percentage
FROM listings l JOIN reviews r
ON l.id = r.listing_id 
group by l.room_type 

#id dan name listing apa yang mempunyai number of reviews paling banyak?
SELECT l.id, l.name, l.neighbourhood, n.neighbourhood_group , count(listing_id) as total_reviews
FROM listings l JOIN reviews r
ON l.id = r.listing_id 
join nieghbourhood n 
on l.neighbourhood = n.neighbourhood
group by l.id 
order by total_reviews desc 
limit 5 

#host_id dan host_name apa yang mempunyai jumlah listing terbanyak?
SELECT l.host_id, l.host_name,n.neighbourhood_group, count(host_id) as host_listing 
FROM listings l JOIN nieghbourhood n 
on l.neighbourhood = n.neighbourhood 
group by l.host_id 
order by host_listing desc 
limit 5

#Berapa rata-rata dan median harga listings secara keseluruhan ?
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
 
#Bagaimana rata-rata harga listings per region?
SELECT n.neighbourhood_group, avg(l.price) as AVG_price
FROM nieghbourhood n join listings l 
ON n.neighbourhood = l.neighbourhood 
group by n.neighbourhood_group 
order by AVG_price 

#Bagaimana rata-rata harga listings per neighbourhood?
SELECT l.neighbourhood, n.neighbourhood_group , avg(l.price) as AVG_price
FROM listings l  join nieghbourhood n 
ON l.neighbourhood = n.neighbourhood 
group by l.neighbourhood  

#Bagaimana rata-rata harga listings per room type?
select room_type ,avg(price) as AVG_price
from listings
group by room_type 

