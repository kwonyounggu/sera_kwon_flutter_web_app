import 'package:flutter/material.dart';
class ColorValueChanger extends StatefulWidget 
{
 // Value passed in from its host
  const ColorValueChanger
  (
    {
      required this.property,
      required this.value,
      required this.changeColorValue, 
      super.key
    }
  );
  final String property;
  final int value;
  final Function changeColorValue; //<-- Passed in!
  @override
  State<ColorValueChanger> createState() => _ColorValueChangerState();
}

class _ColorValueChangerState extends State<ColorValueChanger> 
{ 
  int _value = 0;
  @override
  Widget build(BuildContext context) 
  {
    _value = widget.value;
    return Column
    (
      children: <Widget>
      [
        Text(widget.property),
        Slider
        (
          min: 0, max: 255,
          value: _value.toDouble(),
          label: widget.property,
          onChanged: _onChanged,
        ) 
      ],
    ); 
  }
  void _onChanged(double value) 
  {
    setState(() => _value = value.round());
    // And this is where we call the setter function passed
    // in from the host (parent) widget.
    widget.changeColorValue(widget.property, value.round());
  }
}