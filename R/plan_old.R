

the_plan_old <-
  drake_plan(

             ## Plan targets in here.
             #             df_hospitals = read_csv( 'data/hospital_locations.csv'),
             #             df_neighbours = get_neighbours( df_hospitals ),
             #             df_pt_segments = get_segments( df_neighbours ),
             #             df_pt_segments_small = df_pt_segments %>% select(-directions),
             #             df_gtfs_melbourne = load_gtfs(),
             #             df_covid_testing = read_csv('data/COVID19-Victorian-Testing-Clinics-Public-Spreadsheet - vic-covid-testing.csv'),
             #             df_covid_geo = revgeo_address( df_covid_testing) ,
             #             df_covid_closest_pt = closest_pt( df_gtfs_melbourne, df_covid_geo),
             #             df_pt_to_covid = closest_covid( df_gtfs_melbourne, df_covid_closest_pt),
             map_sa2 = read_sf("data/sa2/SA2_2016_AUST.shp"),
             map_remoteness = read_sf("data/remoteness/RA_2016_AUST.shp"),
             df_sa = read_excel("data/2033055001 - sa2 indexes.xls", sheet="Table 2", skip=5) %>%
               rename(SA2_MAIN16  = 1, IRSD_score = Score) %>%
               mutate( SA2_MAIN16  = as.character( SA2_MAIN16 ))  %>%
               select(SA2_MAIN16 , IRSD_score),
             df_hospitals_sa = categorise_points( readd( df_hospitals), 'long', 'lat', map_sa2, 'SA2_MAIN16'),
             df_hospitals_sa_joined = left_join( df_hospitals_sa, df_sa, by='SA2_MAIN16'),
             df_hospitals_sa_remote = categorise_points( df_hospitals_sa_joined , 'long', 'lat', map_remoteness, 'RA_CODE16'),

             df_segments_sa = categorise_points( readd( df_pt_segments_small) %>%
                                                select(-lon, -lat, -x, -y, -value),
                                              'target_lon', 'target_lat', map_sa2, 'SA2_MAIN16'),
             df_segments_sa_joined = left_join( df_segments_sa, df_sa, by='SA2_MAIN16'),
             df_segments_sa_remote = categorise_points( df_segments_sa_joined, 'target_lon', 'target_lat', map_remoteness, 'RA_CODE16'),
             df_final =df_segments_sa_remote %>% inner_join( df_hospitals_sa_remote, by='id', suffix=c('.remote','.hospital')),

             write_csv( df_final, 'data/remotes.csv' ),
             write_csv(df_hospitals_sa_remote, 'data/hospitals.csv' ),
             write_csv(df_hospitals_sa_remote %>% anti_join( df_segments_sa_remote, by='id') , 'data/hospitals_no_pt.csv' ),

             melbourne_net=get_road_network('melbourne au'),
             





             a=TRUE
  )

checkIfCorrect = function() {


  loadd( df_pt_segments_small)
  loadd( df_hospitals )
  loadd( df_pt_segments_small )
  loadd(  df_hospitals_sa )
  loadd(  df_hospitals_sa_joined )
  loadd(  df_hospitals_sa_remote )
  loadd(  df_segments_sa )
  loadd(  df_segments_sa_joined )
  loadd(  df_segments_sa_remote )
  loadd(  df_final )
  loadd(  df_sa )

  df_hospitals  %>%
    distinct(id) %>%
    count()
  df_hospitals  %>%
    distinct(id) %>%
    count()
  df_hospitals_sa  %>%
    distinct(id) %>%
    count()
  df_hospitals_sa_joined  %>%
    distinct(id) %>%
    count()
  df_hospitals_sa_remote  %>%
    distinct(id) %>%
    count()

  df_segments_sa  %>%
    distinct(id) %>%
    count()
  df_segments_sa_joined  %>%
    distinct(id) %>%
    count()
  df_segments_sa_remote  %>%
    distinct(id) %>%
    count()
  df_final  %>%
    distinct(id) %>%
    count()



  tocheck = 711

  df_hospitals  %>%
    filter( id==711)
  df_hospitals  %>%
    filter( id==711)
  df_hospitals_sa  %>%
    filter( id==711)
  df_hospitals_sa_joined  %>%
    filter( id==711)
  df_hospitals_sa_remote  %>%
    filter( id==711)

  df_segments_sa  %>%
    filter( id==711)
  df_segments_sa_joined  %>%
    filter( id==711)
  df_segments_sa_remote  %>%
    filter( id==711)

  df_final  %>%
    filter( id==711)

  df_segments_sa  %>%
    count()
  df_segments_sa_remote  %>%
    count()

  df_final %>%
    select( ends_with( 'hospital'), ends_with( 'remote') ) %>%
    count( IRSD_score.remote, sort=TRUE) %>%

    df_final  %>%
    count()

  df_hospitals_sa %>%
    anti_join( df_sa )

  df_hospitals_sa %>%
    anti_join( df_sa )

  df_segments_sa %>%
    anti_join( df_segments_sa_joined, by='id' )  %>%
    distinct(id) %>%
    inner_join( df_hospitals)  %>%
    select(id, hospital_name, state, long, lat, beds, suburb, description) %>%
    gt()

  df_pt_segments_small %>%
    anti_join( df_segments_sa_remote, by=c('id', 'target_lat', 'target_lon' ))

  df_segments_sa %>%
    anti_join( df_segments_sa_joined, by=c('id', 'target_lat', 'target_lon' ))  %>%

    df_segments_sa_remote %>%
    count( RA_CODE16, sort=TRUE)

  df_hospitals_sa_remote %>%
    count( RA_CODE16, sort=TRUE)



  df_segments_sa_remote %>%
    count( IRSD_score, sort=TRUE)

  df_hospitals_sa_remote %>%
    count( IRSD_score, sort=TRUE)

  df_segments_sa_remote %>%
    filter( is.na(IRSD_score))






}
