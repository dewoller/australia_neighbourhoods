distance_from = function ( base_lon, base_lat, target_lon, target_lat) {

  x=c(base_lon, base_lat)
  y=cbind( target_lon, target_lat )

  distm (x,y, fun = distHaversine) %>% as.numeric()

}

