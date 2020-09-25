alter table meshblock_detail add seifa_irsd numeric;

update meshblock_detail mb set seifa_irsd = sa.irsd
from sa1_seifa sa
where sa.sa1_main16 = mb.sa1_main16;

commit;