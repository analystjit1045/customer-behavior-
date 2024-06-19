CREATE TABLE marketing_campaign (
    ID INT PRIMARY KEY,
    Year_Birth INT,
    Education VARCHAR(50),
    Marital_Status VARCHAR(50),
    Income FLOAT,
    Kidhome INT,
    Teenhome INT,
    Dt_Customer DATE,
    Recency INT,
    MntWines INT,
    MntFruits INT,
    MntMeatProducts INT,
    MntFishProducts INT,
    MntSweetProducts INT,
    MntGoldProds INT,
    NumWebPurchases INT,
    NumCatalogPurchases INT,
    NumStorePurchases INT,
    NumWebVisitsMonth INT) ;
 SELECT * FROM  marketing_campaign ; 
COPY marketing_campaign (ID,year_birth,Education,Marital_Status,Income,Kidhome,Teenhome,Dt_Customer,Recency,MntWines,MntFruits,MntMeatProducts,
	MntFishProducts,MntSweetProducts,MntGoldProds,NumWebPurchases,NumCatalogPurchases,NumStorePurchases,NumWebVisitsMonth)
	from 'D:\Program Files\pgAdmin 4\marketing_campaign 5.csv'
     delimiter ','
     csv header ;
--DELETING NULL VALUES FROM THE TABLE --
DELETE FROM marketing_campaign
WHERE Income IS NULL; 

--1).Select customers with income greater than $50,000--
SELECT * from  marketing_campaign where Income > 50000;

--2) Calculate the average spending on wine--
SELECT AVG(MntWines) AS Avg_Wine_Spending from marketing_campaign; 

--3) Count the number of customers by education level--
SELECT Education,count(*) AS Num_Customers from  marketing_campaign group by Education; 

--4) Find the total spending of each customer with income greater than $50,000 ---
select id,income , sum(mntwines+mntfruits+mntmeatproducts+mntfishproducts+mntsweetproducts+mntgoldprods)
as total_spending from marketing_campaign where income>50000 group by id  order by total_spending desc ;

--5) Find the top 10 most recent customer with max web visits per month who are marrried ---
 SELECT * FROM  marketing_campaign ; 
select id,max(numwebvisitsmonth) as Max_webvisits, dt_customer , marital_status from marketing_campaign where marital_status ='Married' group  by id  order by 
dt_customer desc limit 10 ;

--6) Find the top 10 customer with highest gold buy  --
 SELECT * FROM  marketing_campaign ; 
select id , max(mntgoldprods)as max_goldbuyers from marketing_campaign  group by id order by max_goldbuyers desc limit 10 ;


--7) customers who are married or living together and have more than 2 children (Kidhome + Teenhome > 2) ---
SELECT * from  marketing_campaign where (Marital_Status = 'Married' OR Marital_Status = 'Together') and (Kidhome + Teenhome) > 2; 

--8) Calculate the average number of web visits per month for customers born after 1980--
 select avg (numwebvisitsmonth)as Average_web_visits from marketing_campaign where year_birth > 1980 ;
--ans: 5.6 --

--9) Select customers who have purchased more than 10 items from the catalog --
Select  * from  marketing_campaign where  NumCatalogPurchases > 10 ; 

--10) Calculate the average spending per product category by education level--

SELECT Education,avg(MntWines) as Avg_Wine_Spending, avg(MntFruits) as Avg_Fruit_Spending, avg(MntMeatProducts) as Avg_Meat_Spending,
avg(MntFishProducts) as Avg_Fish_Spending,avg (MntSweetProducts) as  Avg_Sweet_Spending, avg (MntGoldProds) as Avg_Gold_Spending
from marketing_campaign group by  Education;

--11) Find the most recent date a customer has made a purchase --
SELECT max (Dt_Customer) as Most_Recent_Purchase_Date from  marketing_campaign;
--ans. 2014-06-29 

--12) List customers who have visited the website more than 20 times in a month --
SELECT * 
FROM marketing_campaign
WHERE NumWebVisitsMonth > 10;

--13) Calculate the correlation between income and total spending --
select corr(Income, (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds)) AS Income_Spending_Correlation
FROM marketing_campaign;
--ans .0.7792589 --

--14) Identify the 2 most common education level among customers --
select  education ,count(*) as Numberof_customer  from marketing_campaign group by education order by Numberof_customer desc limit 2; 
--"Graduation"	392
-- "PhD"	    176

--15) Find customers who have made purchases through all three channels (web, catalog, store) --
select  * from  marketing_campaign where  NumWebPurchases > 0 and  NumCatalogPurchases > 0 and NumStorePurchases > 0; 

--16) Calculate the total amount spent on each product category  --
select  sum(MntWines) as Total_Wine_Spending,sum(MntFruits) as Total_Fruit_Spending,sum(MntMeatProducts) as Total_Meat_Spending,sum(MntFishProducts)as Total_Fish_Spending,
       sum(MntSweetProducts) as Total_Sweet_Spending, sum(MntGoldProds) as Total_Gold_Spending from  marketing_campaign;

--17) Find the average number of purchases (web, catalog, store) per customer--
     Select avg (NumWebPurchases) as Avg_Web_Purchases, 
       avg (NumCatalogPurchases) as Avg_Catalog_Purchases, 
      avg (NumStorePurchases) as   Avg_Store_Purchases
      from   marketing_campaign;

--18) Count the number of customers with no children at home --
 Select count(*) as  Num_Customers_No_Children  from marketing_campaign where  Kidhome = 0 AND Teenhome = 0; 

--19) Calculate the average income by marital status-- 
select marital_status , avg(income) as avg_income from marketing_campaign group by marital_status ; 

--20) Find top 5 customer with highest total spending --
select * from marketing_campaign ;
select id, sum(mntwines+mntfruits+mntmeatproducts+mntfishproducts+mntsweetproducts+mntgoldprods) as total_spending 
from marketing_campaign group by id order by total_spending desc limit 5 ; 

--21)Determine the average number of web visits per month by income bracket--
select case when income<10000 then 'poverty'
when income between 20000 and 50000 then 'medium' 
when income<20000 then 'low'
when income >50000 then 'High' end as income_bracket ,avg(numwebvisitsmonth)as AVG_WEBVISITS 
FROM marketing_campaign group by income_bracket ; 

--22) Find customers who have never made a purchase online ---
SELECT * from marketing_campaign where NumWebPurchases = 0; 

--23) Identify the top 3 products customers spend the most on, on average --
SELECT 'MntWines' AS Product, AVG(MntWines) AS Avg_Spending FROM marketing_campaign UNION ALL SELECT 'MntFruits', AVG(MntFruits)
FROM marketing_campaign UNION ALL SELECT 'MntMeatProducts', AVG(MntMeatProducts) FROM marketing_campaign UNION ALL
SELECT 'MntFishProducts', AVG(MntFishProducts) FROM marketing_campaign UNION ALL SELECT 'MntSweetProducts', AVG(MntSweetProducts)
FROM marketing_campaign UNION ALL SELECT 'MntGoldProds', AVG(MntGoldProds) FROM marketing_campaign
ORDER BY Avg_Spending DESC LIMIT 3 ; 

--24) Identify customers who have high engagement across multiple channels (more than 5 web purchases, more than 5 catalog purchases, and more than 5 store purchases)--
SELECT * from  marketing_campaign where  NumWebPurchases > 5 and  NumCatalogPurchases > 5 and  NumStorePurchases > 5; 

--25) Determine the average recency (number of days since the last purchase) by education level-- 
SELECT Education, avg (Recency) as  Avg_Recency from marketing_campaign GROUP BY Education;

--26) Find customers who spend more on meat products than on fish products ---
SELECT * from  marketing_campaign where  MntMeatProducts > MntFishProducts ; 

--27) Calculate the total number of kids (Kidhome + Teenhome) each customer has, and find the average number of kids per customer--
select sum(kidhome+teenhome) as total_kids from marketing_campaign ;
select id , avg(kidhome+teenhome) as avg_kids from marketing_campaign group by id order by avg_kids desc ; 

--28) Find customers who joined before 2013 and have spent more than $500 on meat products--
SELECT * from  marketing_campaign where  Dt_Customer < '2013-01-01' and MntMeatProducts > 500; 

--29)Identify the top 5 customers with the highest overall recency--
SELECT id, Recency from  marketing_campaign order by Recency desc limit  5 ;

--30) Calculate the average spending per customer in each education level and marital status group, and identify the group with the highest average spending --
SELECT Education, Marital_Status, AVG(Total_Spending) AS Avg_Spending
FROM (
    SELECT Education, Marital_Status, 
           (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS Total_Spending
    FROM marketing_campaign
) AS SpendingData
GROUP BY Education, Marital_Status
ORDER BY Avg_Spending DESC
LIMIT 1;












 

































 





       
       






 





       
       
       
       











	

