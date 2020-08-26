insert into meshblock_concordance_1 
select mc.mb_code16, mc.to_mb_code16, mc.distance, mc.mb_intersection, mc.intersection_area,
mc.intersection_area *10000/ mb.areasqkm16/0.9703810420683165,
(mc.intersection_area *10000/ mb.areasqkm16/0.9703810420683165) * md.person,
(mc.intersection_area *10000/ mb.areasqkm16/0.9703810420683165) * md.dwelling
from meshblock_concordance mc 
join meshblock mb on mb.mb_code16 = mc.to_mb_code16 
join meshblock_detail md on md.mb_code16 = mc.to_mb_code16;
