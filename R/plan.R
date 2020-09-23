mesh_detail_file="data/2016 census mesh block counts.xls"

set.seed(1234)
max_distance_range = c(400,1000,2000,5000)

the_plan <-
  drake_plan(


             # get mesh shapefiles for all mesh blocks in Australia
             map_mesh=
               dir_ls('data/meshblocks', regexp='.*shp') %>%
               map( ~read_sf(.x)) %>%
               bind_rows()  %>%
             janitor::clean_names(),

             #map_sa1= read_s2( 'data/sa1/SA1_2016_AUST.shp') ,
             #map_sa2= read_s2( 'data/sa2/SA2_2016_AUST.shp') ,
             #map_sa3= read_s2( 'data/sa3/SA3_2016_AUST.shp') ,
             #map_sa4= read_s2( 'data/sa4/SA4_2016_AUST.shp'),

             #map_remoteness = read_s2("data/remoteness/RA_2016_AUST.shp"),


             # get mesh detail for all mesh blocks in Australia
             df_mesh_detail_csv = read_csv('data/2016 census mesh block counts.csv',
                                           col_types= cols(
                                                  MB_CODE_2016 = col_character(),
                                                  MB_CATEGORY_NAME_2016 = col_character(),
                                                  AREA_ALBERS_SQKM = col_double(),
                                                  Dwelling = col_double(),
                                                  Person = col_double(),
                                                  State = col_double()
                                             ) )  %>%
               rename( MB_CODE16 = MB_CODE_2016) %>%
               drop_na(2) %>%
               janitor::clean_names(),
             #
             df_mesh_detail = readxl::excel_sheets(mesh_detail_file) %>%
               enframe(name=NULL) %>%
               filter( str_detect( value,  '^Table.*') ) %>%
               pluck('value') %>%
               map( ~read_excel(mesh_detail_file,
                                sheet=.x,
                                skip=5,
                                guess_max=10)) %>%
               bind_rows() %>%
               as_tibble() %>%
               drop_na(1) %>%
               rename( MB_CODE16 = MB_CODE_2016) %>%
               mutate( MB_CODE16 = as.character( MB_CODE16) ) %>%
             janitor::clean_names(),

             df_mesh_types = target(
                                    df_mesh_detail_csv %>%
                                      distinct( mb_category_name_2016)
                                    ),
             df_mesh_centroids = calc_centroids( map_mesh),
             df_mesh_centroids_sample = sample_n( df_mesh_centroids, 3581),

             # df_mesh_centroids_sample = df_mesh_centroids %>%
             #   filter( !st_is_empty( geometry)) %>%
             #   filter( mb_code16 == '20632003050'),
#             df_mesh_centroids_sample = sample_n( df_mesh_centroids, 4),


             df_mesh_within_range =
               target( point_within_geo_dist( df_mesh_centroids_sample, map_mesh, max_dist=max_distance),
                      transform = cross(max_distance = c(400,1000,2000,5000)  )),
             result1 = write_table( df_mesh_centroids_sample),


             # df_parks_within_range = target(
             # df_mesh_within_range %>%
             # inner_join( df_mesh_detail %>%
             # filter( MB_CATEGORY_NAME_2016=='Parkland') ,
             # by=c('to_MB_CODE16' = 'MB_CODE16'))
             # ),

             #             df_parks_area = target( get_area_within_range( df_parks_within_range, map_mesh ) ),

             #             df_mesh_summary_all = summarise_intermesh_distances( df_mesh_distance, df_mesh_detail),


             a=TRUE
  )

