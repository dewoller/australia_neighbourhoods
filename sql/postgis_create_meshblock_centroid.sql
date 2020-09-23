CREATE INDEX meshblock_gix ON meshblock USING GIST (geom);
cluster meshblock using meshblock_gix;

select geom from meshblock limit 10;

select geom from sa1 limit 10;

select ST_Centroid(geom, true) from sa1 limit 10;

drop table meshblock_centroid;

create table meshblock_centroid as select mb_code16, ST_Centroid(geom, true) as geom
from meshblock;

drop index if exists meshblock_centroid_gix;
CREATE INDEX meshblock_centroid_gix1 ON meshblock_centroid USING  gist (geom);

CREATE INDEX meshblock_centroid_gix ON meshblock_centroid USING  gist (ST_Expand(geom::geometry, 5000));
cluster meshblock_centroid using meshblock_centroid_gix;

alter index meshblock_centroid_gix1 rename to meshblock_centroid_gix;

CREATE INDEX meshblock_centroid_gix_2000 ON meshblock_centroid USING  gist (ST_Expand(geom::geometry, 2000));
CREATE INDEX meshblock_centroid_gix_1000 ON meshblock_centroid USING  gist (ST_Expand(geom::geometry, 1000));
CREATE INDEX meshblock_centroid_gix_400 ON meshblock_centroid USING  gist (ST_Expand(geom::geometry, 400));

drop table temp_output;
insert into meshblock_concordance ( 
select a.mb_code16 as mb_code16, b.mb_code16 as to_mb_code16, 400)
  FROM meshblock_centroid a
  JOIN meshblock b
  ON ST_DWithin(a.geom, b.geom, 400, false);

 
select a.mb_code16 as mb_code16, b.mb_code16 as to_mb_code16, 400)
  FROM meshblock_centroid a
  JOIN meshblock b
  ON ST_DWithin(a.geom, b.geom, 400, false) limit 10;

 
 alter table meshblock_concordance  add distance numeric;
update meshblock_concordance set distance=5000;

select * from meshblock_concordance limit 10;





drop table mbc1;

create table mbc1 as select mb_code16, ST_Centroid(geom, false) as geom
from mb1;

create view temp as select * from meshblock_centroid limit 10;

select * from mbc1;


create table mb1 as select * from meshblock;
alter table mb1 add g1 geometry;
update mb1 set g1 = ST_Transform( geom, 4462);
alter table mb1 drop geom;
alter table mb1 rename g1 to geom;

drop table mbc1;
create table mbc1 as select * from meshblock_centroid;
alter table mbc1 add g1 geography;
update mbc1 set g1 = ST_Transform( geom, 4462);
alter table mbc1 drop geom;
alter table mbc1 rename g1 to geom;
CREATE INDEX mb1_gix ON mb1 USING GIST (geom);
cluster mb1 using mb1_gix;


SELECT ST_NPoints(ST_Buffer(ST_GeomFromText('POINT(100 90)'), 50)) As promisingcircle_pcount,
ST_NPoints(ST_Buffer(ST_GeomFromText('POINT(100 90)'), 50, 2)) As lamecircle_pcount;

select a.mb_code16 as mb_code16, b.mb_code16 as to_mb_code16
  FROM temp a
  JOIN mb1 b
  ON ST_DWithin(a.geom, b.geom, 5000);

CREATE INDEX meshblock_gix ON meshblock USING GIST (geom);
CREATE INDEX mb1_gix ON mb1 USING GIST (geom);
cluster mb1 using mb1_gix;

CREATE INDEX meshblock_centroid_gix ON meshblock_centroid USING GIST (geom);

 SELECT srid, srtext, proj4text FROM spatial_ref_sys WHERE srtext ILIKE '%BLAH%' 
 
 

