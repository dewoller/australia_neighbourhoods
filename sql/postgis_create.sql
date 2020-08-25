select geom from meshblock limit 10;

select geom from sa1 limit 10;

select ST_Centroid(geom, true) from sa1 limit 10;

drop table meshblock_centroid;

create table meshblock_centroid as select mb_code16, ST_Centroid(geom, true) as geom
from meshblock;

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
 
 

