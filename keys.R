bing_maps_api_key = 'Ajv0meXkLI__MLC8MpgQ0qRnv3290pRTd8SGoDNbEq0YwRLNiCErPsW9Palk0NJ1'
google_maps_geocode_api_key = 'AIzaSyCFWhfDtdsSQRDDAN_wxd0NyTDDM_QPMuE'
graphhopper=Sys.setenv(GRAPHHOPPER='874bdba9-50cc-4754-a853-ac9496b98d64')

if (Xmisc::is.package.loaded(ggmap)) {
  ggmap::register_google( google_maps_geocode_api_key)
}
