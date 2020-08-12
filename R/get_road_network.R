get_road_network = function( locale, transport = 'motorcar' ) {

bb = osmdata::getbb( locale )
net <- dodgr_streetnet(bb)
net <- weight_streetnet(net, wt_profile = transport)
net

}
