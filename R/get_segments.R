get_segments = function( df_neighbours) {

  df_neighbours %>%
    unnest(directions) %>%
    mutate( times = map( directions, directions_to_times )) %>%
    unnest(times) %>%
    mutate( segments = map( directions, directions_to_transit_details )) %>%
    unnest(segments) %>%
    { . } -> hospital_segments

  hospital_segments
}
