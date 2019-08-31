package com.wallpaper.wallbay

import android.annotation.SuppressLint
import android.app.DownloadManager
import android.content.Context
import android.net.Uri

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import android.os.Environment.DIRECTORY_PICTURES
import android.app.WallpaperManager
import android.R.attr.path
import java.io.File
import android.R.attr.path
import android.graphics.BitmapFactory
import android.graphics.Bitmap
import android.R.attr.bitmap
import android.os.*
import java.io.ByteArrayOutputStream
import java.io.IOException
import android.content.Intent
import android.webkit.MimeTypeMap
import androidx.core.content.FileProvider


class MainActivity() : FlutterActivity() {

    val CHANNEL = "wallbay/imageDownloader"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)


        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { methodCall, result ->


            val args = methodCall.arguments<String>()
            if (methodCall.method == "setWallpaper") {
                setWallpaper(args)
            }

        }

    }


    private fun setWallpaper(path: String) {
        val file = File(path)
        val uri = FileProvider.getUriForFile(this, "${this.packageName}.image_downloader.provider", file)
//            val wallpaperManager = WallpaperManager.getInstance(this)
//            val intent =  Intent(wallpaperManager.getCropAndSetWallpaperIntent(uri))
//            startActivity(intent)
        val intent = Intent(Intent.ACTION_ATTACH_DATA)
                .apply {
                    addCategory(Intent.CATEGORY_DEFAULT)
                    setDataAndType(uri, "image/*")
                    putExtra("mimeType", "image/*")
                    addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                }
        startActivity(Intent.createChooser(intent, "Set as:"))
    }


//    private fun downloadImage(imageUrl: String) {
//        val Download_Uri = Uri.parse(imageUrl)
//        val request = DownloadManager.Request(Download_Uri)
//        request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_WIFI)
//        request.setAllowedOverRoaming(false)
//        //  request.setTitle("");  // title and desc. are related to notification only
//        //  request.setDescription("");
//        request.setVisibleInDownloadsUi(true)
//        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_PICTURES, "/testWallbat/" + "testImage" + ".jpg")
//
//
//
//        downloadManager?.enqueue(request)
//
////        val file = File(this.getExternalFilesDir(Environment.DIRECTORY_PICTURES),"/testWallbat/" + "testImage" + ".jpg")
////
////        print(file)
//
//        // async task example
//        //  new ImageGetter().execute("https://unsplash.com/photos/iEJVyyevw-U/download?force=true");
//
//    }


//    private fun setWallpaper(): String {
//
//        val wallpaperManager = WallpaperManager.getInstance(this)
//        val file = File(this.getExternalFilesDir(null), "myimage.png")
//
//
//        val bitmap = BitmapFactory.decodeFile(file.absolutePath)
//
//        val bytearrayoutputstream = ByteArrayOutputStream()
//        var BYTE: ByteArray
//
//        bitmap.compress(Bitmap.CompressFormat.PNG, 60, bytearrayoutputstream)
//
//        BYTE = bytearrayoutputstream.toByteArray()
//
//        val bitmap2 = BitmapFactory.decodeByteArray(BYTE, 0, BYTE.size)
//
//        try {
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
//
//                wallpaperManager.setBitmap(bitmap2, null, true, WallpaperManager.FLAG_SYSTEM)
//                res = "Home Screen Set Successfully"
//            } else {
//                res = "To Set Home Screen Requires Api Level 24"
//            }
//
//
//        } catch (ex: IOException) {
//            ex.printStackTrace()
//        }
//
//
//        return res
//
//    }




}




