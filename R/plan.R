mesh_detail_file="data/2016 census mesh block counts.xls"

the_plan <-
  drake_plan(

             max_distance = c(1,5),

             # get mesh shapefiles for all mesh blocks in Australia
             map_mesh= 
               dir_ls('data/meshblocks', regexp='.*shp') %>%
               map( ~read_sf(.x)) %>%
               bind_rows() %>% 
               rmapshaper::ms_simplify( sys = TRUE) ,

             map_sa1= read_sf( 'data/sa1/SA1_2016_AUST.shp') %>%
               rmapshaper::ms_simplify( sys = TRUE)  ,
             map_sa2= read_sf( 'data/sa2/SA2_2016_AUST.shp') %>%
               rmapshaper::ms_simplify( sys = TRUE)  ,

             map_sa3= read_sf( 'data/sa3/SA3_2016_AUST.shp') %>%
               rmapshaper::ms_simplify( sys = TRUE)  ,


             map_sa4= read_sf( 'data/sa4/SA4_2016_AUST.shp') %>%
               rmapshaper::ms_simplify( sys = TRUE)  ,

             map_remoteness = read_sf("data/remoteness/RA_2016_AUST.shp"),


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

             df_mesh_centroids =
               map_mesh  %>%
               st_transform( 3577) %>%
               st_centroid() %>%
               st_transform(., '+proj=longlat +ellps=GRS80 +no_defs') %>% # we want the centroids in a second geometry col
               st_coordinates() %>%
                 as_tibble() %>%
                 set_names('mc_lon','mc_lat') %>%
                 mutate( MB_CODE16 = map_mesh %>% pluck( 'MB_CODE16' )),

               df_mesh_sa1 = categorise_points( df_mesh_centroids,
                                               long_txt='mc_lon',
                                               lat_txt='mc_lat',
                                               map_data=map_sa1,
                                               column="SA1_MAIN16") ,

             df_mesh_sa2 = categorise_points( df_mesh_centroids,
                                             long_txt='mc_lon',
                                             lat_txt='mc_lat',
                                             map_data=map_sa2,
                                             column="SA2_MAIN16"),

             df_mesh_sa3 = categorise_points( df_mesh_centroids,
                                             long_txt='mc_lon',
                                             lat_txt='mc_lat',
                                             map_data=map_sa3,
                                             column="SA3_MAIN16"),


             df_mesh_sa4 = categorise_points( df_mesh_centroids,
                                             long_txt='mc_lon',
                                             lat_txt='mc_lat',
                                             map_data=map_sa4,
                                             column="SA4_MAIN16"),


             df_mesh_distance = target( calculate_intermesh_distances( df_mesh_centroids,
                                                                      df_mesh_detail,
                                                                      map_mesh,
                                                                      max_dist=max_distance), 
                                       dynamic=map(max_distance),

                                       ),

             df_mesh_summary_all = summarise_intermesh_distances( df_mesh_distance,
                                                                 df_mesh_detail,
                                                                 df_mesh_sa1,
                                                                 df_mesh_sa2,
                                                                 df_mesh_sa3,
                                                                 df_mesh_sa4),




             a=TRUE
  )

check1 = function() {
  plot(st_geometry(map_mesh))
  plot(df_mesh_centroids, add = T, col = 'red', pch = 19)

  df_mesh_in_reach_5
  drake_cache()
}


calc_means <- function(df, var, n) {
  pb <- progress_estimated(n)
  var <- enquo(var)
  map_df(seq_len(n), ~calc_mean(df = df, var = var, pb = pb))
}

calc_mean <- function(df, var, pb) {
  pb$pause(1.2)$tick()$print()
  df %>%
    sample_n(nrow(df), replace = T) %>%
    summarise(m = mean(!!var))
}

