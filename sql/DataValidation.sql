select * from
meshblock_concordance_5000
join meshblock using (mb_code16)
where mb_code16='20632003050'
order by mb_cat16;

select to_mb_code16 from
meshblock_concordance_5000
join meshblock using (mb_code16)
where mb_code16='20632003050'
order by mb_cat16;

select mb_code16, mb_cat16, st_union( mb_intersection)  from
meshblock_concordance_5000
join meshblock using (mb_code16)
where mb_code16='20632003050'
group by 1,2;

select * from
meshblock_statistics_5000
where mb_code16='20632003050';

select * from
meshblock_concordance_5000
where mb_code16='70016393200';

select * from
meshblock_statistics_5000
where mb_code16='70016393200';

70016393200

with pairs_mco as (
  select mc.mb_code16 as mb_code16, mb.mb_code16 as to_mb_code16, mc.buffer_5000, mb.geom as to_mb_geom
  FROM meshblock_centroid mc
  JOIN meshblock mb
  ON ST_DWithin(mc.geom, mb.geom, 5000, false) )
select mco.mb_code16,
mco.to_mb_code16,
5000 as distance,
s1.intersection as mb_intersection,
s2.area as intersection_area,
s3.proportion as proportion_covered, 
to_md.person * s3.proportion as population_covered, 
to_md.dwelling * s3.proportion as dwelling_covered
from meshblock_detail to_md
, pairs_mco mco
, lateral (values(st_intersection( mco.buffer_5000, st_transform( to_mb_geom, 3577)))) as s1(intersection)
, lateral (values(st_area( s1.intersection))) as s2(area)
, lateral (values(round(cast(s2.area / (to_md.area_albers_sqkm*1000000) as numeric), 2))) as s3(proportion)
where to_md.mb_code16 = mco.to_mb_code16 
and mco.mb_code16='70016393200';
;


select m.mb_code16, mb_cat16, m.geom::geometry as geometry 
from meshblock_centroid m 
join meshblock using (mb_code16) ;


select geom,  st_transform( geom, 3577) from meshblock limit 10;


select mb.mb_code16, distance, mb.mb_category_name_2016, population_covered, intersection_area, category_proportion
from meshblock_statistics mb
join meshblock_detail md using (mb_code16)
join df_mesh_centroids_sample sample using (mb_code16);

             select mb.mb_code16, distance, mb.to_mb_code16, intersection_area, proportion_covered
           from meshblock_concordance mb
           join meshblock_detail md using (mb_code16)
           join df_mesh_centroids_sample sample using (mb_code16);

          
select mb.geom, mc.geom, st_distance( st_transform(mc.geom::geometry, 3577), mb.geom_3577), 
 st_union( st_transform(mc.geom::geometry, 3577), mb.geom_3577) from 
meshblock_centroid mc 
join meshblock mb using (mb_code16)
where mc.geom is not null
and 	st_distance( st_transform(mc.geom::geometry, 3577), mb.geom_3577) !=0
order by  st_distance( st_transform(mc.geom::geometry, 3577), mb.geom_3577)  desc;


select count(*) from 
meshblock_centroid mc 
join meshblock mb using (mb_code16)
where mc.geom is not null
and 	st_distance( st_transform(mc.geom::geometry, 3577), mb.geom_3577) !=0


select mb.*
from meshblock_statistics mb
join sa1_seifa sa on 
f;
          
          