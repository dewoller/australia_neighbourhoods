meshblock_concordance      | table | dewoller | 220 GB     | Meshblock meshblock concordance listing every to_mb_code16 meshblock overlapped by distance radius  from centroid of mb_code16
meshblock_detail           | table | dewoller | 67 MB      | Summary of each meshblock
meshblock_statistics       | table | dewoller | 749 MB     | Neighbourhood land use summary  within distance radius of meshblock centroid
remote_detail              | table | dewoller | 8192 bytes | Remote category lookup
sa1_seifa                  | table | dewoller | 3816 kB    | Seifa numbers at SA1 granularity

meshblock_concordance	Meshblock meshblock concordance listing every to_mb_code16 meshblock overlapped by distance radius  from centroid of mb_code16
meshblock_detail	Summary of each meshblock
meshblock_statistics	Neighbourhood land use summary  within distance radius of meshblock centroid
remote_detail	Remote category lookup
sa1_seifa	Seifa numbers at SA1 granularity


\d+ meshblock_concordance
\d+ meshblock_detail
\d+ meshblock_statistics
\d+ remote_detail
\d+ sa1_seifa

COPY meshblock_concordance TO /tmp/meshblock_concordance.csv DELIMITER ',' CSV HEADER;
COPY meshblock_detail TO /tmp/meshblock_detail.csv DELIMITER ',' CSV HEADER;
COPY meshblock_statistics TO /tmp/meshblock_statistics.csv DELIMITER ',' CSV HEADER;
COPY remote_detail TO /tmp/remote_detail.csv DELIMITER ',' CSV HEADER;
COPY sa1_seifa TO /tmp/sa1_seifa.csv DELIMITER ',' CSV HEADER;


