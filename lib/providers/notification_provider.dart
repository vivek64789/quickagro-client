import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationProvider extends ChangeNotifier {
  //  Notification check
  notify({String? title, String? body, String? picture}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: title ?? 'Food Agro Notification',
          body: body ?? 'New Notification',
          notificationLayout: NotificationLayout.BigPicture,
          bigPicture: picture ??
              'https://images.idgesg.net/images/article/2019/01/android-q-notification-inbox-100785464-large.jpg?auto=webp&quality=85,70'),
    );
  }
}
