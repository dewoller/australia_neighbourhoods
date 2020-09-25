source('_drake.R')


con <- RPostgreSQL::dbConnect(DBI::dbDriver("PostgreSQL"),
                              user="dewoller", password=db_password,
                              host="localhost", port=5432, dbname="postgis_db")

dbGetQuery(con, "
           ---
             select mb_code16, category_proportion
           from meshblock_statistics
           where distance=5000 and mb_category_name_2016='Parkland'
           ---
             " ) %>%
           as_tibble() %>%
           write_csv('output/meshblock_parklands.csv')

         dbGetQuery(con, "
                    ---
                      select mb_code16, category_proportion
                    from meshblock_statistics
                    where distance=5000 and mb_category_name_2016='Commercial'
                    ---
                      " ) %>%
                    as_tibble() %>%
                    write_csv('output/meshblock_commercial.csv')

dbGetQuery(con, "
           ---
             select mb_code16, person as population, areasqkm16, person / areasqkm16 as pp_per_sq_km
           from meshblock mb
           join meshblock_detail using (mb_code16)
           where areasqkm16 >0
           ---
             " ) %>%
           as_tibble() %>%
           write_csv('output/meshblock_population_density.csv')





