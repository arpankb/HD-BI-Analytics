Create database Hospitality_Digital

select * from Hospitality_Digital.dbo.[Restaurant Reservation]

select * from Hospitality_Digital.dbo.[Restaurant Master]

---Total No of Restaurants in Master

select count(restaurant_id) as total_no_of_restaurant 
from Hospitality_Digital.dbo.[Restaurant Master] 
where restaurant_type= 'restaurant';







--- No_of_Reserved_Restaurants in Master

select count(distinct R1.restaurant_id) as No_of_reserved_restaurant
from Hospitality_Digital.dbo.[Restaurant Master] as R1
inner join Hospitality_Digital.dbo.[Restaurant Reservation] as R2 
on R1.restaurant_id = R2.restaurant_id
where R1.restaurant_type= 'restaurant'



--- Percentage of Reserved_Restaurants out of total_restaurants in Master

with t1 as (select count(restaurant_id) as total_no_of_restaurant 
from Hospitality_Digital.dbo.[Restaurant Master] 
where restaurant_type= 'restaurant'),
 t2 as (select count(distinct R1.restaurant_id) as No_of_reserved_restaurant
from Hospitality_Digital.dbo.[Restaurant Master] as R1
inner join Hospitality_Digital.dbo.[Restaurant Reservation] as R2 
on R1.restaurant_id = R2.restaurant_id
where R1.restaurant_type= 'restaurant')
select cast (round(cast(No_of_reserved_restaurant as float) / cast(total_no_of_restaurant as float) * 100,2) as varchar) + '%'
from t1, t2



---Total No. Of Reservation made in Restaurants from Master-------

select count(R2.reservation_id) as Total_no_of_reservation
from Hospitality_Digital.dbo.[Restaurant Master] as R1
inner join Hospitality_Digital.dbo.[Restaurant Reservation] as R2 
on R1.restaurant_id = R2.restaurant_id
where R1.restaurant_type= 'restaurant'


---Development of reservations over time at Monthly level ------

select year(reservation_created_date) as year, month(reservation_created_date) as month, 
count(reservation_id) as current_month_reservation, 
LAG(count(reservation_id)) over (order by  year(reservation_created_date), 
month(reservation_created_date)) as previous_month_reservation,
count(reservation_id)- LAG(count(reservation_id)) over (order by  year(reservation_created_date), 
month(reservation_created_date)) as change
from Hospitality_Digital.dbo.[Restaurant Reservation]
group by year(reservation_created_date), month(reservation_created_date)




------(Year/Month) with Highest no_of_reservations -----

select top 1 year(reservation_created_date) as year, month(reservation_created_date) as month, 
count(reservation_id) as no_of_reservations
from Hospitality_Digital.dbo.[Restaurant Reservation]
group by year(reservation_created_date), month(reservation_created_date)
order by  count(reservation_id) desc



------(Year/Month) with Lowest no_of_reservations-----

select top 1 year(reservation_created_date) as year, month(reservation_created_date) as month, count(reservation_id) 
from Hospitality_Digital.dbo.[Restaurant Reservation]
where month(reservation_created_date) in (1,2,3)
group by year(reservation_created_date), month(reservation_created_date)
order by  count(reservation_id) 





---Average reservation per month--

with t1 as (select month(reservation_created_date) as month, count(reservation_id) as no_of_reservations
from Hospitality_Digital.dbo.[Restaurant Reservation]
group by year(reservation_created_date), month(reservation_created_date))
select month, avg(no_of_reservations) as monthly_avg
from t1 
group by month
order  by month
--------Third reservation per Restaurant-------

with t1 as (select *, 
ROW_NUMBER() over (partition by restaurant_id order by reservation_created_date, reservation_id) as rank
from Hospitality_Digital.dbo.[Restaurant Reservation])
select restaurant_id, reservation_id, reservation_created_date
from t1
where rank = 3




----------------------------
----------------------------
select year(reservation_created_date) as year, month(reservation_created_date) as month, count(reservation_id) 
from Hospitality_Digital.dbo.[Restaurant Reservation]
where year(reservation_created_date) = 2021 and month(reservation_created_date)= 1
group by year(reservation_created_date), month(reservation_created_date)
order by  count(reservation_id) 



