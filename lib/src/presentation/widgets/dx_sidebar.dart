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

import 'package:dart_std/dart_std.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/model/client_model.dart';
import '../../domain/themes/color_constants.dart';
import '../screens/home/home_screen.dart';

class DxSidebar extends StatefulWidget {
  const DxSidebar({
    Key? key,
    required this.userModel,
    required this.onTabSelected,
  }) : super(key: key);

  final Function(int) onTabSelected;
  final ClientModel userModel;

  @override
  _DxSidebarState createState() => _DxSidebarState();
}

class _DxSidebarState extends State<DxSidebar> {
  List<IconData> get _tabs => [
        Icons.send,
        Icons.wifi,
        Icons.history,
        Icons.person_pin,
      ];

  int selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: Text(
                'Name: ${widget.userModel.clientName ?? 'No-Name'}',
                style: TextStyle(
                  color: ColorConstants.PRIMARY_BLUE,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 12.w,
                bottom: 16.h,
              ),
              child: Text(
                widget.userModel.platform ?? 'No-Name',
                style: TextStyle(
                  color: ColorConstants.PRIMARY_BLUE,
                  fontSize: 16.sp,
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: BottomTabEnum.values.length,
              itemBuilder: (context, index) {
                var tab = BottomTabEnum.values[index];
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: ListTile(
                    title: Text(
                      tab.name.firstLetterCapitalize(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: selectedIndex == index
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).disabledColor,
                          ),
                    ),
                    leading: Icon(
                      _tabs[index],
                      size: 24.r,
                      color: selectedIndex == index
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).disabledColor,
                    ),
                    onTap: () {
                      widget.onTabSelected(index);
                      _onTabSelected(index);
                    },
                  ),
                );
              },
            ))
          ],
        ));
  }
}
