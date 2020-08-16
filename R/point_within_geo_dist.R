if (FALSE) {

  source('_drake.R')

  readd(map_mesh) %>%
    head(20000) %>%
    { . } -> df_to_geo


  df_mesh_centroids %>%
    head(20) %>%
    { . } -> df_from_point

  id_point = 'MB_CODE16'
  from_point='geometry'
  id_geo = 'MB_CODE16'
  to_geo = 'geometry'
  max_dist=5000

  point_within_geo_dist( df_from_point, 'MB_CODE16', 'geometry', df_to_geo, 'MB_CODE16', 'geometry', 5000)



}

# find all to_geo's that intersect a max_dist circle around from_points
point_within_geo_dist <- function( df_from_point, id_point = 'MB_CODE16', from_point='point',
                                  df_to_geo, id_geo = 'MB_CODE16', to_geo = 'geometry',
                                  max_dist=5000) {

num_groups = future::availableCores()
future::plan(multicore, workers = num_groups)

df_from_point %>%
  mutate( group = (row_number()-1) %/% (n()/num_groups)) %>%
  group_by( group ) %>%
  nest() %>%
  mutate( results = future_map( data, ~do_one_point_within_geo_dist(.x, id_point , from_point, df_to_geo, id_geo , to_geo , max_dist)))  %>%
  ungroup() %>%
  select(results) %>%
  unnest(results)

}


  do_one_point_within_geo_dist <- function( df_from_point, id_point , from_point, df_to_geo, id_geo , to_geo , max_dist) {

    output_id = 'to'
  df_to_geo %>%
    mutate( s2_geo=s2_geog_from_wkb(st_as_binary( !!sym( to_geo )), check=FALSE)) %>%
    st_drop_geometry() %>%
    select( !!sym( id_geo ), s2_geo) %>%
    { . } -> df_to_geo_s2

  df_from_point  %>%
    mutate( s2_point=s2_geog_from_wkb(st_as_binary(!!sym(from_point)), check=FALSE)) %>%
    st_drop_geometry() %>%
    select( !!sym( id_point ), s2_point) %>%
    { . } -> df_from_point_s2

  df_from_point_s2 %>%
    mutate( to_row = map( s2_point, ~s2_dwithin_matrix( .x, df_to_geo_s2 %>%
                                                              pluck('s2_geo'),
                                                            max_dist))) %>%
    mutate( to_row = map(to_row, 1 )) %>%
    select(-s2_point) %>%
    mutate( !!output_id  := map( to_row, function(x) { df_to_geo_s2[ x, id_geo ] })) %>%
    select(-to_row) %>%
    unnest( !!output_id, names_sep='_'  ) %>%
    mutate( max_dist = max_dist)


}
