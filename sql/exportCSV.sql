

\copy meshblock_concordance TO '/store/export/meshblock_concordance.csv' with (format csv,header true, delimiter ',');
\copy meshblock_detail TO '/store/export/meshblock_detail.csv' with (format csv,header true, delimiter ',');
\copy meshblock_statistics TO '/store/export/meshblock_statistics.csv' with (format csv,header true, delimiter ',');
\copy remote_detail TO '/store/export/remote_detail.csv' with (format csv,header true, delimiter ',');
\copy sa1_seifa TO '/store/export/sa1_seifa.csv' with (format csv,header true, delimiter ',');


