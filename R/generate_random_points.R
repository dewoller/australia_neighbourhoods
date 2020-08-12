base_lon=38
base_lat=38
max_distance = 1000
n_points=100

generate_random_points = function( base_lon, base_lat=38, max_distance = 10000, n_points=10, sample_method='hardcore',
                                  random_seed = floor( base_lon * base_lat * 10000)) {

  # for random point in the area -1...1, want to find latitude and longitude that matches these random points
  # base_lat + random *

 set.seed(random_seed)

 lat_factor = max_distance / m_per_lat()
 lon_factor = max_distance / m_per_lon( base_lat )

 if (sample_method=='hardcore') {
  beta <- n_points * 2; R = n_points / 2000
  win <- disc(1) # Unit square for simulation
  X1 <- rHardcore(beta, R, W = win) # Exact sampling -- beware it may run forever for some par.!
 } else {
   # use random sampler
 }

X1 %>%
  as_tibble() %>%
  mutate(
         target_lon = base_lon + (x * lon_factor),
         target_lat = base_lat + (y * lat_factor),
         dist = distance_from( base_lon, base_lat, target_lon, target_lat)
  ) %>%
  filter( dist < max_distance) %>%
  mutate(random=runif(n())) %>%
  arrange(random) %>%
  select(-random)
#  slice_sample( n=n_points )

# graph %>%
#  ggplot () + geom_histogram(aes( dist ))

#geom_point( aes( target_lon, target_lat))


}

