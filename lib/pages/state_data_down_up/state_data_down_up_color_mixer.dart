import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'color_circle.dart';
import 'color_value_changer.dart';
// The stateful widget
class ColorMixer extends StatefulWidget 
{
 const ColorMixer({super.key});
 @override
 State<ColorMixer> createState() => _ColorMixerState();
}
// The state class
class _ColorMixerState extends State<ColorMixer> 
{
 // These three variables are the 'state' of the widget
 int _redColor = 0;
 int _blueColor = 0;
 int _greenColor = 0;

 final Logger _logger = Logger();

 @override
  Widget build(BuildContext context) 
  {
    _logger.d('$_redColor $_greenColor $_blueColor');
    return Column
    (
      children: <Widget>
      [
        // This widget uses the variables (aka state)
        ColorCircle
        (
          color: Color.fromRGBO(_redColor, _greenColor, _blueColor, 1),
          radius: 100,
        ),
        // These three pass the _setColor function down so that
        // the state *here* can be changed at lower levels. This
        // is called "lifting state up".
        ColorValueChanger(property: "Red", value: _redColor, changeColorValue: _setColor),
        ColorValueChanger(property:"Green",value:_greenColor, changeColorValue:_setColor),
        ColorValueChanger(property: "Blue",value:_blueColor, changeColorValue: _setColor),
      ],
    ); 
  }
  void _setColor(String property, int value) 
  {
    setState
    (
      () 
      {
        _logger.d('property = $property value = $value');
        _redColor = (property == "Red") ? value : _redColor;
        _greenColor = (property == "Green") ? value : _greenColor;
        _blueColor = (property == "Blue") ? value : _blueColor;
      }
    ); 
  }
}