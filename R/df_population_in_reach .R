calculate_population_in_reach <- function( df_mesh_in_reach, df_mesh_detail) {
# the population within reach of each testing center at each


  df_mesh_in_reach %>%
    inner_join( df_mesh_detail, by='MB_CODE16') %>%
    group_by( id, distance_limit) %>%
    summarise( total_area =  sum( AREA_ALBERS_SQKM),
              total_dwelling = sum( Dwelling ),
              total_persons = sum(Person), .groups='drop')

}
