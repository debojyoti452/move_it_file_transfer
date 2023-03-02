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

abstract class AppCubitStatus {}

class AppCubitInitial extends AppCubitStatus {}

class AppCubitLoading extends AppCubitStatus {}

class AppCubitSuccess extends AppCubitStatus {
  final String message;
  final int code;

  AppCubitSuccess({this.message = '', this.code = 452});
}

class AppCubitError extends AppCubitStatus {
  final String message;

  AppCubitError({required this.message});
}

class AppCubitNoInternet extends AppCubitStatus {}

class AppCubitNoData extends AppCubitStatus {}

class AppCubitNoMoreData extends AppCubitStatus {}

class AppCubitNoMoreDataWithMessage extends AppCubitStatus {
  final String message;

  AppCubitNoMoreDataWithMessage(this.message);
}
