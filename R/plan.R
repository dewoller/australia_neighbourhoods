mesh_detail_file="data/2016 census mesh block counts.xls"

the_plan <-
  drake_plan(

             max_distance = c(1,5),

             # get mesh shapefiles for all mesh blocks in Australia
             map_mesh=
               dir_ls('data/meshblocks', regexp='.*shp') %>%
               map( ~read_sf(.x)) %>%
               bind_rows() ,

             #map_sa1= read_s2( 'data/sa1/SA1_2016_AUST.shp') ,
             #map_sa2= read_s2( 'data/sa2/SA2_2016_AUST.shp') ,
             #map_sa3= read_s2( 'data/sa3/SA3_2016_AUST.shp') ,
             #map_sa4= read_s2( 'data/sa4/SA4_2016_AUST.shp'),

             #map_remoteness = read_s2("data/remoteness/RA_2016_AUST.shp"),


             # get mesh detail for all mesh blocks in Australia
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
               mutate( MB_CODE16 = as.character( MB_CODE16) ),

             df_mesh_types = target(
                                    df_mesh_detail %>%
                                      distinct( MB_CATEGORY_NAME_2016)
                                    ),
             df_mesh_centroids = calc_centroids( map_mesh), 


             df_mesh_within_range = target( point_within_geo_dist( df_mesh_centroids, 'MB_CODE16', 'point',
                                                                  map_mesh, 'MB_CODE16', 'geometry',
                                                                  max_dist=5000)),

             df_parks_within_range = target(
                                            df_mesh_within_range %>%
                                              inner_join( df_mesh_detail %>%
                                                         filter( MB_CATEGORY_NAME_2016=='Parkland') ,
                                                       by=c('to_MB_CODE16' = 'MB_CODE16'))
                                            ),

             df_parks_area = target( get_area_within_range( df_parks_within_range, map_mesh ) ),

             #             df_mesh_summary_all = summarise_intermesh_distances( df_mesh_distance, df_mesh_detail),


             a=TRUE
  )

