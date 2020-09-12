CREATE INDEX meshblock_gix ON meshblock USING GIST (geom);
cluster meshblock using meshblock_gix;
CREATE UNIQUE INDEX meshblock_idx ON meshblock USING mb_code16;
drop table if exists meshblock_centroid_3577;
create table meshblock_centroid_3577 as select mb_code16, ST_Centroid(geom, true) as geom from meshblock;
CREATE UNIQUE INDEX meshblock_centroid_3577_idx1 ON meshblock_centroid_3577 USING  mb_code16;
CREATE INDEX meshblock_centroid_3577_gix1 ON meshblock_centroid_3577 USING  gist (geom);
CREATE INDEX meshblock_centroid_3577_gix_5000 ON meshblock_centroid_3577 USING  gist (ST_Expand(geom::geometry, 5000));
CREATE INDEX meshblock_centroid_3577_gix_2000 ON meshblock_centroid_3577 USING  gist (ST_Expand(geom::geometry, 2000));
CREATE INDEX meshblock_centroid_3577_gix_1000 ON meshblock_centroid_3577 USING  gist (ST_Expand(geom::geometry, 1000));
CREATE INDEX meshblock_centroid_3577_gix_400 ON meshblock_centroid_3577 USING  gist (ST_Expand(geom::geometry, 400));


with mco as ( 
select a.mb_code16 as mb_code16, b.mb_code16 as to_mb_code16, 400)
  FROM meshblock_centroid_3577 a
  JOIN meshblock b
  ON ST_DWithin(a.geom, b.geom, 400, false) ), 
--- calculate the intersection of all in range
intersection as 
(select st_intersection( st_buffer( from_mbc.geom::geometry, mco.distance), to_mb.geom) as intersection
  from meshblock_centroid from_mbc     -- geography of the source point
  , meshblock to_mb 				  -- geography of the target meshblock
  where from_mbc.mb_code16 = mco.mb_code16
  and to_mb.mb_code16 = mco.to_mb_code16
);

 
select a.mb_code16 as mb_code16, b.mb_code16 as to_mb_code16, 400)
  FROM meshblock_centroid_3577 a
  JOIN meshblock b
  ON ST_DWithin(a.geom, b.geom, 400, false) limit 10;

 
 alter table meshblock_concordance  add distance numeric;
update meshblock_concordance set distance=5000;


with



 
alter table meshblock_concordance add mb_intersection geometry;
update meshblock_concordance mco set mb_intersection=
(select st_intersection( st_buffer( from_mbc.geom::geometry, mco.distance), to_mb.geom) as intersection
  from meshblock_centroid from_mbc     -- geography of the source point
  , meshblock to_mb 				  -- geography of the target meshblock
  where from_mbc.mb_code16 = mco.mb_code16
  and to_mb.mb_code16 = mco.to_mb_code16
);
 

