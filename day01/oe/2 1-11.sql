/*--2 (1)*/

select
c.category_id,category_name,
count(1) as total_product
from categories c
join products p on c.category_id = p.category_id
group by c.category_id,c.category_name
order by category_name

/*--2 (2)*/

select
s.supplier_id,company_name,
count(1) as total_product
from suppliers s
join products p on s.supplier_id = p.supplier_id
group by s.supplier_id,s.company_name
order by total_product desc

/*--2 (3)*/

select
s.supplier_id,company_name,
count(1) as total_product,
to_char(avg(p.unit_price), '99.99') as avg_unit_price
from suppliers s
join products p on s.supplier_id = p.supplier_id
group by s.supplier_id,s.company_name
order by total_product desc

/*--2 (4)*/
select p.product_id, product_name, s.supplier_id, s.company_name, 
unit_price, units_in_stock, units_on_order, reorder_level
from products p
join suppliers s on p.supplier_id = s.supplier_id
where p.units_in_stock <= p.reorder_level
/*reorder level sebagai marker dan harus 
lebih besar dari unit in stock*/
order by product_name asc;

/*--2 (5)*/
select
t.customer_id,t.company_name,
count(1) as total_order
from customers t
join orders o on o.customer_id = t.customer_id
group by t.customer_id,t.company_name
order by company_name

/*--2 (6)*/
select o.order_id,o.customer_id,o.order_date,
o.required_date,o.shipped_date,
shipped_date - order_date as delivery_time
from orders o
where shipped_date - order_date > 10

/*--2 (7)*/
select p.product_id,p.product_name,
sum(od.quantity) as total_qty
from products p
join order_details od on p.product_id = od.product_id
join orders o on o.order_id = od.order_id
where o.shipped_date is not null
group by p.product_id,p.product_name
order by total_qty desc

/*--2 (8)*/
select c.category_id,c.category_name,
sum(od.quantity) as total_qty_ordered
from categories c
join products p on c.category_id = p.category_id
join order_details od on p.product_id = od.product_id
group by c.category_id,c.category_name
order by total_qty_ordered desc

/*--2 (9)*/
with min_max as (
select c.category_id,c.category_name,
sum(od.quantity) as total_qty_ordered
from categories c
join products p on c.category_id = p.category_id
join order_details od on p.product_id = od.product_id
group by c.category_id,c.category_name
order by total_qty_ordered desc
)
select * from min_max
where total_qty_ordered = (select max(total_qty_ordered)
						   from min_max)
union
select * from min_max
where total_qty_ordered = (select min(total_qty_ordered)
						   from min_max)

/*--2 (10)*/
select s.shipper_id, s.company_name, p.product_id, p.product_name, sum(od.quantity) AS total_qty_ordered
from shippers s
join orders o on s.shipper_id = o.ship_via
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
group by s.shipper_id, s.company_name, p.product_id, p.product_name
order by s.company_name, p.product_name;

/*--2 (11)*/
with cte3 as (
    select s.shipper_id, s.company_name, p.product_id, p.product_name, sum(od.quantity) as total_qty_ordered
    from shippers s
    join orders o on s.shipper_id = o.ship_via
    join order_details od on o.order_id = od.order_id
    join products p on od.product_id = p.product_id
    group by s.shipper_id, s.company_name, p.product_id, p.product_name
    order by s.company_name, p.product_name
),
min_max_per_shipper as (
    select
        shipper_id,
        min(total_qty_ordered) as min_qty,
        max(total_qty_ordered) as max_qty
    from cte3
    group by shipper_id
)
select c.shipper_id, c.company_name, c.product_id, c.product_name, c.total_qty_ordered
from cte3 c
join min_max_per_shipper m on c.shipper_id = m.shipper_id
where c.total_qty_ordered = m.min_qty or c.total_qty_ordered = m.max_qty
order by c.shipper_id asc, c.total_qty_ordered asc;