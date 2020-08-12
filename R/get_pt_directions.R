get_pt_directions = function( lat1, lon1, lat2, lon2 ) {

  my_google_directions = addMemoization(google_directions)

  my_google_directions(origin = c(lat1, lon1),
                       destination = c(lat2, lon2),
                       departure_time = GLOBAL_BASE_DATE_TIME,
                       key = google_maps_geocode_api_key,
                       mode = "transit",
                       simplify = FALSE) %>%
  paste(collapse='')

}

