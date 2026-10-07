import 'package:flutter/material.dart';
import 'package:virtual_home_demo/models/device.dart';
import 'package:virtual_home_demo/models/room.dart';

class RoomView extends StatelessWidget {
  const RoomView({
    super.key,
    required this.room,
    required this.devices,
    required this.brightness,
    required this.ambientColor,
    required this.blindPosition,
  });

  final Room room;
  final List<SmartDevice> devices;
  final double brightness;
  final Color ambientColor;
  final double blindPosition;

  @override
  Widget build(BuildContext context) {
    final lights = devices
        .where((device) => device.type == DeviceType.light)
        .toList();
    final lightBrightnesses = lights
        .map((light) => light.isOn ? light.brightness : 0.0)
        .toList();
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: RepaintBoundary(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: brightness),
          duration: const Duration(milliseconds: 1050),
          curve: Curves.easeInOutCubic,
          builder: (context, animatedBrightness, _) {
            return TweenAnimationBuilder<Color?>(
              tween: ColorTween(end: ambientColor),
              duration: const Duration(milliseconds: 1050),
              curve: Curves.easeInOutCubic,
              builder: (context, animatedColor, _) {
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: blindPosition),
                  duration: const Duration(milliseconds: 950),
                  curve: Curves.easeInOutCubic,
                  builder: (context, animatedBlind, _) {
                    return TweenAnimationBuilder<List<double>>(
                      tween: _LightBrightnessTween(
                        begin: lightBrightnesses,
                        end: lightBrightnesses,
                      ),
                      duration: const Duration(milliseconds: 520),
                      curve: Curves.easeOutCubic,
                      builder: (context, animatedLightBrightnesses, _) {
                        return CustomPaint(
                          painter: _RoomPainter(
                            room: room,
                            lights: lights,
                            lightBrightnesses: animatedLightBrightnesses,
                            brightness: animatedBrightness,
                            ambientColor: animatedColor ?? ambientColor,
                            blindPosition: animatedBlind,
                          ),
                          child: const SizedBox.expand(),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _RoomPainter extends CustomPainter {
  const _RoomPainter({
    required this.room,
    required this.lights,
    required this.lightBrightnesses,
    required this.brightness,
    required this.ambientColor,
    required this.blindPosition,
  });

  final Room room;
  final List<SmartDevice> lights;
  final List<double> lightBrightnesses;
  final double brightness;
  final Color ambientColor;
  final double blindPosition;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 1000, size.height / 700);

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 1000, 490),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFFCF4), Color(0xFFECE7DB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(const Rect.fromLTWH(0, 0, 1000, 490)),
    );
    final floor = Path()
      ..moveTo(0, 450)
      ..lineTo(1000, 450)
      ..lineTo(1000, 700)
      ..lineTo(0, 700)
      ..close();
    canvas.drawPath(
      floor,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFD7C8AF), Color(0xFFC3AF91)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(const Rect.fromLTWH(0, 450, 1000, 250)),
    );
    for (var i = 0; i < 11; i++) {
      canvas.drawLine(
        Offset(i * 100, 454),
        Offset(i * 100 - 42, 700),
        Paint()
          ..color = const Color(0xFF9A8162).withValues(alpha: 0.12)
          ..strokeWidth = 2,
      );
    }
    if (brightness > 0) {
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 1000, 700),
        Paint()
          ..blendMode = BlendMode.screen
          ..shader = RadialGradient(
            center: const Alignment(0, -0.12),
            radius: 1.12,
            colors: [
              ambientColor.withValues(alpha: brightness * 0.16),
              ambientColor.withValues(alpha: brightness * 0.06),
              ambientColor.withValues(alpha: 0),
            ],
            stops: const [0, 0.53, 1],
          ).createShader(const Rect.fromLTWH(0, 0, 1000, 700)),
      );
    }

    for (final (index, light) in lights.indexed) {
      final positions = switch (room.id) {
        'bedroom' => [Offset(330, 366), Offset(694, 411)],
        'kitchen' => [Offset(326, 370), Offset(694, 370)],
        _ => [Offset(312, 390), Offset(498, 340), Offset(744, 402)],
      };
      final position = positions[index % positions.length];
      _drawGlow(canvas, position, light.color, lightBrightnesses[index], index);
    }

    final windowRect = const Rect.fromLTWH(94, 112, 230, 224);
    canvas.drawRRect(
      RRect.fromRectAndRadius(windowRect, const Radius.circular(5)),
      Paint()..color = const Color(0xFFF4EFE2),
    );
    canvas.drawRect(
      Rect.fromLTWH(104, 122, 210, 204),
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFB5D4D1), Color(0xFFE8DBBC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(const Rect.fromLTWH(104, 122, 210, 204)),
    );
    canvas.drawRect(
      const Rect.fromLTWH(206, 122, 5, 204),
      Paint()..color = const Color(0xFFEDE5D8),
    );
    canvas.drawRect(
      const Rect.fromLTWH(104, 217, 210, 5),
      Paint()..color = const Color(0xFFEDE5D8),
    );
    _drawCloud(canvas, const Offset(150, 159));
    _drawCloud(canvas, const Offset(253, 182));

    final blindHeight = 204 * (1 - blindPosition);
    if (blindHeight > 0) {
      canvas.drawRect(
        Rect.fromLTWH(104, 122, 210, blindHeight),
        Paint()..color = const Color(0xFFDAD1C2),
      );
      for (var y = 130.0; y < 122 + blindHeight; y += 15) {
        canvas.drawLine(
          Offset(105, y),
          Offset(313, y),
          Paint()
            ..color = const Color(0xFFBAAE9D)
            ..strokeWidth = 2,
        );
      }
    }
    canvas.drawLine(
      const Offset(98, 338),
      const Offset(320, 338),
      Paint()
        ..color = const Color(0xFFD7D0C3)
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawRect(
      const Rect.fromLTWH(325, 118, 10, 312),
      Paint()..color = const Color(0xFFEBE2D5),
    );
    canvas.drawRect(
      const Rect.fromLTWH(325, 428, 38, 10),
      Paint()..color = const Color(0xFFB9AA96),
    );

    _drawWallDecor(canvas);
    switch (room.id) {
      case 'bedroom':
        _drawBedroom(canvas);
      case 'kitchen':
        _drawKitchen(canvas);
      default:
        _drawLivingRoom(canvas);
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(22, 20, 247, 42),
        const Radius.circular(21),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.68),
    );
    canvas.drawCircle(
      const Offset(47, 41),
      6,
      Paint()..color = const Color(0xFF478A68),
    );
    _drawText(
      canvas,
      'YOUR VIRTUAL ${room.name.toUpperCase()}',
      const Offset(62, 36),
      13,
      const Color(0xFF38382F),
      bold: true,
    );

    canvas.restore();
  }

  void _drawGlow(
    Canvas canvas,
    Offset center,
    Color color,
    double power,
    int index,
  ) {
    final radius = 145 + power * 170;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.44 * power),
            color.withValues(alpha: 0.16 * power),
            color.withValues(alpha: 0.035 * power),
            color.withValues(alpha: 0),
          ],
          stops: const [0, 0.26, 0.65, 1],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    final pendantCenter = Offset(center.dx, 99.0 + index * 12);
    canvas.drawLine(
      Offset(pendantCenter.dx, 68),
      pendantCenter,
      Paint()
        ..color = const Color(0xFF938775)
        ..strokeWidth = 3,
    );
    canvas.drawOval(
      Rect.fromCenter(center: pendantCenter, width: 58, height: 29),
      Paint()
        ..color = Color.lerp(const Color(0xFFF5F1E7), color, 0.4 * power)!
        ..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(pendantCenter.dx, pendantCenter.dy + 7),
        width: 34,
        height: 9,
      ),
      Paint()
        ..color = color.withValues(alpha: 0.88 * power)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
  }

  void _drawCloud(Canvas canvas, Offset center) {
    final cloud = Paint()..color = Colors.white.withValues(alpha: 0.73);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 61, height: 21),
      cloud,
    );
    canvas.drawCircle(center.translate(-11, -6), 13, cloud);
    canvas.drawCircle(center.translate(5, -8), 16, cloud);
    canvas.drawCircle(center.translate(18, -3), 10, cloud);
  }

  void _drawWallDecor(Canvas canvas) {
    for (final (rect, color) in <(Rect, Color)>[
      (const Rect.fromLTWH(414, 122, 115, 128), const Color(0xFFF1EADF)),
      (const Rect.fromLTWH(427, 135, 89, 102), const Color(0xFFB5C8B8)),
      (const Rect.fromLTWH(558, 140, 91, 105), const Color(0xFFF4E3CF)),
      (const Rect.fromLTWH(568, 151, 71, 84), const Color(0xFFCF9875)),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        Paint()..color = const Color(0xFFFAF6ED),
      );
      final inset = rect.deflate(9);
      canvas.drawRect(inset, Paint()..color = color);
      canvas.drawCircle(
        Offset(inset.center.dx, inset.top + inset.height * 0.42),
        18,
        Paint()..color = Colors.white.withValues(alpha: 0.21),
      );
    }
  }

  void _drawLivingRoom(Canvas canvas) {
    canvas.drawOval(
      const Rect.fromLTWH(224, 493, 554, 141),
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFE2D9C9), Color(0xFFD0C4B0)],
        ).createShader(const Rect.fromLTWH(224, 493, 554, 141)),
    );
    _plant(canvas, const Offset(841, 487), 0.8);

    final sofaShadow = Paint()
      ..color = const Color(0xFF796B59).withValues(alpha: 0.18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(341, 516, 381, 28),
        const Radius.circular(12),
      ),
      sofaShadow,
    );
    final sofa = Paint()..color = const Color(0xFF829087);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(285, 380, 480, 188),
        const Radius.circular(48),
      ),
      sofa,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(309, 361, 431, 106),
        const Radius.circular(32),
      ),
      Paint()..color = const Color(0xFFA7A994),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(315, 428, 435, 120),
        const Radius.circular(30),
      ),
      Paint()..color = const Color(0xFF92998B),
    );
    for (final (rect, color) in <(Rect, Color)>[
      (const Rect.fromLTWH(351, 386, 111, 116), const Color(0xFFE5D6BD)),
      (const Rect.fromLTWH(477, 379, 116, 117), const Color(0xFFC7B59A)),
      (const Rect.fromLTWH(613, 386, 98, 111), const Color(0xFFECE5D6)),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(26)),
        Paint()..color = color,
      );
      canvas.drawLine(
        rect.topLeft.translate(17, 23),
        rect.bottomLeft.translate(17, -16),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.23)
          ..strokeWidth = 3,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(247, 404, 66, 147),
        const Radius.circular(28),
      ),
      Paint()..color = const Color(0xFF757E73),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(737, 404, 65, 147),
        const Radius.circular(28),
      ),
      Paint()..color = const Color(0xFF757E73),
    );

    canvas.drawRect(
      const Rect.fromLTWH(315, 554, 13, 43),
      Paint()..color = const Color(0xFF7E6651),
    );
    canvas.drawRect(
      const Rect.fromLTWH(706, 554, 13, 43),
      Paint()..color = const Color(0xFF7E6651),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(376, 566, 295, 23),
        const Radius.circular(9),
      ),
      Paint()..color = const Color(0xFF9C7650),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(397, 549, 254, 26),
        const Radius.circular(12),
      ),
      Paint()..color = const Color(0xFFB48D62),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(422, 540, 198, 10),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFD7BE9A),
    );
    _plant(canvas, const Offset(191, 521), 0.66);
  }

  void _drawBedroom(Canvas canvas) {
    canvas.drawOval(
      const Rect.fromLTWH(238, 503, 548, 126),
      Paint()..color = const Color(0xFFBDAF98),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(323, 351, 432, 218),
        const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFF93785F),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(338, 392, 402, 177),
        const Radius.circular(16),
      ),
      Paint()..color = const Color(0xFFF2EDE2),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(357, 401, 159, 85),
        const Radius.circular(24),
      ),
      Paint()..color = const Color(0xFFDECDB2),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(533, 401, 183, 85),
        const Radius.circular(24),
      ),
      Paint()..color = const Color(0xFFDBD5C8),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(488, 454, 255, 116),
        const Radius.circular(16),
      ),
      Paint()..color = const Color(0xFFC7D0BF),
    );
    canvas.drawRect(
      const Rect.fromLTWH(337, 559, 16, 40),
      Paint()..color = const Color(0xFF755C43),
    );
    canvas.drawRect(
      const Rect.fromLTWH(720, 559, 16, 40),
      Paint()..color = const Color(0xFF755C43),
    );
    for (final x in [230.0, 781.0]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, 424, 93, 94),
          const Radius.circular(9),
        ),
        Paint()..color = const Color(0xFFB99063),
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 10, 412, 73, 18),
          const Radius.circular(7),
        ),
        Paint()..color = const Color(0xFFD0AC7F),
      );
    }
  }

  void _drawKitchen(Canvas canvas) {
    canvas.drawRect(
      const Rect.fromLTWH(387, 271, 392, 152),
      Paint()..color = const Color(0xFFE0DACD),
    );
    for (var i = 0; i < 4; i++) {
      final x = 397.0 + i * 95;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, 282, 86, 130),
          const Radius.circular(4),
        ),
        Paint()
          ..color = Color.lerp(
            const Color(0xFFEAE4D8),
            const Color(0xFFCFC9BB),
            (i % 2) * 0.32,
          )!,
      );
      canvas.drawLine(
        Offset(x + 68, 337),
        Offset(x + 76, 337),
        Paint()
          ..color = const Color(0xFF968876)
          ..strokeWidth = 4,
      );
    }
    canvas.drawRect(
      const Rect.fromLTWH(368, 412, 420, 21),
      Paint()..color = const Color(0xFF95816A),
    );
    canvas.drawRect(
      const Rect.fromLTWH(405, 434, 333, 113),
      Paint()..color = const Color(0xFFD4CABB),
    );
    canvas.drawRect(
      const Rect.fromLTWH(430, 436, 8, 105),
      Paint()..color = const Color(0xFFB8AF9F),
    );
    canvas.drawRect(
      const Rect.fromLTWH(703, 436, 8, 105),
      Paint()..color = const Color(0xFFB8AF9F),
    );
    canvas.drawOval(
      const Rect.fromLTWH(188, 431, 225, 52),
      Paint()..color = const Color(0xFF89775F),
    );
    canvas.drawRect(
      const Rect.fromLTWH(247, 451, 110, 108),
      Paint()..color = const Color(0xFFC8B89F),
    );
    canvas.drawRect(
      const Rect.fromLTWH(264, 456, 12, 96),
      Paint()..color = const Color(0xFFB0A28D),
    );
    canvas.drawRect(
      const Rect.fromLTWH(332, 456, 12, 96),
      Paint()..color = const Color(0xFFB0A28D),
    );
    _plant(canvas, const Offset(831, 482), 0.62);
  }

  void _plant(Canvas canvas, Offset base, double scale) {
    canvas.save();
    canvas.translate(base.dx, base.dy);
    canvas.scale(scale, scale);
    canvas.drawRect(
      const Rect.fromLTWH(-24, -77, 7, 91),
      Paint()..color = const Color(0xFF697554),
    );
    for (final leaf in <(double, double, double)>[
      (-40, -77, -32),
      (-12, -105, 29),
      (-47, -126, -3),
      (12, -137, 48),
      (-19, -163, 25),
      (-57, -106, -42),
    ]) {
      canvas.save();
      canvas.translate(-20, 0);
      canvas.rotate(leaf.$3 * 0.035);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(leaf.$1, leaf.$2),
          width: 42,
          height: 80,
        ),
        Paint()..color = const Color(0xFF6C8064),
      );
      canvas.restore();
    }
    canvas.drawPath(
      Path()
        ..moveTo(-40, -3)
        ..lineTo(0, -3)
        ..lineTo(-6, 49)
        ..quadraticBezierTo(-20, 56, -34, 49)
        ..close(),
      Paint()..color = const Color(0xFFB57D57),
    );
    canvas.restore();
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    double size,
    Color color, {
    bool bold = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          letterSpacing: 0.7,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _RoomPainter oldDelegate) {
    return oldDelegate.room != room ||
        oldDelegate.lights != lights ||
        oldDelegate.lightBrightnesses != lightBrightnesses ||
        oldDelegate.brightness != brightness ||
        oldDelegate.ambientColor != ambientColor ||
        oldDelegate.blindPosition != blindPosition;
  }
}

class _LightBrightnessTween extends Tween<List<double>> {
  _LightBrightnessTween({required super.begin, required super.end});

  @override
  List<double> lerp(double t) {
    final start = begin!;
    final finish = end!;
    return List<double>.generate(finish.length, (index) {
      final from = index < start.length ? start[index] : 0.0;
      return from + (finish[index] - from) * t;
    });
  }
}
