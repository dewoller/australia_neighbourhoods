# for all blocks within range of original point,
# what is the total area of map_mesh blocks covered by
# max_dist buffer around original point

get_area_within_range <- function( df_mb_in_range, map_mesh, df_mesh_centroids) {

  df_mesh_centroids %>%
    mutate( buffer = s2_buffer_cells( point, max_dist )) %>%
    inner_join( df_mb_in_range, by=c('MB_CODE16')) %>%
    inner_join( map_mesh, by=c('to_MB_CODE16' = 'MB_CODE16')) %>%
    { . } -> df_from_mc

  # for each type, find total area, and prorated population, in the intersected mesh_within_range meshblocks
  df_from_mc %>%
    mutate( intersection_area = s2_intersection( buffer, geometry) %>% s2_area()) %>%
    mutate( mesh_block_area = s2_area( geometry )) %>%
    mutate( proportion_covered =  (intersection_area/mesh_block_area)) %>%
    mutate( prorata_population = Person * proportion_covered) %>%
    mutate( prorata_dwelling = Dwelling * proportion_covered) %>%
    group_by( MB_CODE16 ) %>%
    summarise(
              nblock = n(),
              population = sum( prorata_population),
              dwelling = sum( prorata_dwelling),
              mean_coverage = mean(proportion_covered)
    )

}


