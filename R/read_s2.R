if (FALSE) {

  read_s2('data/meshblocks/MB_2016_NT.shp')
}
read_s2= function( filename ) {

  read_sf( filename ) %>%
    mutate( s2=s2_geog_from_wkb(st_as_binary(geometry), check=FALSE)) %>%
    st_drop_geometry() %>%
    rename( geometry=s2)

}
