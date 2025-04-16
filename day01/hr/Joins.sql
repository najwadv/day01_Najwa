select
c.country_id,country_name,
location_id,street_address,city,state_province
from countries c
full outer join locations l on c.country_id=l.country_id

select 
c.country_id,country_name,
location_id,street_address,city,state_province
from countries c
right join locations l on c.country_id=l.country_id

select 
c.country_id,country_name,
location_id,street_address,city,state_province
from countries c
left join locations l on c.country_id=l.country_id

select 
c.region_id,region_name,c.country_id,country_name
location_id,street_address,city,state_province
from regions r
join countries c on r.region_id = c.region_id
join locations l on c.country_id=l.country_id

select 
c.region_id,region_name,country_id,country_name
from regions r join countries c
on r.region_id = c.region_id
order by r.region_name, c.country_id