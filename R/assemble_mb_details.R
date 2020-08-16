# find all meshblocks that intersect a circle of size radius around a set of points
# for later estimating population density, or amount of meshblock area of a certain type
#
# problem; some meshblocks are very big, so we cannot intersect the mb centroid
# we have to intersect the actual mesh block
# we don't want to intersect EVERY meshblock with our circle,
#
# so we use *geohashing* to determine if a meshblocks are adjacent
# and only intersect the adjacent meshblocks
# the problem is that we need to use geohashing of appropriate precision
# because geohash is calulated from mb centroid
# necessary precision is determined by the size of the *adjacent* meshblock
# e.g. if the adjacent meshblock is huge, then its' centroid is very far away
# we need large geohash quadrants to make sure that the neighbours of this large mb
# can 'see' this mb when considering their geohash

# algorithm
# create circles of radius_r around points

# initial_precision = 3
# while we still have points to consider
#   generate all neighbours of this point at this precision
#   calculate all mb overlaps at a certain precision
# retire all points that have reasonablly good coverage (pi * radius_r^2)
# increase precision, repeat





# measure = people km^2 of land.  Number of people, times size of land
# measure = people / km^2 of land ; number of people using this density of land
if ( FALSE ) {


df_mesh_centroids %>%
  head(20) %>%
  rename(lon=mc_lon, lat=mc_lat) %>%
  { . } -> df_from_points


df_mesh_centroids %>%
  rename(lon=mc_lon, lat=mc_lat) %>%
{ . } -> df_to_centroids
}

circle_mesh_overlap <- function( df_from_points, df_to_centroids, map_mesh, size=5) {


  precision=4

  df_gh=tibble()

  while ( precision <=10 ) {

    # calculate the geohash of each from point
    df_from_points %>%
      mutate( gh = gh_encode(lat, lon, precision=precision  ) ) %>%
    { . } -> df_from_gh

  # correspondence between the from points and  their neighbours their geohash neighbours
  df_gh  %>%
    select( starts_with('gh')  ) %>%
    distinct() %>%
    mutate(ghn = map(gh, gh_neighbours))%>%
    unnest( cols = ghn, names_sep='_') %>%
    pivot_longer(starts_with('ghn'), names_to=NULL, values_to ='gh_group') %>%
    { . } -> df_from_gh_neighbours

  # what is the geohash of the target
  df_to_centroids %>%
    mutate( gh = gh_encode(lat, lon, precision=precision  ) ) %>%
    { . } -> df_to_gh

  df_gh  %>%
    select( -starts_with('mc'), -starts_with('ghn')  ) %>%
    rename(gh_group = gh ) %>%
    rename( from_lat = lat, from_lon=lon) %>%
    st_as_sf( coords = c("from_lon", "from_lat"), crs = 4283) %>%
    st_transform(3577) %>%
    mutate( circle = st_buffer( geometry, dist = max_dist * 1000) ) %>%
    { . } -> df_from_mc


  }





  # what is the parkland geometry of each geohash neighbourhood
  map_mesh %>%  # for each parkland mesh block
    select( MB_CODE16, geometry) %>%
      inner_join(  df_gh  %>%
                 filter( MB_CATEGORY_NAME_2016=='Parkland') , by='MB_CODE16' ) %>%
  rename(gh_group = gh ) %>%
  select( gh_group, geometry  ) %>%
  inner_join( df_from_mc_neighbours, by='gh_group') %>%
  st_as_sf() %>%
  group_by(gh_group) %>%
  summarise(geometry = st_combine(geometry), .groups='drop') %>%
  as_Spatial() %>%
  clgeo_Clean() %>%
  st_as_sf() %>%
  st_transform( 3577) %>%
  #      data.frame() %>%
  #        as_tibble() %>%
  { . } -> df_to_parks


df_from_mc %>%
  st_drop_geometry() %>%
  select(-lga_name, -MB_CATEGORY_NAME_2016) %>%
  #      head(100) %>%
  group_by( gh_group ) %>%
  nest( data=c(MB_CODE16, circle )) %>%
  ungroup() %>%
  { . } -> df_pre_intersect


df_pre_intersect %>%
  inner_join( df_to_parks, by='gh_group' ) %>%
  #  head(2) %>%
  #  filter(gh_group=='r1px2' )  %>%
  rowwise()  %>%
  mutate(areas = calc_intersection( data, geometry, gh_group))  %>%
  ungroup() %>%
  { . } -> df_final

df_final

}



calc_intersection = function( circle, geometry, gh_group) {

  warning(gh_group)
  print(gh_group)

  st_geometry(geometry) %>%
    st_transform( 3577)  %>%
    as_Spatial() %>%
    gSimplify( tol = 0.00001) %>%
    gBuffer( byid=TRUE, width=0) %>%
    st_as_sf() %>%
    st_transform( 3577) %>%
    { . } -> a

  circle %>%
    st_as_sf() %>%
    st_intersection( a ) %>%
    mutate( area = st_area(circle)) %>%
    st_drop_geometry() %>%
    list()

}

