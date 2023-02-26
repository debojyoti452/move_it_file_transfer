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
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../data/constants/assets_constants.dart';
import '../../../../../domain/global/base_state_wrapper.dart';
import '../../../../../domain/themes/color_constants.dart';
import '../../../../../domain/utils/helper.dart';
import '../cubit/receive/receive_fragment_cubit.dart';

class ReceiveFragment extends StatefulWidget {
  static const String id = 'RECEIVE_FRAGMENT';

  const ReceiveFragment({Key? key}) : super(key: key);

  @override
  State<ReceiveFragment> createState() => _ReceiveFragmentState();
}

class _ReceiveFragmentState
    extends BaseStateWrapper<ReceiveFragment> {
  late ReceiveFragmentCubit _cubit;

  @override
  void onInit() {
    _cubit = context.read<ReceiveFragmentCubit>();
    _cubit.initialize();
  }

  @override
  Widget onBuild(
    BuildContext context,
    Constraints constraints,
    PlatformType platform,
  ) {
    return BlocConsumer<ReceiveFragmentCubit, ReceiveFragmentState>(
      bloc: _cubit,
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 14.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      text: 'See devices in your radar nearby\n',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            color: ColorConstants.BLACK,
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                        TextSpan(
                          text:
                              'Make sure all devices are in same WiFi\n',
                          style:
                              Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text:
                              'Name: ${state.userModel.clientName ?? ''}\n',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: ColorConstants.PRIMARY_BLUE,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                SvgPicture.asset(
                  AssetsConstants.logo,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 8.w,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Request List',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.refresh,
                          color: ColorConstants.BLACK,
                        ),
                      ),
                    ],
                  ),
                ),
                _requestedListWidget(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _requestedListWidget(ReceiveFragmentState state) {
    if (state.requestList.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Text(
          'No request found',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.requestList.length,
        itemBuilder: (context, index) {
          var item = state.requestList[index];
          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
            decoration: BoxDecoration(
              color: ColorConstants.WHITE,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.BLACK.withOpacity(0.1),
                  blurRadius: 5.r,
                  spreadRadius: 1.r,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request from',
                  style:
                      Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorConstants.BLACK,
                          ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.fromData?.clientName ??
                                'Debojyoti Singha',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: ColorConstants.PRIMARY_BLUE,
                                ),
                          ),
                          Text(
                            item.fromData?.platform ?? 'android',
                            style:
                                Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      Helper.getIconByPlatform(
                        item.fromData?.platform ?? 'android',
                      ),
                      width: 40.w,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _cubit.acceptRequest(item);
                        },
                        child: Text(
                          'Accept',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: ColorConstants.WHITE,
                              ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            ColorConstants.PRIMARY_BLUE,
                          ),
                          padding: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            EdgeInsets.symmetric(
                              vertical: 10.h,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _cubit.rejectRequest(item);
                        },
                        child: Text(
                          'Reject',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: ColorConstants.PRIMARY_BLUE,
                              ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            ColorConstants.WHITE,
                          ),
                          padding: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            EdgeInsets.symmetric(
                              vertical: 10.h,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void onDestroy() {}

  @override
  void onDispose() {}

  @override
  void onPause() {}

  @override
  void onResume() {}

  @override
  void onStop() {}
}
