-- Database link: https://drive.google.com/drive/folders/1oqUevWNVAPmM-od6mXwfsJrSIb3pFT97

-- What is the cumulative sales volume (in units) for the first 7 days between 10- 10 -2016 and 16-10-2016?

with cummilative_sales as 
(
	select date(sales_transaction_date) as date, count(product_id) as unit_sold
	from sales
	where product_id = 7 and sales_transaction_date between '2016-10-10' and '2016-10-17'
	group by date(sales_transaction_date)
	order by date(sales_transaction_date) asc
)
	select date, unit_sold,
	sum(unit_sold) over(order by date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as cummilative_sales_7D
	from cummilative_sales;
    


-- On 20th Oct, What are the last 7 days' Cumulative Sales of Sprint Scooter (in units)?

with cummilative_sales as 
(
	select date(sales_transaction_date) as date, count(product_id) as unit_sold
	from sales
	where product_id = 7 and sales_transaction_date between '2016-10-10' and '2016-10-21'
	group by date(sales_transaction_date)
	order by date(sales_transaction_date) asc
)
	select date, unit_sold,
	sum(unit_sold) over(order by date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as cummilative_sales_7D
	from cummilative_sales;



-- On which date did the sales volume reach its highest point?

with cummilative_sales as 
(
	select date(sales_transaction_date) as date, count(product_id) as unit_sold
	from sales
	where product_id = 7
	group by date(sales_transaction_date)
	order by date(sales_transaction_date) asc
)

	select date, unit_sold,
	sum(unit_sold) over(order by date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as cummilative_sales_7D
	from cummilative_sales;


-- Calculate the cumulative sales volume over a rolling 7-day period

with cummilative_sales as 
(
	select date(sales_transaction_date) as date, count(product_id) as unit_sold
	from sales
	where product_id = 7
	group by date(sales_transaction_date)
	order by date(sales_transaction_date) asc
), 
cummilative_sales_prev as
(
	select date, unit_sold,
	sum(unit_sold) over(order by date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as cummilative_sales_7D
	from cummilative_sales
)
	select date, unit_sold, cummilative_sales_7D,
	round((((cummilative_sales_7D - lag(cummilative_sales_7D) over(order by date)) / lag(cummilative_sales_7D) over(order by date))*100),2) as growth
	from cummilative_sales_prev;


-- Calculate cummilative sales for Sprint LE 7

with cummilative_sales as 
(
	select date(sales_transaction_date) as date, count(product_id) as unit_sold
	from sales
	where product_id = 8
	group by date(sales_transaction_date)
	order by date(sales_transaction_date) asc
), 
cummilative_sales_prev as
(
	select date, unit_sold,
	sum(unit_sold) over(order by date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as cummilative_sales_7D
	from cummilative_sales
)
	select date, unit_sold, cummilative_sales_7D,
	round((((cummilative_sales_7D - lag(cummilative_sales_7D) over(order by date)) / lag(cummilative_sales_7D) over(order by date))*100),2) as growth
	from cummilative_sales_prev;




select * from emails;

select count(email_subject_id) from emails
where email_subject_id = 7;


select count(bounced) from emails
where email_subject_id = 7 and bounced = 't';

select count(bounced) from emails
where email_subject_id = 7 and opened = 't';


select * from sales
where product_id = 7
order by sales_transaction_date asc;

select * from emails;

select email_subject_id, bounced, clicked, count(sent_date) as mail_sent
from emails
where email_subject_id = 7 and sent_date between '2016-08-01' and '2016-10-10'
group by email_subject_id, bounced, clicked;


with cte as (
select email_subject_id, bounced, clicked, 
count(sent_date) over() as mail_sent
from emails
where email_subject_id = 7 and sent_date between '2016-08-01' and '2016-10-10'
 


select count(distinct(customer_id)) as mail_sent
from emails
where email_subject_id = 7 and sent_date between '2016-08-01' and '2016-10-10';
 

select count(bounced) as mail_bounced
from emails
where email_subject_id = 7 and sent_date between '2016-08-01' and '2016-10-10' and bounced = 't';
 

select count(clicked) as mail_clicked
from emails
where email_subject_id = 7 and sent_date between '2016-08-01' and '2016-10-10' and clicked = 't';
 
 
 select clicked_date
 from emails
 where email_subject_id = 7 and sent_date between '2016-08-01' and '2016-10-10';
 
 
  
-- Calculate number of mail sent, clicked, opened and bounced

select 
	es.email_subject_id,
	es.email_subject,
    COUNT(ec.customer_id) AS mail_sent,
    COUNT(CASE WHEN ec.opened_date is not null THEN ec.customer_id END) as mail_opened,
	COUNT(CASE WHEN ec.clicked = 't' THEN ec.customer_id END) AS mail_clicked,
	COUNT(CASE WHEN ec.bounced = 't' THEN ec.customer_id END) AS bounced
	FROM email_subject as es
	JOIN emails as ec ON es.email_subject_id = ec.email_subject_id
	where es.email_subject_id = 7 and ec.sent_date between '2016-08-01' and '2016-10-10';



-- Calculate Click Rate and Open Rate

with mails as(
select 
	es.email_subject_id,
	es.email_subject,
    COUNT(ec.customer_id) AS mail_sent,
    COUNT(CASE WHEN ec.opened_date is not null THEN ec.customer_id END) as mail_opened,
	COUNT(CASE WHEN ec.clicked = 't' THEN ec.customer_id END) AS mail_clicked,
	COUNT(CASE WHEN ec.bounced = 't' THEN ec.customer_id END) AS bounced
	FROM email_subject as es
	JOIN emails as ec ON es.email_subject_id = ec.email_subject_id
	where es.email_subject_id = 7 and ec.sent_date between '2016-08-01' and '2016-10-10'
)
select ((mail_clicked)/(mail_sent - bounced) * 100) as click_rate, 
	   ((mail_opened)/(mail_sent - bounced) * 100) as open_rate
from mails;

