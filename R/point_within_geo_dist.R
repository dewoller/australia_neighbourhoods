if (FALSE) {

  source('_drake.R')

  loadd(map_mesh)

read_table('
  mb_code16
  20300752000
  20301030000
  20354450000
  20354520000
  20608400000
  20608410000
  20608660000
  20631915840
  20631915850
  20631941300
  20631946960
  20631958480
  20631958490
  20631967000
  20631967010
  20631967020
  20631967030
  20631967160
  20631995920
  20631999610
  20632000610
  20632003050
  20632003770
  ') %>%
  mutate( mb_code16=as.character(mb_code16)) %>%
  { . } -> target

  map_mesh %>%
    select(mb_code16, geometry, mb_cat16) %>%
    inner_join(target) %>%
    { . } -> df_to_geo


  loadd(df_mesh_centroids)

    df_mesh_centroids %>%
    filter( !st_is_empty( geometry)) %>%
    filter( mb_code16 == '20632003050') %>%
    select(-mb_cat16) %>%
    { . } -> df_from_point

  max_dist=5000

 a= point_within_geo_dist( df_from_point, 'MB_CODE16', 'geometry', df_to_geo, 'MB_CODE16', 'geometry', 5000)


}


point_within_geo_dist_test = function()
{
  point_within_geo_dist( df_from_point,  df_to_geo, 5000)


}

# find all to_geo's that intersect a max_dist circle around from_points
point_within_geo_dist <- function( df_from_point, df_to_geo, max_dist=5000) {

  print(max_dist)
  df_from_point %>%
    st_as_sf( ) %>%
    st_transform('+init=EPSG:3577') %>%
    st_buffer(  max_dist ) %>%
    st_intersection(  df_to_geo %>%
                    select(mb_code16, mb_cat16, geometry) %>%
                    st_transform( '+init=EPSG:3577'  )) %>%
    mutate(intersection_area = st_area(geometry) %>% as.numeric(),
           distance=max_dist) %>%
    st_drop_geometry() %>%
    as_tibble()

}
