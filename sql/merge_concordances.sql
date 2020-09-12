
create table meshblock_concordance as 
select * from meshblock_concordance_1000
union select * from 
meshblock_concordance_2000
union select * from 
meshblock_concordance_400
union select * from 
meshblock_concordance_5000;
