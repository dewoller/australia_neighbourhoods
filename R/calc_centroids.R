calc_centroids <- function( map_mesh) {

 # map_mesh  %>%
 #   st_transform( 3577) %>%
 #   st_centroid() %>%
 #   st_transform(., '+proj=longlat +ellps=GRS80 +no_defs')

target_crs = structure(list(input = "+proj=longlat +ellps=GRS80 +no_defs",
                 wkt = "GEOGCRS[\"unknown\",
    DATUM[\"Unknown based on GRS80 ellipsoid\",
        ELLIPSOID
                 [\"GRS 1980\",6378137,298.257222101,
            LENGTHUNIT[\"metre\",1],
            ID[\"EPSG\"
                  ,7019]]],
    PRIMEM[\"Greenwich\",0,
        ANGLEUNIT[\"degree\",0.0174532925199433],
ID[\"EPSG\",8901]],
    CS[ellipsoidal,2],
        AXIS[\"longitude\",east,
            ORDER[1] ,
            ANGLEUNIT[\"degree\",0.0174532925199433,
                ID[\"EPSG\",9122]]],
AXIS[\"latitude\",north,
            ORDER[2],
            ANGLEUNIT[\"degree\",0.01745329251
99433,
                ID[\"EPSG\",9122]]]]"), class = "crs")

  con <- RPostgreSQL::dbConnect(DBI::dbDriver("PostgreSQL"),
                                user="dewoller", password=db_password,
                                host="localhost", port=5432, dbname="postgis_db")


  st_read(con, query= "
          select m.mb_code16, mb_cat16, m.geom::geometry as geometry
          from meshblock_centroid m
          join meshblock using (mb_code16) 
          " ) %>%
          as_tibble() %>%
          { . } -> df_centroids

        dbDisconnect(con)

        df_centroids %>%
          filter( !st_is_empty( geometry)) %>%
          { . } -> df_centroids

        df_centroids

}
