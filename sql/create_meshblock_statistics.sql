create index on meshblock_concordance( mb_code16);

create table meshblock_statistics as 
select mb_code16, distance, mb_category_name_2016,
sum(intersection_area) as intersection_area, 
sum(population_covered) as population_covered,
sum(dwelling_covered) as dwelling_covered,
count(*) as n_mb
from meshblock_concordance mc 
join meshblock_detail md using (mb_code16)
group by 1,2,3;
