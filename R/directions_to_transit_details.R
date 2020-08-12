directions_to_transit_details = function( json ) {

  json %>%
    str_replace(',\\W*"status" : "OK"','') %>%
    as.tbl_json() %>%
    enter_object('routes') %>%
    gather_array() %>%
    select(-array.index ) %>%
    enter_object('legs') %>%
    gather_array() %>%
    select(-array.index ) %>%
    enter_object('steps') %>%
    gather_array() %>%
    select(-array.index ) %>%
    spread_values(
                  duration = jnumber("duration", "value"),
                  distance = jnumber("distance", 'value'),
                  mode = jstring("travel_mode")
    ) %>%
    group_by(mode) %>%
    summarise( duration = sum(duration), distance=sum(distance), n_segments = n(), .groups='drop') %>%
    mutate( mode = str_to_lower(mode)) %>%
    pivot_wider( names_from = 'mode', values_from=c('duration','distance','n_segments') )


}

