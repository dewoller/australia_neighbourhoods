
generate_random_neighbours = function( lon, lat, id, max_distance = 5000, n_neighbours=10) {

  print(paste('id = ', id))

  df_random_points = generate_random_points(lon, lat, max_distance = max_distance )
  good_neighbours = 0
  i=1
  rv=data.frame()
  to_stop = FALSE

  while (good_neighbours < n_neighbours &&
         i<= nrow( df_random_points)  &&
         !to_stop
       ) {

    row = df_random_points[i,]
    has_error = FALSE

    address =
      tryCatch(
               revgeo( row$target_lon, row$target_lat,   provider = "google", API=google_maps_geocode_api_key, output="frame"),
               error = function(e) { has_error <<- TRUE}
      )

    if (has_error) {
      print( paste("revgeo error, id=",id   ))
      print(row)
    }

    if ( !has_error & str_length( address$housenumber) > 0 ) {
      rv = bind_rows( rv, address)
      good_neighbours = good_neighbours + 1
    }
    i=i+1

    if (good_neighbours ==0 && i>10) {
      to_stop = TRUE
    }

  }

 print(rv)
  rv

}

