import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/route_planner_state.dart';

class CreateRouteButton extends StatelessWidget {
  final VoidCallback onTap;

  const CreateRouteButton({Key key, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<RoutePlannerState>(context);

    Color backgroundColor = Colors.white;
    Color textColor = Colors.black;
    return InkWell(
      onTap: () async{
        await appState.loadRouteData();
        onTap();
        },
      child: new Container(
        height: 60.0,
        width: 200.0,
        decoration: new BoxDecoration(
          color: backgroundColor,
          borderRadius: new BorderRadius.circular(30.0),
        ),
        child: new Center(
          child: new Text(
            "Create Route",
            style: new TextStyle(fontSize: 18.0, color: textColor, fontWeight: FontWeight.w600,),
          ),
        ),
      ),
    );
  }

}