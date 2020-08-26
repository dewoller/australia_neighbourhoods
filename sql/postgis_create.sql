CREATE INDEX meshblock_gix ON meshblock USING GIST (geom);
cluster meshblock using meshblock_gix;

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






