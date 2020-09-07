source('_drake.R')

drv <- dbDriver('PostgreSQL');

con <- dbConnect(drv,host='alf',port=5432,dbname='postgis_db',
                 user='dewoller',pass=db_password);



dbRemoveTable(con, 'meshblock_detail')
dbRemoveTable(con, 'mesh_detail')

loadd(df_mesh_detail_csv)

df_mesh_detail_csv %>%
  janitor::clean_names() %>%
  dbWriteTable(con, 'meshblock_detail', ., row.names=FALSE, overwrite=TRUE,
  field.types=c('mb_code16'='varchar(11)', "mb_category_name_2016"='TEXT',"area_albers_sqkm"='FLOAT8',"dwelling"='FLOAT8',"person"='FLOAT8',"state"='FLOAT8'))
