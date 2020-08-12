source('_drake.R')

file_name = "data/2016 census mesh block counts.xls"

df_mesh_detail %>%
  arrange( desc(AREA_ALBERS_SQKM ) ) %>%
  filter( AREA_ALBERS_SQKM > 0) %>%
  filter( Person > 0)



# area of x mesh block type within Y circle around mesh block
# driving travel time between centroids of the closest X type of mesh block






