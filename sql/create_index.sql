create index on meshblock_centroid using gist(st_expand( geom::geometry, 400)) ;
create index on meshblock_centroid using gist(st_expand( geom::geometry, 1000)) ;
create index on meshblock_centroid using gist(st_expand( geom::geometry, 2000)) ;
create index on meshblock_centroid using gist(st_expand( geom::geometry, 5000)) ;

