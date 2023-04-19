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

package com.swing.movefileshare.move_app_fileshare

import android.app.AlertDialog
import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.view.Gravity
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.content.PermissionChecker
import com.swing.movefileshare.move_app_fileshare.constants.Constants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {

    private lateinit var methodChannel: MethodChannel
    private val requestedPermissionList = arrayOf(
        android.Manifest.permission.WRITE_EXTERNAL_STORAGE
    )


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, Constants.CHANNEL)
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                Constants.getDownloadPath -> {
                    println("getDownloadPath called")
                    try {
                        val downloadPath =
                            applicationContext.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS)
                        result.success(downloadPath?.absolutePath)
                    } catch (e: Exception) {
                        result.error("Exception", e.message, e)
                    }
                }
                Constants.saveFileMethod -> {
                    println("saveFileMethod called")
                    val filePath = call.argument<String>("filePath")
                    if (filePath == null) {
                        result.error("Exception", "File path is null", null)
                        return
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        val file = File(filePath)
                        saveFile(file)
                    } else {
                        result.error("Exception", "Android version is less than Q", null)
                    }
                }
                Constants.requestStoragePermission -> {
                    println("requestStoragePermission called")
                    requestStoragePermission(result)
                }
                Constants.isStoragePermissionGranted -> {
                    println("isStoragePermissionGranted called")
                    result.success(isStoragePermissionGranted())
                }
                else -> {
                    result.notImplemented()
                }
            }
        } catch (e: Exception) {
            result.error("Exception", e.message, e)
        }
    }

    /// Request storage permission
    /// https://developer.android.com/training/data-storage/shared/media#request-permission
    private fun requestStoragePermission(result: MethodChannel.Result) {
        when {
            isStoragePermissionGranted() -> {
                println("Permission is granted")
                result.success(true)
            }
            shouldShowRequestPermissionRationale(requestedPermissionList[0]) -> {
                println("Permission is not granted")
                showInAlertDialog()
            }
            else -> {
                requestPermissions(requestedPermissionList, PERMISSION_REQUEST_CODE)
            }
        }
    }

    /// Check if storage permission is granted
    /// https://developer.android.com/training/data-storage/shared/media#check-permission
    private fun isStoragePermissionGranted(): Boolean {
        if (PermissionChecker.checkSelfPermission(
                this,
                requestedPermissionList[0]
            ) == PermissionChecker.PERMISSION_GRANTED
        ) {
            return true
        }
        return false
    }

    /// Show the User Interface When the Permission is Requested
    /// https://developer.android.com/training/data-storage/shared/media#request-permission
    private fun showInAlertDialog() {
        val builder = AlertDialog.Builder(this)
        builder.apply {
            setMessage("Permission to access the storage is required for this app to download files.")
            setTitle("Permission required")
            setPositiveButton("OK") { _, _ ->
                requestPermissions(requestedPermissionList, PERMISSION_REQUEST_CODE)
            }
        }
        val dialog = builder.create()
        dialog.show()
    }

    /// Save the file to the download folder using
    /// MediaStore API
    /// https://developer.android.com/training/data-storage/shared/media#java
    /// https://developer.android.com/training/data-storage/shared/media#kotlin
    @RequiresApi(Build.VERSION_CODES.Q)
    private fun saveFile(file: File) {
        val values = ContentValues().apply {
            put(MediaStore.Downloads.DISPLAY_NAME, file.name)
            put(MediaStore.Downloads.MIME_TYPE, getMIMEType(file))
            put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
        }
        val resolver = applicationContext.contentResolver
        val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
        uri?.let {
            resolver.openOutputStream(it).use { outputStream ->
                if (outputStream != null) {
                    file.inputStream().copyTo(outputStream)
                }
            }
        }
        /// delete the file from the app's private storage
        file.delete()
    }

    private fun getMIMEType(file: File): String {
        return when (file.extension) {
            "pdf" -> "application/pdf"
            "doc" -> "application/msword"
            "docx" -> "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            "xls" -> "application/vnd.ms-excel"
            "xlsx" -> "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            "ppt" -> "application/vnd.ms-powerpoint"
            "pptx" -> "application/vnd.openxmlformats-officedocument.presentationml.presentation"
            "txt" -> "text/plain"
            "png" -> "image/png"
            "jpg" -> "image/jpeg"
            "jpeg" -> "image/jpeg"
            "gif" -> "image/gif"
            "mp3" -> "audio/mpeg"
            "mp4" -> "video/mp4"
            "zip" -> "application/zip"
            "rar" -> "application/x-rar-compressed"
            "apk" -> "application/vnd.android.package-archive"
            "exe" -> "application/x-msdownload"
            "csv" -> "text/csv"
            "html" -> "text/html"
            "xml" -> "text/xml"
            "json" -> "application/json"
            "aac" -> "audio/aac"
            "wav" -> "audio/wav"
            "ogg" -> "audio/ogg"
            "webm" -> "video/webm"
            "mkv" -> "video/x-matroska"
            "3gp" -> "video/3gpp"
            "3g2" -> "video/3gpp2"
            "ts" -> "video/mp2t"
            "flv" -> "video/x-flv"
            "avi" -> "video/x-msvideo"
            "wmv" -> "video/x-ms-wmv"
            "mov" -> "video/quicktime"
            "m4a" -> "audio/mp4"
            "m4v" -> "video/mp4"
            "f4v" -> "video/mp4"
            "f4a" -> "audio/mp4"
            "srt" -> "text/plain"
            "vtt" -> "text/vtt"
            "smi" -> "application/smil+xml"
            "rtf" -> "application/rtf"
            "js" -> "application/javascript"
            "css" -> "text/css"
            "m3u" -> "audio/x-mpegurl"
            "m3u8" -> "application/vnd.apple.mpegurl"
            "pls" -> "audio/x-scpls"
            "mid" -> "audio/midi"
            "midi" -> "audio/midi"
            "kar" -> "audio/midi"
            "amr" -> "audio/amr"
            "flac" -> "audio/flac"
            "opus" -> "audio/opus"
            else -> "*/*"
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSION_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PermissionChecker.PERMISSION_GRANTED) {
                showCustomToast(message = "Permission granted")
            } else {
                showCustomToast(message = "Permission denied")
            }
        } else {
            showCustomToast(message = "Permission denied")
        }
    }

    private fun showCustomToast(message: String) {
        if (Build.VERSION_CODES.Q <= Build.VERSION.SDK_INT) {
            return
        }
        val toast = Toast.makeText(applicationContext, message, Toast.LENGTH_SHORT)
        toast.setGravity(Gravity.CENTER, 0, 0)
        toast.show()
    }

    companion object {
        const val PERMISSION_REQUEST_CODE = 452
    }
}
