write_table <- function( df_mesh_centroids_sample) {

  con <- RPostgreSQL::dbConnect(DBI::dbDriver("PostgreSQL"),
                                user="dewoller", password=db_password,
                                host="alf", port=5432, dbname="postgis_db")

  df_mesh_centroids_sample %>%
    select(mb_code16) %>%
  copy_to( con, ., name='df_mesh_centroids_sample', temporary=FALSE, overwrite=TRUE, indexes=list('mb_code16') )


dbDisconnect(con)
NULL


}
