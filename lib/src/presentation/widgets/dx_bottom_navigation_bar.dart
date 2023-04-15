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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/home/home_screen.dart';

class DxBottomNavigationBar extends StatefulWidget {
  const DxBottomNavigationBar({
    Key? key,
    required this.onTabSelected,
    this.currentIndex = 0,
  }) : super(key: key);

  final ValueChanged<int> onTabSelected;
  final int currentIndex;

  @override
  State<DxBottomNavigationBar> createState() => _DxBottomNavigationBarState();
}

class _DxBottomNavigationBarState extends State<DxBottomNavigationBar> {
  List<IconData> get _tabs => [
        Icons.send,
        Icons.wifi,
        Icons.history,
        Icons.person_pin,
      ];

  int _selectedIndex = 0;

  @override
  void initState() {
    _selectedIndex = widget.currentIndex;
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      margin: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 14.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _tabs.length,
          (index) => InkWell(
            onTap: () {
              widget.onTabSelected(index);
              _onItemTapped(index);
            },
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _tabs[index],
                    color: _selectedIndex == index
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).disabledColor,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    BottomTabEnum.values[index].value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == index
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
