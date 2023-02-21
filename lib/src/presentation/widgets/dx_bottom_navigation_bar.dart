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
  State<DxBottomNavigationBar> createState() =>
      _DxBottomNavigationBarState();
}

class _DxBottomNavigationBarState
    extends State<DxBottomNavigationBar> {
  List<IconData> get _tabs => [
        Icons.send,
        Icons.wifi,
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
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: _selectedIndex == index
                              ? Theme.of(context)
                                  .colorScheme
                                  .secondary
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
