import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/place.dart';
import 'package:provider/provider.dart';
import '../states/route_planner_state.dart';


class MapView extends StatefulWidget {
  final currentLocation;
  final darkMapStyle;
  const MapView({Key key, this.currentLocation, this.darkMapStyle})
      : super(key: key);

  @override
  State<MapView> createState() {
    return _MapView(this.currentLocation, this.darkMapStyle);
  }
}

class _MapView extends State<MapView> {
  _MapView(this.currentLocation, this.darkMapStyle);
  Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation;
  String darkMapStyle;
  BitmapDescriptor curLocIcon;

  Set<Polyline> polylines = {};


  @override
  void initState(){
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(1, 1)), 'assets/cur_location_icon.png')
        .then((onValue) {
      curLocIcon = onValue;
    });
    super.initState();
  }

  Set<Marker> _createMarker(context) {
    final appState = Provider.of<RoutePlannerState>(context);
    appState.SetCurrentLocation(currentLocation.latitude, currentLocation.longitude);
    List<Marker> markers = List();
    markers.add(Marker(
    markerId: MarkerId("CurrentLocation"),
    position : LatLng(currentLocation == null ? 0 : currentLocation.latitude, currentLocation == null ? 0 : currentLocation.longitude),
    icon : BitmapDescriptor.fromAsset("assets/red_dot_icon.png"),));
    if (appState.finalRoute.length > 2){
      for( var i = 0 ; i < appState.finalRoute.length; i++ ){
        var place = appState.finalRoute[i];
        BitmapDescriptor customIcon;
        if (i == 0){
          customIcon = BitmapDescriptor.fromAsset("assets/start_icon.png");
        }else if (i == appState.finalRoute.length - 1){
          customIcon = BitmapDescriptor.fromAsset("assets/finish_icon.png");
        }else{
          customIcon = BitmapDescriptor.fromAsset("assets/$i.png");
        }
        markers.add(Marker(markerId: MarkerId(place.name), 
          position : LatLng(place.location.lat,place.location.lng,),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: (place.duration_from_previous~/60).toString(),
          ),
          onTap: () async{
            appState.SetSelectedPoint(place.location.lat,place.location.lng);
            await appState.setPolylines();
            setState(() {
              polylines = appState.polylines;
            });

          },
          icon : customIcon));
      }
    }
    return markers.toSet();
  }

  Widget mapWidget(context){
    return  GoogleMap(
      myLocationButtonEnabled : false,
      markers: _createMarker(context),
      polylines: polylines,
      initialCameraPosition: CameraPosition(target: LatLng(currentLocation == null ? 0 : currentLocation.latitude, currentLocation == null ? 0 : currentLocation.longitude), zoom: 15,),
      mapType: MapType.normal,
      onMapCreated: (GoogleMapController controller) {
        controller.setMapStyle(darkMapStyle);
        _controller.complete(controller);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0e1626), const Color(0xFF023e58)],
        ),
      ),
      child : mapWidget(context)
    );
  }
}
