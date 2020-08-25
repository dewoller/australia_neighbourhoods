if (FALSE) {

  source('_drake.R')

  readd(map_mesh) %>%
    #    head(2000) %>%
    { . } -> df_to_geo


  readd(df_mesh_centroids) %>%
  #  head(20) %>%
    { . } -> df_from_point

  id_point = 'MB_CODE16'
  from_point='geometry'
  id_geo = 'MB_CODE16'
  to_geo = 'geometry'
  max_dist=5000

  a= point_in_geo_trial1( df_from_point, 'MB_CODE16', 'geometry', df_to_geo, 'MB_CODE16', 'geometry', 5000)

  a %>%
    select(results) %>%
    mutate( error = map(results,2)) %>%
    mutate( results = map(results,1)) %>%
    unnest(col=results)

}


point_in_geo_trial1_test = function()
{
  tictoc::tic()
  a=point_in_geo_trial1( df_from_point, 'MB_CODE16', 'geometry', df_to_geo, 'MB_CODE16', 'geometry', 5000)
  tictoc::toc()

  a

}

# find all to_geo's that intersect a max_dist circle around from_points
point_in_geo_trial1 <- function( df_from_point, id_point = 'MB_CODE16', from_point='point',
                                df_to_geo, id_geo = 'MB_CODE16', to_geo = 'geometry',
                                max_dist=5000) {


  num_groups = 1
  size_group=20



  df_to_geo %>%
    mutate( s2_geo=s2_geog_from_wkb(st_as_binary( !!sym( to_geo )), check=FALSE)) %>%
    st_drop_geometry() %>%
    select( !!sym( id_geo ), s2_geo) %>%
    { . } -> df_to_geo_s2

  #  safe_do_one_point = safely( try_do_one_point_within_geo, otherwise=list())

  #browser()
  df_from_point %>%
    mutate( partition = (row_number()-1) %/% (size_group)) %>%
    group_by( partition ) %>%
    nest() %>%
    #    partition(cluster) %>%
    mutate( results = map( data, ~point_in_geo_trial1_1(.x, id_point , from_point, df_to_geo_s2, id_geo , to_geo , max_dist)))  %>%
    #    collect() %>%
    ungroup() #%>%
  #   select(results) %>%
  #   mutate( error = map(results,2)) %>%
  #   mutate( results = map(results,1)) %>%
  #   unnest(col=results)

}



point_in_geo_trial1_1 <- function( df_from_point, id_point , from_point, df_to_geo_s2, id_geo , to_geo , max_dist) {

  output_id = 'to'
  tictoc::tic()
  df_from_point  %>%
    mutate( s2_point=s2_geog_from_wkb(st_as_binary(!!sym(from_point)), check=FALSE)) %>%
    st_drop_geometry() %>%
    select( !!sym( id_point ), s2_point) %>%
    { . } -> df_from_point_s2

  #  browser()

  df_from_point_s2 %>%
    mutate( to_row = map( s2_point, ~s2_dwithin_matrix( .x, df_to_geo_s2 %>%
                                                       pluck('s2_geo'),
                                                     max_dist))) %>%
  mutate( to_row = map(to_row, 1 )) %>%
  select(-s2_point) %>%
  mutate( !!output_id  := map( to_row, function(x) { df_to_geo_s2[ x, id_geo ] })) %>%
  select(-to_row) %>%
  unnest( !!output_id, names_sep='_'  ) %>%
  mutate( max_dist = max_dist) %>%
  { . } -> df_out
  tictoc::toc()

  write_csv(df_out, 'output.csv', append=TRUE)
  df_out


}
