get_neighbours = function( df_hospitals ) {
  df_hospitals %>%
    select(id, long, lat ) %>%
    rename( lon = long ) %>%
    #  filter(id == 931 ) %>%
    mutate( directions = pmap(., generate_random_pt)) %>%
    unnest(directions) %>%
    unnest(directions) %>%
    { . } -> df_neighbours
  df_neighbours
}

