create table meshblock_concordance_2000 as
with pairs_mco as (
  select mc.mb_code16 as mb_code16, mb.mb_code16 as to_mb_code16, mc.buffer_2000, mb.geom as to_mb_geom
  FROM meshblock_centroid mc
  JOIN meshblock mb
  ON ST_DWithin(mc.geom, mb.geom, 2000, false) )
select mco.mb_code16,
mco.to_mb_code16,
2000 as distance,
s1.intersection as mb_intersection,
s2.area as intersection_area,
s3.proportion as proportion_covered, 
to_md.person * s3.proportion as population_covered, 
to_md.dwelling * s3.proportion as dwelling_covered
from meshblock_detail to_md
, pairs_mco mco
, lateral (values(st_intersection( mco.buffer_2000, st_transform( to_mb_geom, 3577)))) as s1(intersection)
, lateral (values(st_area( s1.intersection))) as s2(area)
, lateral (values(round(cast(s2.area / (to_md.area_albers_sqkm*1000000) as numeric), 2))) as s3(proportion)
where to_md.mb_code16 = mco.to_mb_code16 
;


create index meshblock_concordance_2000_idx_1 on meshblock_concordance_2000( mb_code16, to_mb_code16 );
create index meshblock_concordance_2000_idx_2 on meshblock_concordance_2000( to_mb_code16, mb_code16 );
create  table meshblock_statistics_2000 as (
  select mc.mb_code16, distance, mb_category_name_2016,
  sum(intersection_area) as intersection_area,
  sum(population_covered) as population_covered,
  sum(dwelling_covered) as dwelling_covered,
  count(*) as n_mb, 
  -1.1 as category_proportion
  from meshblock_concordance_2000 mc
  join meshblock_detail md on md.mb_code16=mc.to_mb_code16
  group by 1,2,3);



