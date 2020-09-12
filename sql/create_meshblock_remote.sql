create table meshblock_remote as 
select mb.mb_code16, r.ra_code16, s1.intersection_geom, st_area(s1.intersection_geom) as intersect_area
from meshblock mb, remoteness r,
lateral (values( st_intersection( r.geom,  mb.geom))) as s1(intersection_geom)
where st_intersects( r.geom,  mb.geom) ;
