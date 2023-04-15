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

import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_size/window_size.dart';

import 'src/data/constants/app_constants.dart';
import 'src/data/db/shared_pref.dart';
import 'src/domain/di/move_di.dart';
import 'src/domain/routes/app_routes.dart';
import 'src/domain/themes/color_constants.dart';
import 'src/presentation/screens/home/components/cubit/history/connect_history_cubit.dart';
import 'src/presentation/screens/home/components/cubit/receive/receive_fragment_cubit.dart';
import 'src/presentation/screens/home/components/cubit/send/send_fragment_cubit.dart';
import 'src/presentation/screens/home/cubit/home_cubit.dart';
import 'src/presentation/screens/home/home_screen.dart';
import 'src/presentation/screens/transfer/cubit/transfer_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle(AppConstants.appName);
    setWindowMinSize(const Size(800, 600));
    // setWindowMaxSize(const Size(1024, 768));
  }
  await SharedPref.init();
  MoveDI.init();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<HomeCubit>(
        create: (context) => HomeCubit(),
      ),
      BlocProvider<SendFragmentCubit>(
        create: (context) => SendFragmentCubit(),
      ),
      BlocProvider<ReceiveFragmentCubit>(
        create: (context) => ReceiveFragmentCubit(),
      ),
      BlocProvider<ConnectHistoryCubit>(
        create: (context) => ConnectHistoryCubit(),
      ),
      BlocProvider<TransferCubit>(
        create: (context) => TransferCubit(),
      ),
    ],
    child: BaseApp(),
  ));
}

class BaseApp extends StatelessWidget {
  BaseApp({super.key});

  final botToastBuilder = BotToastInit();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: () {
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          return const Size(1024, 768);
        } else {
          return const Size(360, 640);
        }
      }(),
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
              }),
            ).copyWith(
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
