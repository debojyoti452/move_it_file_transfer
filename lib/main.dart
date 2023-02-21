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

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'src/data/constants/app_constants.dart';
import 'src/domain/routes/app_routes.dart';
import 'src/domain/themes/color_constants.dart';
import 'src/presentation/screens/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BaseApp());
}

class BaseApp extends StatelessWidget {
  BaseApp({super.key});

  final botToastBuilder = BotToastInit();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: AppConstants.appName,
          theme: ThemeData(
            primaryColor: const Color(0xff000000),
            textTheme: GoogleFonts.montserratTextTheme(),
            primaryTextTheme: GoogleFonts.montserratTextTheme(),
            primaryIconTheme: const IconThemeData(
              color: ColorConstants.PRIMARY_TEXT,
            ),
            iconTheme: const IconThemeData(
              color: ColorConstants.PRIMARY_TEXT,
            ),
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: const MaterialColor(4280395775, {
              50: Color(0xfff2f2f2),
              100: Color(0xffe6e6e6),
              200: Color(0xffcccccc),
              300: Color(0xffb3b3b3),
              400: Color(0xff999999),
              500: Color(0xff808080),
              600: Color(0xff666666),
              700: Color(0xff4d4d4d),
              800: Color(0xff333333),
              900: Color(0xff1a1a1a)
            })).copyWith(
              secondary: ColorConstants.PRIMARY_BLUE,
            ),
          ),
          onGenerateRoute: AppRoutes.onGenerateRoute,
          builder: (context, children) {
            children = botToastBuilder(context, children);
            return children;
          },
          navigatorObservers: [BotToastNavigatorObserver()],
          home: child,
        );
      },
      child: const HomeScreen(),
    );
  }
}
