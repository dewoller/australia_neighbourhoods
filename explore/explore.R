source('_drake.R')

file_name = "data/2016 census mesh block counts.xls"

df_mesh_detail %>%
  arrange( desc(AREA_ALBERS_SQKM ) ) %>%
  filter( AREA_ALBERS_SQKM > 0) %>%
  filter( Person > 0)



# area of x mesh block type within Y circle around mesh block
# driving travel time between centroids of the closest X type of mesh block


install.packages('rmapshaper')

install.packages('geojson')

check_sys_mapshaper()

devtools::install_github("ironholds/geohash")

library(sf)
library(s2)
library(tmap)
library(rmapshaper)

sessionInfo() -> a

map_mesh %>%
  head(2000) %>%
  mutate( s2=s2_geog_from_wkb(st_as_binary(geometry), check=FALSE)) %>%
  st_drop_geometry() %>%
{ . } -> a

  a  %>%
    mutate( centroid = s2_centroid( s2)) %>% 
    { . } -> b


  _centroid() %>%
  st_transform(., '+proj=longlat +ellps=GRS80 +no_defs') %>% # we want the centroids in a second geometry col
  st_coordinates() %>%
    as_tibble() %>%
    set_names('mc_lon','mc_lat') %>%
    mutate( MB_CODE16 = map_mesh %>% pluck( 'MB_CODE16' )),

  s2_dwithin_matrix( b$centroid, a$s2, 5000) -> d

s2_dwithin_matrix( a$s2, b$centroid, 5000) -> e

a[e[[1]],]$MB_CODE16

e[[1]]

map(a, e[[1]], 'MB_CODE_16' )

f=e[[1]]

a %>% 
  select(MB_CODE16) %>%
  mutate( coor = map( e, ~slice(a, .x))) %>% 
  { . } -> j

map_dfr(a, 'MB_CODE_16') 

sapply( d, length) %>% mean


# get mesh shapefiles for all mesh blocks in Australia
                 dir_ls('data/meshblocks', regexp='.*shp') %>%
                   map( ~read_s2(.x)) %>%
                   bind_rows() ->a


readd(map_mesh) %>%
  select(geometry) %>%
  head(1) %>% 
  dput() %>% 

  a  %>%
  head(1) %>%
  mutate( point = s2_centroid( geometry)) %>%


  read_sf( 'data/meshblocks/MB_2016_ACT.shp') %>%
  head(1) %>%
  mutate( s2=s2_geog_from_wkb(st_as_binary(geometry), check=FALSE)) %>%
  select(geometry, s2) %>%
  st_drop_geometry() %>%
  rename( geometry=s2)



  structure(list(geometry = structure(list(<pointer: (nil)>), class = c("s2_geography",
                                                                        "s2_xptr"))), row.names = c(NA, -1L), class = c("tbl_df", "tbl",
                 "data.frame"))

  mutate( point = s2_centroid( geometry)) %>%
  { . } -> df_from_point_s2






