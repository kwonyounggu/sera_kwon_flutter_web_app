import 'package:flutter/material.dart';
//import 'package:logger/logger.dart';

class ColorCircle extends StatelessWidget
{
    const ColorCircle({required this.color, required this.radius, super.key});

    final Color color;
    final int radius;

    //final Logger _logger = Logger();
    @override
    Widget build(BuildContext context) 
    {
      //_logger.d('color = $color');
      return Center
      (
          child: CustomPaint
          (
              size: Size(radius*2, radius*2),
              painter: CirclePainter(color),
          ),
      );
    }
}

class CirclePainter extends CustomPainter 
{
  Color? _color;
  CirclePainter(Color color)
  {
    _color = color;
  }
  
  @override
  void paint(Canvas canvas, Size size) 
  {
    final paint = Paint();
      paint.color = _color!; // Circle color
      paint.style = PaintingStyle.fill; // Fill style

    final center = Offset(size.width / 2, size.height / 2); // Center of the canvas
    final radius = size.width / 2; // Radius of the circle

    canvas.drawCircle(center, radius, paint); // Draw the circle
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // No need to repaint
  }
}
