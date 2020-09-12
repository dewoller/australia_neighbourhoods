
with total_area as (
  select mb_code16, sum(intersection_area)*(1/0.99358685114462951054) as this_area
  from meshblock_statistics_400
  group by 1
)
update meshblock_statistics_400 mb 
set category_proportion = mb.intersection_area / this_area
from total_area ta
where ta.mb_code16=mb.mb_code16
and mb.mb_code16!='70004370000';
;
with total_area as (
  select mb_code16, sum(intersection_area)*(1/0.99358685114462951054) as this_area
  from meshblock_statistics_1000
  group by 1
)
update meshblock_statistics_1000 mb 
set category_proportion = mb.intersection_area / this_area
from total_area ta
where ta.mb_code16=mb.mb_code16
;
with total_area as (
  select mb_code16, sum(intersection_area)*(1/0.99358685114462951054) as this_area
  from meshblock_statistics_2000
  group by 1
)
update meshblock_statistics_2000 mb 
set category_proportion = mb.intersection_area / this_area
from total_area ta
where ta.mb_code16=mb.mb_code16
;
with total_area as (
  select mb_code16, sum(intersection_area)*(1/0.99358685114462951054) as this_area
  from meshblock_statistics_5000
  group by 1
)
update meshblock_statistics_5000 mb 
set category_proportion = mb.intersection_area / this_area
from total_area ta
where ta.mb_code16=mb.mb_code16
;

