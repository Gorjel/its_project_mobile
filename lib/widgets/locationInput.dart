import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../states/route_planner_state.dart';





class LocationInput extends StatefulWidget {
  final String _text;
  final LocationData _currentLocation;
  LocationInput(this._text, this._currentLocation);
  List<String> suggestedPlaces;

  @override
  State createState() => _LocationInput(this._text, this._currentLocation);
  }

  class _LocationInput extends State<LocationInput>{
  _LocationInput(this._text, this._currentLocation);
  final String _text;
  final LocationData _currentLocation;
  List<String> suggestedPlaces;
  List<String> suggestedPlacesIds;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<RoutePlannerState>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: _controller,
              decoration: InputDecoration(
                hintText: _text,
                border : OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(20.0),
                  ),
                ),
                filled: true,
                fillColor : Colors.white
              )
            ), 
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              color : Colors.white.withOpacity(0.9),
              shape : RoundedRectangleBorder(borderRadius: BorderRadius.all(
                    const Radius.circular(20.0),
                  ),),
            ),         
            suggestionsCallback: (pattern) {
              loadLocation(pattern);
              return suggestedPlaces;
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              print('in update state');
              print(suggestedPlaces);
              print(suggestedPlacesIds);
              print(suggestion);
              print(suggestedPlaces.indexOf(suggestion));
              print('_______________');
              if (_text == 'Start location'){
                appState.setStartLocation(suggestedPlacesIds[suggestedPlaces.indexOf(suggestion)]);
                print('suggested start location id ${appState.startLocation}');
              }else{
                print("end location $suggestion");
                appState.setEndLocation(suggestedPlacesIds[suggestedPlaces.indexOf(suggestion)]);
                print('suggested end location id ${appState.endLocation}');
              }
              _controller.text = suggestion;
            },
            validator: (value){
              if (value.isEmpty) {
                return 'Please select location';
              }
            },
          )
        ],
      ),
    );
  }
  Future loadLocation(String pattern) async {
    String jsonString = await _getSuggestedPlaces(pattern);
    List<dynamic> places;
    List<dynamic> placesIds;
    Iterable jsonResponse = json.decode(jsonString);
    places = jsonResponse.map((i)=> i["name"].toString()).toList();
    placesIds = jsonResponse.map((i)=> i["id"].toString()).toList();
    setState(() {
      suggestedPlaces = places;
      suggestedPlacesIds = placesIds;
      print('In loadLocation');
      print(places);
      print(places.length);
      print(placesIds);
      print(placesIds.length);
      print('___________');
    });
  }

  
  Future<String> _getSuggestedPlaces(pattern) async {
    print('sending location suggestion request');
    double long = _currentLocation.longitude;
    double lat = _currentLocation.latitude;
    Map<String, String> headers = {"Content-type": "application/json"};
    String url;
    String json;
    if ((pattern != '') ){
      url = 'http://142.93.143.101:9000/api/v1/places/predictions';
      json = '{"title": "$pattern", "location": {"lat": $lat, "lng": $long}}';
    }else{
      url = 'http://142.93.143.101:9000/api/v1/places/transport-around';
      json = '{"location": {"lat": $lat, "lng": $long}, "radius" : 5000}';
    }
    Response response = await post(url, headers: headers, body: json);
    int statusCode = response.statusCode;
      String body = "";
      if (statusCode == 200){
        body = response.body;
      }else{
        print("Places prediction failed");
      }
    return body;
  }
}