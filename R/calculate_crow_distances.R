calculate_crow_distances <- function( df_covid_test_location, df_mesh_centroids) {


  df_mesh_centroids %>%
#    head(2) %>%
    crossing( df_covid_test_location %>%
             select( covid_lat, covid_lon, id)) %>%
    mutate( dist = distHaversine( matrix(c(covid_lon, covid_lat), ncol=2),
                                 matrix(c( mc_lon, mc_lat), ncol=2)))


}
