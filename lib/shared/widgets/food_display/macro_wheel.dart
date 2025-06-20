import 'package:flutter/material.dart';

class Macro {
  final String name;
  final double grams;
  final Color color;

  Macro({
    required this.name,
    required this.grams,
    required this.color,
  });
}

class MacroWheelPainter extends CustomPainter {
  final double radius;
  final List<Macro> macros;

  MacroWheelPainter({
    required this.radius,
    required this.macros
  });

  @override
  void paint(Canvas canvas, Size size) {
    List<double> angles = [];
    for (final macro in macros) {
      final angle = (macro.grams / macros.fold(0, (sum, m) => sum + m.grams)) * 2 * 3.141592653589793;
      angles.add(angle);
    }
    double startAngle = 0;
    for (int i = 0; i < macros.length; i++) {
      final macro = macros[i];
      final angle = angles[i];
      _drawSegment(canvas, size, macro.color, startAngle, angle, radius);
      startAngle += angle;
    }
  }

  void _drawSegment(Canvas canvas, Size size, Color color, double startAngle, double angle, double radius) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        angle,
        false,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MacroWheel extends StatelessWidget {
  final double proteinGrams;
  final double carbGrams;
  final double fatGrams;

  const MacroWheel({
    super.key,
    required this.proteinGrams,
    required this.carbGrams,
    required this.fatGrams,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          size: Size(200, 200),
          painter: MacroWheelPainter(
            radius: 100,
            macros: [
              Macro(name: 'Protein', grams: proteinGrams, color: Colors.blue),
              Macro(name: 'Carbs', grams: carbGrams, color: Colors.green),
              Macro(name: 'Fat', grams: fatGrams, color: Colors.red),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Protein', Colors.blue, proteinGrams),
        _buildLegendItem('Carbs', Colors.green, carbGrams),
        _buildLegendItem('Fat', Colors.red, fatGrams),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, double grams) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Text('$label: ${grams.toStringAsFixed(1)}g'),
      ],
    );
  }
}