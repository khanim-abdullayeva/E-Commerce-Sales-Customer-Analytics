with Joined1 as(
select s.*,
replace(replace("Unit Price USD", "$",""), ",","") - replace(replace("Unit Cost USD", "$",""), ",","") as "Gross Profit USD",
p.Category
from sales s
left join products p
on s.ProductKey = p.ProductKey)

select *
from Joined1


