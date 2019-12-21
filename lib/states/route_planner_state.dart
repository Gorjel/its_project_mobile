
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import '../data/place.dart';
import '../data/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline/google_map_polyline.dart';






class RoutePlannerState with ChangeNotifier {
  RoutePlannerState();

  String startTime = 'Not set';
  String endTime = 'Not set';
  String startLocationName = '';
  String endLocationName = '';
  String startLocation = '';
  String endLocation = '';
  List<Place> finalRoute = List();
  List<String> finalRouteDinstances;

  Location selectedPoint;
  Location currentLocation;

  Set<Polyline> polylines = {};


  PolylinePoints polylinePoints = PolylinePoints();

  void SetCurrentLocation(double lat, double lng){
    currentLocation = Location(lat : lat, lng :lng);
  }

  void SetSelectedPoint(double lat, double lng){
    selectedPoint = Location(lat : lat, lng :lng);
  }

  getFinalRoute() => finalRoute;
  void addPlace(Place place){
    finalRoute.add(place);
  }
  void clearPlaces(){
    finalRoute.clear();
  }


  getStartTime() => startTime;
  getEndTime() => endTime;
  setStartTime(String time) => startTime = time;
  setEndTime(String time) => endTime = time;

  getStartLocation() => startTime;
  getEndLocation() => endTime;
  setStartLocation(String loc) => startLocation = loc;
  setEndLocation(String loc) => endLocation = loc;


  int calculateTimeDifference(){
    if (startTime != 'Not set' && endTime != 'Not set'){
      DateFormat dateFormat = new DateFormat.Hm();
      DateTime start = dateFormat.parse(startTime);
      DateTime end = dateFormat.parse(endTime);
      var timeDiff = (end.difference(start)).inSeconds;
      print("time difference : " + timeDiff.toString());
      return timeDiff;
    }else{
      return 0;
    }
  }

  Future loadRouteData() async {
    int duration = calculateTimeDifference();
    if (duration > 0 || (startLocation == '') || (endLocation == '')){
      try {
        String jsonString = await _getTheRoute(duration);
        Map<String, dynamic> jsonResponse = json.decode(jsonString);
        //print(jsonResponse.toString());
        Iterable routeResponse = jsonResponse["routes"][0]["places"];
        Iterable dinstanceResponse = jsonResponse["routes"][0]["segments"];
        finalRouteDinstances = dinstanceResponse.map((i)=> i["distance"].toString()).toList();
        finalRouteDinstances.insert(0, "0");
        List<Place> places = routeResponse.map((i)=>Place.fromJson(i)).toList();   
        finalRoute = places;
      } catch (e){
        print('ERROR: failed to route parse data' );
        startLocation = '';
        endLocation = '';
        startTime = 'Not set';
        endTime = 'Not set';
      }
    }else{
      print('route conditions are not acceptable');
      startLocation = '';
      endLocation = '';
      startTime = 'Not set';
      endTime = 'Not set';
      clearPlaces();
    }
  }

  Future<String> _getTheRoute(duration) async {
    String body = "";
    print("sending requets to Dinstance matrix");
    String url = 'http://142.93.143.101:9000/api/v1/routes';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"fromId": "$startLocation", "toId": "$endLocation", "maxRouteTime" : "$duration"}';
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    if (statusCode == 200){
      body = response.body;
    }else{
      print("Route request failed");
    }
    return body;
  }

  void setPolylines() async {
    GoogleMapPolyline googleMapPolyline = GoogleMapPolyline(apiKey:  "API_KEY");
    List<LatLng> polylineCoordinates = [];
    List<LatLng> result = await googleMapPolyline.getCoordinatesWithLocation(
          origin: LatLng(currentLocation.lat, currentLocation.lng),
          destination: LatLng(selectedPoint.lat, selectedPoint.lng),
          mode:  RouteMode.walking);
    if(result.isNotEmpty){
      result.forEach((LatLng point){
         polylineCoordinates.add(
            point);
    });
   }

  Polyline polyline = Polyline(
         polylineId: PolylineId("poly"),
         color: Color(0xFF98a5be),
         points: polylineCoordinates,
         width:5,
      );
    polylines = {polyline};
  }
}