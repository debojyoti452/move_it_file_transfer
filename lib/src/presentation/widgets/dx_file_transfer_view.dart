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

import '../../data/constants/assets_constants.dart';
import '../../data/model/file_model.dart';
import '../../domain/themes/color_constants.dart';

class DxFileTransferView extends StatelessWidget {
  const DxFileTransferView({
    Key? key,
    required this.fileModel,
    required this.onRemoveClick,
    required this.index,
    required this.progress,
    this.isRemoveButtonVisible = true,
  }) : super(key: key);

  final FileModel fileModel;
  final ValueChanged<int> onRemoveClick;
  final int index;
  final int progress;
  final bool? isRemoveButtonVisible;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: Row(
          children: [
            Image.asset(
              AssetsConstants.fileIcon,
              width: 30.w,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'File Name: ${fileModel.fileName}',
                    style: TextStyle(
                      color: ColorConstants.PRIMARY_BLUE,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'File Size: ${((fileModel.fileSize ?? 0) / (1024 * 1024)).toStringAsFixed(2)}MB',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: ColorConstants.GREY_DARK,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      ColorConstants.PRIMARY_BLUE,
                    ),
                    minHeight: 6.h,
                  ),
                ],
              ),
            ),
            if (isRemoveButtonVisible ?? false)
              IconButton(
                onPressed: () {
                  onRemoveClick(index);
                },
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 15.w,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
