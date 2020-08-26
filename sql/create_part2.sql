insert into meshblock_concordance ( 
select a.mb_code16 as mb_code16, b.mb_code16 as to_mb_code16, 400
  FROM meshblock_centroid a
  JOIN meshblock bmb_code16 b
  ON ST_DWithin(a.geom, b.geom, 400, false));
 insert into meshblock_concordance ( 
select a.mb_code16 as mb_code16, b.mb_code16 as to_mb_code16, 1000
  FROM meshblock_centroid a
  JOIN meshblock b
  ON ST_DWithin(a.geom, b.geom, 1000, false));
 insert into meshblock_concordance ( 
select a.mb_code16 as mb_code16, b.mb_code16 as to_mb_code16, 2000
  FROM meshblock_centroid a
  JOIN meshblock b
  ON ST_DWithin(a.geom, b.geom, 2000, false));
 create index meshblock_concordance1 on meshblock_concordance( distance, mb_code16, to_mb_code16);
 create index meshblock_concordance2 on meshblock_concordance( distance, to_mb_code16);
 create index meshblock_concordance3 on meshblock_concordance( distance, mb_code16);
 create index meshblock_concordance4 on meshblock_concordance( mb_code16, to_mb_code16);


