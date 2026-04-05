package com.example.greenbin

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = getSystemService(NotificationManager::class.java)
            val channel = NotificationChannel(
                "notification_channel",
                "App Notifications",
                NotificationManager.IMPORTANCE_HIGH
            )
            channel.description = "Thông báo từ ứng dụng"
            notificationManager?.createNotificationChannel(channel)

            // Scheduled notifications channel
            val scheduledChannel = NotificationChannel(
                "scheduled_notifications",
                "Scheduled Notifications",
                NotificationManager.IMPORTANCE_HIGH
            )
            scheduledChannel.description = "Thông báo theo lịch"
            notificationManager?.createNotificationChannel(scheduledChannel)
        }
    }
}
