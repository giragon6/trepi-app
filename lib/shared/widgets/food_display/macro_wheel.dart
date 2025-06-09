// import 'package:flutter/material.dart';

// class MacroWheelPainter extends CustomPainter {
//   final double angle;
//   final double radius;
//   final Color color;

//   MacroWheelPainter({
//     required this.angle,
//     required this.radius,
//     required this.color,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     canvas.drawCircle(center, radius, paint);

//     final startAngle = -angle / 2;
//     final sweepAngle = angle;

//     canvas.drawArc(
//       Rect.fromCircle(center: center, radius: radius),
//       startAngle,
//       sweepAngle,
//       true,
//       paint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// class MacroWheel extends StatelessWidget {
//   final double proteinGrams;
//   final double carbGrams;
//   final double fatGrams;

//   const MacroWheel({
//     super.key,
//     required this.proteinGrams,
//     required this.carbGrams,
//     required this.fatGrams,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return MacroWheelPainter(angle: angle, radius: radius, color: color)
//   }

//   Widget _buildLegend() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildLegendItem('Protein', Colors.blue, proteinGrams),
//         _buildLegendItem('Carbs', Colors.green, carbGrams),
//         _buildLegendItem('Fat', Colors.red, fatGrams),
//       ],
//     );
//   }

//   Widget _buildLegendItem(String label, Color color, double grams) {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           color: color,
//         ),
//         const SizedBox(width: 8),
//         Text('$label: ${grams.toStringAsFixed(1)}g'),
//       ],
//     );
//   }
// }