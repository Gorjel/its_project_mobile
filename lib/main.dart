import 'package:flutter/material.dart';
import 'views/MapView.dart';
import 'widgets/rounded_button.dart';
import 'widgets/time_picker.dart';
import 'widgets/locationInput.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'widgets/createRouteButton.dart';
import 'data/place.dart';
import 'states/route_planner_state.dart';
import 'views/placesView.dart';


 
void main() => runApp(SmartTouristPlanner());

class SmartTouristPlanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SmartTouristPlanner();
  }
}

class _SmartTouristPlanner extends State<SmartTouristPlanner>{

  Location location = new Location();
  LocationData _currentLocation;

  List<Place> finalRounte;
  
  String mode;
  bool mapSelected;
  bool editSelected;
  bool routeSelected;

  Widget back_child;
  String darkMapStyle;
  
  @override
  void initState(){
    mode = "Map";
    mapSelected = true;
    editSelected = false;
    routeSelected = false;
    back_child = SizedBox(width : 10);
    rootBundle.loadString('assets/map_dark_style.json').then((string) {
    darkMapStyle = string;
    });
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    LocationData loc = await location.getLocation();
    setState((){
      _currentLocation = loc;
      back_child = MapView(currentLocation: _currentLocation, darkMapStyle: darkMapStyle,);
    });
  }

  void showMap(){
    setState(() {
    mode = "Map";
    mapSelected = true;
    editSelected = false;
    routeSelected = false;
    });
  }

  void editRoute(){
    setState(() {
      mode = "Edit";
      mapSelected = false;
      editSelected = true;
      routeSelected = false;
    });
  }

  void showPlaces(){
    setState(() {
      mode = "Route";
      mapSelected = false;
      editSelected = false;
      routeSelected = true; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart tourist planner',
      theme : ThemeData(fontFamily: 'ProximaNova',
        textTheme: TextTheme(
        headline: TextStyle(fontSize: 72.0, color : Colors.white),
        title: TextStyle(fontSize: 36.0, color : Colors.white),
        body1: TextStyle(fontSize: 14.0, color : Colors.white),
      ),),
      home: ChangeNotifierProvider<RoutePlannerState>(
        builder: (_) => RoutePlannerState(),
        child : Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF0e1626),
          elevation: 0.0,
          centerTitle: true,
          title: Row(
            children: <Widget>[
              RoundedButton(text : "Discover", onTap: showMap, selected: mapSelected,),
              RoundedButton(text : "Create", onTap: editRoute, selected: editSelected,),
              RoundedButton(text : "Check", onTap : showPlaces, selected: routeSelected)
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0e1626), const Color(0xFF023e58)],
                ),
              ),
            ),
            mode == "Map" ? back_child : SizedBox(width : 10),
            mode == "Route" ? PlacesView() : SizedBox(width : 10),
            mode == 'Edit' ? Container(padding: EdgeInsets.only(top : 60, left : 30, right : 30),
            child : Column(
              children: [
                LocationInput("Start location", _currentLocation),
                SizedBox(height: 15,),
                LocationInput("End location", _currentLocation),
                SizedBox(height: 15,),
                TimePicker("Arrival time  "),
                SizedBox(height: 15,),
                TimePicker("Departure time  "),
                SizedBox(height: 30,),
                CreateRouteButton(onTap: createRoute)
              ],
            )
          ) : SizedBox(width : 1),
        ],
        ),
        )
      ),
    );
  }
  void createRoute(){
    // print("got the start location " + _controllerStart.text);
    // int duration = calculateTimeDifference();
    // loadRouteData(58.37826, 26.732122, 58.3738, 26.7067, duration);
    setState(() {
    mode = "Map";
    mapSelected = true;
    editSelected = false;
    routeSelected = false;
    });

  }




}