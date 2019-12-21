import 'package:flutter/material.dart';
import '../data/place.dart';
import 'package:provider/provider.dart';
import '../states/route_planner_state.dart';

class PlacesView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<RoutePlannerState>(context);

    return Container(
        child: new Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
            child: ListView.builder(
              itemCount: appState.finalRoute.length,
              itemBuilder: _getItemUI,
              padding: EdgeInsets.all(0.0),
              )
            ));
  }

  Widget _getItemUI(BuildContext context, int index) {
    final appState = Provider.of<RoutePlannerState>(context);

    return new Card(
      child: new Column(
      children: <Widget>[
        new ListTile(
          leading: Text(
            appState.finalRoute[index].rating != 0 ? appState.finalRoute[index].rating.toString() : "",
            style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color : Colors.blue),
          ),
          title: new Text(
            appState.finalRoute[index].name,
            style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          subtitle: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(appState.finalRoute[index].category,
                    style: new TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.normal)),
                new Text('Minutes to walk: ${double.parse(appState.finalRouteDinstances[index])~/60}',
                    style: new TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.normal)),
              ]),

          onTap: () {
          },
        )
      ],
    ));
  }

}