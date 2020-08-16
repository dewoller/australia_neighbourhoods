calc_centroids <- function( map_mesh) {

  map_mesh  %>%
    st_transform( 3577) %>%
    st_centroid() %>%
    st_transform(., '+proj=longlat +ellps=GRS80 +no_defs')

}
