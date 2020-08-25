
source('_drake.R')

fs::dir_ls(glob='output.*csv') %>%
  vroom::vroom(
               col_names=c('MB_CODE16','to_MB_CODE16', 'max_distance' ),
               col_types='ccn',
               col_select='MB_CODE16'
               )  %>%
distinct(MB_CODE16) %>%
{ . } -> df

loadd(df_mesh_detail)

df_mesh_detail %>%
  anti_join( df)

286342 * 20 /3600 / 24 / 20

df %>%
  count( MB_CODE16) %>%
  filter(n<240000 ) %>%
  summarise(mean(n), sd(n), min(n))

js

con <- RPostgreSQL::dbConnect(DBI::dbDriver("PostgreSQL"),
                 user="dewoller", password=db_password,
                           host="localhost", port=5432, dbname="postgis_db")

dbReadTable( con, 'meshblock_statistics') %>%
  as_tibble() %>%
  { . } -> df_stats

read_csv("data/SA4_2016_AUST.csv") %>%
  janitor::clean_names() %>%
  mutate( sa4_code16 = as.character( sa4_code_2016)) %>%
  { . } -> df_sa4

loadd(map_mesh)

map_mesh %>%
  janitor::clean_names() %>%
  inner_join( df_sa4, by = "sa4_code16" ) %>%
  inner_join( df_stats, by='mb_code16') %>%
  { . } -> df_wide

df_wide %>%
  sf::st_drop_geometry() %>%
  filter(distance==5000) %>%
  filter( str_detect( gccsa_name_2016, 'Greater | Capital ' )) %>%
  { . } -> df_wide_partial

df_wide_partial %>%
  ggplot( aes( y=intersection_area, x=gccsa_name_2016, fill=gccsa_name_2016 )) +
  geom_violin() +
  facet_wrap( ~mb_cat16)




  group_by( gccsa_name_2016, mb_category_name_2016  ) %>%
  summarise( )



df_sa4 %>%
count( gccsa_name_2016)
