exclude_distant_meshes <- function( df_crow_distances, maximum_distance ) {

  df_crow_distances %>%
    filter( dist <= maximum_distance * 1000 ) %>%
    mutate( distance_limit = maximum_distance)


}
