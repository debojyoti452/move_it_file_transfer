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
