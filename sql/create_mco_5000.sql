create table meshblock_concordance_5000 as 
select mco.mb_code16,
mco.to_mb_code16,
distance,
s1.intersection as mb_intersection,
s2.area as intersection_area,
s3.proportion as proportion_covered, 
to_md.person * s3.proportion as population_covered, 
to_md.dwelling * s3.proportion as dwelling_covered
from meshblock_centroid from_mbc     -- geography of the source point
, meshblock to_mb 				  -- geography of the target meshblock
, meshblock_detail to_md
, meshblock_concordance mco
, lateral( select st_intersection( from_mbc.buffer_5000, st_transform( to_mb.geom, 3577))) as s1(intersection)
, lateral (values(st_area( s1.intersection))) as s2(area)
, lateral (values(round(cast(s2.area / (to_md.area_albers_sqkm*1000000) as numeric), 2))) as s3(proportion)
where from_mbc.mb_code16 = mco.mb_code16
and to_mb.mb_code16 = mco.to_mb_code16 
and to_md.mb_code16 = mco.to_mb_code16 
and mco.distance=5000
;
