CREATE INDEX meshblock_gix ON meshblock USING GIST (geom);
cluster meshblock using meshblock_gix;
CREATE UNIQUE INDEX meshblock_idx ON meshblock( mb_code16);
drop table if exists meshblock_centroid_3577;
create table meshblock_centroid_3577 as select mb_code16, ST_Centroid(geom, true) as geom from meshblock;
CREATE UNIQUE INDEX meshblock_centroid_3577_idx1 ON meshblock_centroid_3577 USING  mb_code16;
CREATE INDEX meshblock_centroid_3577_gix1 ON meshblock_centroid_3577 USING  gist (geom);
CREATE INDEX meshblock_centroid_3577_gix_5000 ON meshblock_centroid_3577 USING  gist (ST_Expand(geom::geometry, 5000));
CREATE INDEX meshblock_centroid_3577_gix_2000 ON meshblock_centroid_3577 USING  gist (ST_Expand(geom::geometry, 2000));
CREATE INDEX meshblock_centroid_3577_gix_1000 ON meshblock_centroid_3577 USING  gist (ST_Expand(geom::geometry, 1000));
CREATE INDEX meshblock_centroid_3577_gix_400 ON meshblock_centroid_3577 USING  gist (ST_Expand(geom::geometry, 400));


alter table meshblock_centroid 
add buffer_1000 geometry,
add buffer_2000 geometry,
add buffer_5000 geometry;

update meshblock_centroid set buffer_400 =  st_buffer( st_transform(geom::geometry, 3577)::geometry, 400);

update meshblock_centroid set buffer_1000 =  st_buffer( st_transform(geom::geometry, 3577)::geometry, 1000),
buffer_2000 =  st_buffer( st_transform(geom::geometry, 3577)::geometry, 2000),
buffer_5000 =  st_buffer( st_transform(geom::geometry, 3577)::geometry, 5000);

select buffer_5000 from meshblock_centroid mc ;


drop table temp;
create table temp as select * from meshblock_concordance mc limit 10;
select * from temp;


select st_area(st_intersection( from_mbc.buffer_5000, st_transform( to_mb.geom, 3577))), st_area(from_mbc.buffer_5000),  st_area(st_transform( to_mb.geom, 3577))
  from meshblock_centroid from_mbc     -- geography of the source point
  , meshblock to_mb 				  -- geography of the target meshblock
  , temp mco
  where from_mbc.mb_code16 = mco.mb_code16
  and to_mb.mb_code16 = mco.to_mb_code16
  and mco.distance=5000
;

select * from meshblock_concordance mco ;

update meshblock_concordance mco set 
mb_intersection= new_mb_intersection;


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


set mb_intersection=

select mb_code16,to_mb_code16,distance
,mb_intersection,intersection_area,proportion_covered,population_covered,dwelling_covered
   









