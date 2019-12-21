import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import '../states/route_planner_state.dart';


class TimePicker extends StatefulWidget {
  final String _text;
  TimePicker(this._text);

  @override
  State createState() => _TimePicker(this._text);
  }

  class _TimePicker extends State<TimePicker>{
    _TimePicker(this._text);
    final String _text;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<RoutePlannerState>(context);
    return Builder(
      builder: (context) =>  InkWell(
        onTap: () {
          DatePicker.showTimePicker(context,
              theme: DatePickerTheme(
                containerHeight: 200.0,
              ),
              showTitleActions: true, onConfirm: (time) {
            print('selected time $time');
            setState(() {
              if (_text == "Arrival time  "){
                appState.setStartTime('${time.hour}:${time.minute}');
              }else{
                appState.setEndTime('${time.hour}:${time.minute}');
              }
            });
          }, currentTime: DateTime.now(), locale: LocaleType.en);
        },
        child: Container(
                alignment: Alignment.center,
                height: 55,
                decoration: new BoxDecoration(
                              color: Colors.transparent,
                              border: new Border.all(color: Colors.white, width: 1.0),
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                size: 20.0,
                                color: Colors.teal,
                              ),
                              Text(
                                _text == "Arrival time  " ? "  " + appState.getStartTime() : "  " + appState.getEndTime(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20.0),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      _text,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0),
                    ),
                  ],
                ),
              ),
        )
      );
    }
  }