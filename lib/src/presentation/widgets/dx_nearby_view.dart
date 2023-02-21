/*
 * *
 *  * * MIT License
 *  * *******************************************************************************************
 *  *  * Created By Debojyoti Singha
 *  *  * Copyright (c) 2023.
 *  *  * Permission is hereby granted, free of charge, to any person obtaining a copy
 *  *  * of this software and associated documentation files (the "Software"), to deal
 *  *  * in the Software without restriction, including without limitation the rights
 *  *  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  *  * copies of the Software, and to permit persons to whom the Software is
 *  *  * furnished to do so, subject to the following conditions:
 *  *  *
 *  *  * The above copyright notice and this permission notice shall be included in all
 *  *  * copies or substantial portions of the Software.
 *  *  *
 *  *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  *  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  *  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  *  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  *  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  *  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  *  * SOFTWARE.
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
    ByteData byteData =
        await rootBundle.load(AssetsConstants.logoPng);
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
    Paint()
      ..color = const Color(0xFFC08C00)
      ..isAntiAlias = true,
    Paint()
      ..color = const Color(0xFFE94458)
      ..isAntiAlias = true
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
    drawAxis(value, canvas, 50, _planetPaints[0]);
    drawAxis(value1, canvas, 80, _planetPaints[1]);
    drawAxis(value2, canvas, 110, _planetPaints[2]);
    drawAxis(value1, canvas, 140, _planetPaints[3]);
    drawAxis(value, canvas, 170, _planetPaints[4]);
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
      try {
        var metric = extractPath.computeMetrics().first;
        final offset =
            metric.getTangentForOffset(metric.length)?.position;

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
    ..addOval(
        Rect.fromCircle(center: const Offset(0, 0), radius: radius));

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
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
