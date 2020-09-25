drop table meshblock_statistics ;

create index meshblock_concordance_400_idx_1 on meshblock_concordance_400( mb_code16, to_mb_code16 );
create index meshblock_concordance_400_idx_2 on meshblock_concordance_400( to_mb_code16, mb_code16 );
create  table meshblock_statistics_400 as (
select mc.mb_code16, distance, mb_category_name_2016,
sum(intersection_area) as intersection_area,
sum(population_covered) as population_covered,
sum(dwelling_covered) as dwelling_covered,
count(*) as n_mb
from meshblock_concordance_400 mc
join meshblock_detail md on md.mb_code16=mc.to_mb_code16
group by 1,2,3);




create index meshblock_concordance_5000_idx_1 on meshblock_concordance_5000( mb_code16, to_mb_code16 );
create index meshblock_concordance_5000_idx_2 on meshblock_concordance_5000( to_mb_code16, mb_code16 );
create  table meshblock_statistics_5000 as (
select mc.mb_code16, distance, mb_category_name_2016 as to_mb_category,
create index on meshblock_concordance_1000_idx_1 on meshblock_concordance_1000( mb_code16, to_mb_code16 );
create index on meshblock_concordance_1000_idx_2 on meshblock_concordance_1000( to_mb_code16, mb_code16 );

create index on meshblock_concordance_400_idx_1 on meshblock_concordance_400( mb_code16, to_mb_code16 );
create index on meshblock_concordance_400_idx_2 on meshblock_concordance_400( to_mb_code16, mb_code16 );

create index on meshblock_concordance_2000_idx_1 on meshblock_concordance_2000( mb_code16, to_mb_code16 );
create index on meshblock_concordance_2000_idx_2 on meshblock_concordance_2000( to_mb_code16, mb_code16 );

create index on meshblock_concordance_5000_idx_1 on meshblock_concordance_5000( mb_code16, to_mb_code16 );
create index on meshblock_concordance_5000_idx_2 on meshblock_concordance_5000( to_mb_code16, mb_code16 );

drop table meshblock_statistics ;

create or replace table meshblock_statistics_5000 as 
select mb_code16, distance, mb_category_name_2016 as to_mb_category,
sum(intersection_area) as intersection_area, 
sum(population_covered) as population_covered,
sum(dwelling_covered) as dwelling_covered,
count(*) as n_mb
from meshblock_concordance_5000 mc 
join meshblock_detail md on md.mb_code16=mc.to_mb_code16
group by 1,2,3);



create index meshblock_concordance_1000_idx_1 on meshblock_concordance_1000( mb_code16, to_mb_code16 );
create index meshblock_concordance_1000_idx_2 on meshblock_concordance_1000( to_mb_code16, mb_code16 );
create  table meshblock_statistics_1000 as (
select mc.mb_code16, distance, mb_category_name_2016,
group by 1,2,3;

create or replace table meshblock_statistics_2000 as 
select mb_code16, distance, mb_category_name_2016,
sum(intersection_area) as intersection_area, 
sum(population_covered) as population_covered,
sum(dwelling_covered) as dwelling_covered,
count(*) as n_mb
from meshblock_concordance_1000 mc 
join meshblock_detail md on md.mb_code16=mc.to_mb_code16
group by 1,2,3);


create index meshblock_concordance_2000_idx_1 on meshblock_concordance_2000( mb_code16, to_mb_code16 );
create index meshblock_concordance_2000_idx_2 on meshblock_concordance_2000( to_mb_code16, mb_code16 );
create  table meshblock_statistics_2000 as (
select mc.mb_code16, distance, mb_category_name_2016,
from meshblock_concordance_2000 mc 
join meshblock_detail md on md.mb_code16=mc.to_mb_code16
group by 1,2,3;

create or replace table meshblock_statistics_400 as 
select mb_code16, distance, mb_category_name_2016,
sum(intersection_area) as intersection_area, 
sum(population_covered) as population_covered,
sum(dwelling_covered) as dwelling_covered,
count(*) as n_mb
from meshblock_concordance_2000 mc 
join meshblock_detail md on md.mb_code16=mc.to_mb_code16
group by 1,2,3);
from meshblock_concordance_400 mc 
join meshblock_detail md on md.mb_code16=mc.to_mb_code16
group by 1,2,3;

create or replace table meshblock_statistics_1000 as 
select mb_code16, distance, mb_category_name_2016,
sum(intersection_area) as intersection_area, 
sum(population_covered) as population_covered,
sum(dwelling_covered) as dwelling_covered,
count(*) as n_mb
from meshblock_concordance_1000 mc 
join meshblock_detail md on md.mb_code16=mc.to_mb_code16
group by 1,2,3;
