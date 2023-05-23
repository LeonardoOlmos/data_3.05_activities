-- Leonardo Olmos Saucedo / Activity 3.05

-- 1. Find out the average number of transactions by account. Get those accounts that have more transactions than the average.
select T.ACCOUNT_ID, COUNT(T.TRANS_ID) as TOTAL_TRANSACTIONS
from TRANS T 
group by T.ACCOUNT_ID 
having COUNT(T.TRANS_ID) > (
	select avg(s1.TOTAL_TRANSACTIONS) as avg_transactions
	from (
		select account_id, count(T.trans_id) as TOTAL_TRANSACTIONS 
		from TRANS T 
		group by ACCOUNT_ID) as s1)
order by 1;

-- 2. Get a list of accounts from Central Bohemia using a subquery.
select *
from ACCOUNT A 
where A.DISTRICT_ID IN (
	select D.A1 as DISTRICT_ID 
	from DISTRICT D 
	where LOWER(D.A3) = 'central bohemia')
order by 1;


-- 3. Rewrite the previous as a join query.
select A.*
from ACCOUNT A 
join DISTRICT D 
on A.DISTRICT_ID = D.A1 
where LOWER(D.A3) = 'central bohemia'
order by 1;

-- 4. Discuss which method will be more efficient.
explain 
select *
from ACCOUNT A 
where A.DISTRICT_ID IN (
	select D.A1 as DISTRICT_ID 
	from DISTRICT D 
	where LOWER(D.A3) = 'central bohemia')
order by 1;

explain
select A.*
from ACCOUNT A 
join DISTRICT D 
on A.DISTRICT_ID = D.A1 
where LOWER(D.A3) = 'central bohemia'
order by 1;

-- 5. Find the most active customer for each district in Central Bohemia.
select s1.ACCOUNT_ID, s1.TOTAL_TRANSACTIONS, s1.DISTRICT_ID, D.A3 as DISTRICT_REGION
from 
	(select T.ACCOUNT_ID, COUNT(T.TRANS_ID) as TOTAL_TRANSACTIONS, A.DISTRICT_ID, RANK() over (partition by A.DISTRICT_ID order by COUNT(T.TRANS_ID) desc) as `RANK`
	from TRANS T 
	join ACCOUNT A 
	on T.ACCOUNT_ID = A.ACCOUNT_ID 
	group by T.ACCOUNT_ID, A.DISTRICT_ID) as s1
join DISTRICT D 
on s1.DISTRICT_ID = D.A1
where `RANK`= 1
and LOWER(D.A3) = 'central bohemia'
order by 3;