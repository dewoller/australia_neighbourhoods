
generate_random_pt = function( lon, lat, id, max_distance = 5000, n_neighbours=10) {

#  browser()
#  my_revgeo  = addMemoization(revgeo)
  print(paste('id = ', id))

  df_random_points = generate_random_points(lon, lat, max_distance = max_distance )
  good_neighbours = 0
  i=1
  rv=data.frame()

  while (good_neighbours < n_neighbours &&
         i<= nrow( df_random_points)  &&
         !(good_neighbours ==0 && i>10)  # shortcut stop
       ) {

    row = df_random_points[i,]
    has_error = FALSE
    directions = get_pt_directions( lon1 = lon, lat1 = lat,  lon2=row$target_lon, lat2=row$target_lat   )

    if (has_error) {
      print( paste("PT directions error, id=",id   ))
      print(row)
    }

    if ( !has_error && !str_detect(directions, 'ZERO_RESULTS"\\}$') ) {
      json_row = tibble( directions = directions)
      rv = bind_rows( rv, bind_cols( row, json_row) )
      good_neighbours = good_neighbours + 1
    }
    i=i+1

  }

  print(paste( 'results = ',nrow(rv)))
  rv

}

