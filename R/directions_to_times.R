directions_to_times = function( json ) {


  json %>%
    str_replace(',\\W*"status" : "OK"','') %>%
    as.tbl_json() %>%
    enter_object('routes') %>%
    gather_array() %>%
    enter_object('legs') %>%
    gather_array() %>%
    gather_keys() %>%
    filter( str_detect( key, '_time$') ) %>%
    json_types() %>%
    enter_object('text') %>%
    rename(value = ..JSON ) %>%
    as_data_frame.tbl_json() %>%
    unnest(value) %>%
    select( key, value ) %>%
    mutate( value = GLOBAL_BASE_DATE + hm( value )) %>%
    pivot_wider( names_from='key', values_from=value) 
#    mutate( duration = arrival_time - departure_time )

}

