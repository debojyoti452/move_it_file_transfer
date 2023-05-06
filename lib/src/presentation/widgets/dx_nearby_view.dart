/*
 * *
 *  * * GNU General Public License v3.0
 *  * *******************************************************************************************
 *  *  * Created By Debojyoti Singha
 *  *  * Copyright (c) 2023.
 *  *  * This program is free software: you can redistribute it and/or modify
 *  *  * it under the terms of the GNU General Public License as published by
 *  *  * the Free Software Foundation, either version 3 of the License, or
 *  *  * (at your option) any later version.
 *  *  *
 *  *  * This program is distributed in the hope that it will be useful,
 *  *  *
 *  *  * but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  *  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  *  * GNU General Public License for more details.
 *  *  *
 *  *  * You should have received a copy of the GNU General Public License
 *  *  * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *  *  * Contact Email: support@swingtechnologies.in
 *  * ******************************************************************************************
 *
 */

import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/constants/assets_constants.dart';
import '../../domain/themes/color_constants.dart';

class DxNearbyView extends StatefulWidget {
  const DxNearbyView({Key? key}) : super(key: key);

  @override
  _DxNearbyViewState createState() => _DxNearbyViewState();
}

class _DxNearbyViewState extends State<DxNearbyView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _controller1;
  late AnimationController _controller2;

  Future<ui.Image> _loadImage() async {
    ByteData byteData = await rootBundle.load(AssetsConstants.logoPng);
    final Uint8List bytes = Uint8List.view(byteData.buffer);
    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetHeight: 54,
      targetWidth: 54,
      allowUpscaling: true,
    );
    final ui.Image image = (await codec.getNextFrame()).image;
    return image;
  }

  void initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _controller.repeat(reverse: false);
    _controller1.repeat(reverse: false);
    _controller2.repeat(reverse: false);
  }

  @override
  initState() {
    super.initState();
    initializeAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _loadImage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Center(
                  child: CustomPaint(
                    painter: _DxNearbyViewPainter(
                      image: snapshot.requireData,
                      value: _controller.value,
                      value1: _controller1.value,
                      value2: _controller2.value,
                    ),
                  ),
                );
              });
        } else {
          return const CircularProgressIndicator(
            color: ColorConstants.BLACK,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}

class _DxNearbyViewPainter extends CustomPainter {
  final ui.Image image;
  final double value, value1, value2;

  final Paint _axisPaint = Paint()
    ..color = ColorConstants.GREY_DARK
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true;

  final List<Paint> _planetPaints = [
    Paint()
      ..color = const Color(0xFF0C65FF)
      ..isAntiAlias = true,
    Paint()
      ..color = const Color(0xFF6AFFC2)
      ..isAntiAlias = true,
    Paint()
      ..color = const Color(0xFFAC7FFF)
      ..isAntiAlias = true,
  ];

  _DxNearbyViewPainter({
    required this.image,
    this.value = 0,
    this.value1 = 0,
    this.value2 = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(
      image,
      Offset(size.width / 2 - 27, size.height / 2 - 27),
      Paint()..isAntiAlias = true,
    );
    drawAxis(value, canvas, 55, _planetPaints[0]);
    drawAxis(value1, canvas, 85, _planetPaints[1]);
    drawAxis(value2, canvas, 115, _planetPaints[2]);
  }

  drawAxis(
    double value,
    Canvas canvas,
    double radius,
    Paint paint,
  ) {
    final maskedPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        10,
      );
    var firstAxis = getCirclePath(radius);
    canvas.drawPath(firstAxis, _axisPaint);
    ui.PathMetrics pathMetrics = firstAxis.computeMetrics();
    for (ui.PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * value,
      );
      if (extractPath.getBounds().isEmpty) return;
      try {
        var metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)?.position;

        if (offset == null) return;

        canvas.drawCircle(
          offset,
          10,
          maskedPaint,
        );

        canvas.drawCircle(offset, 5.2, paint);
      } catch (e) {
        log(e.toString());
      }
    }
  }

  Path getCirclePath(double radius) => Path()
    ..addOval(Rect.fromCircle(center: const Offset(0, 0), radius: radius));

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is _DxNearbyViewPainter) {
      return oldDelegate.value != value;
    }
    return false;
  }

  void drawCircles(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = ColorConstants.GREY_DARK;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    for (int i = 0; i <= 4; i++) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        30.0 * (i),
        paint,
      );
    }

    /// add image in the center of the circle
    canvas.drawImage(
      image,
      Offset(size.width / 2 - 27, size.height / 2 - 27),
      Paint(),
    );
  }
}
