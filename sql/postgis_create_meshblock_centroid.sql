CREATE INDEX meshblock_gix ON meshblock USING GIST (geom);
cluster meshblock using meshblock_gix;

drop table if exists meshblock_centroid;
create table meshblock_centroid as 
select mb_code16, ST_Centroid(geom, true) as geom
from meshblock;

drop index if exists meshblock_centroid_gix;
CREATE INDEX meshblock_centroid_gix ON meshblock_centroid USING  gist (geom);
cluster meshblock_centroid using meshblock_centroid_gix;

CREATE INDEX meshblock_centroid_gix_5000 ON meshblock_centroid USING  gist (ST_Expand(geom::geometry, 5000));
CREATE INDEX meshblock_centroid_gix_2000 ON meshblock_centroid USING  gist (ST_Expand(geom::geometry, 2000));
CREATE INDEX meshblock_centroid_gix_1000 ON meshblock_centroid USING  gist (ST_Expand(geom::geometry, 1000));
CREATE INDEX meshblock_centroid_gix_400 ON meshblock_centroid USING  gist (ST_Expand(geom::geometry, 400));


