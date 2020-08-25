alter table meshblock_concordance add mb_intersection geometry;
update meshblock_concordance mco set mb_intersection=
(select st_intersection( st_buffer( from_mbc.geom::geometry, mco.distance), to_mb.geom) as intersection
  from meshblock_centroid from_mbc     -- geography of the source point
  , meshblock to_mb 				  -- geography of the target meshblock
  where from_mbc.mb_code16 = mco.mb_code16
  and to_mb.mb_code16 = mco.to_mb_code16
);
