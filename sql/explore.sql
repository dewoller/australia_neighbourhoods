<<<<<<< HEAD
  alter table meshblock_concordance 
  add column intersection_area float8,
 add column  proportion_covered float8,
 add column  population_covered float8,
 add column  dwelling_covered float8;
---
UPDATE meshblock_concordance mc
SET mc.intersection_area = st_area( mc.mb_intersection );
---
UPDATE meshblock_concordance mc
SET mc.proportion_covered = intersection_area *10000/ mb.areasqkm16/0.9703810420683165
=======
  --  alter table meshblock_concordance
  --  add column intersection_area float8,
 --  add column  proportion_covered float8,
 --  add column  population_covered float8,
 --  add column  dwelling_covered float8;
--  ---
--  UPDATE meshblock_concordance mc
--  SET intersection_area = st_area( mb_intersection );
---
UPDATE meshblock_concordance mc
SET proportion_covered = intersection_area *10000/ mb.areasqkm16/0.9703810420683165
>>>>>>> 9e3d25c325586a0801122538225cf5669011408c
FROM meshblock mb
WHERE mb.mb_code16 = mc.to_mb_code16 ;
---
UPDATE meshblock_concordance mc
<<<<<<< HEAD
SET mc.population_covered = mc.proportion_covered * md.person,
 mc.dwelling_covered = mc.proportion_covered * md.dwelling
=======
SET population_covered = mc.proportion_covered * md.person,
 dwelling_covered = mc.proportion_covered * md.dwelling
>>>>>>> 9e3d25c325586a0801122538225cf5669011408c
FROM meshblock_detail md
WHERE md.mb_code16 = mc.to_mb_code16 ;
