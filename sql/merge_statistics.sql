
create table meshblock_statistics as 
select * from meshblock_statistics_1000
union select * from 
meshblock_statistics_2000
union select * from 
meshblock_statistics_400
union select * from 
meshblock_statistics_5000;
