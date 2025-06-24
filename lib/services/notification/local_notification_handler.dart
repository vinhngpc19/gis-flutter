import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gis_disaster_flutter/global/app_log.dart';

class NotificationHandler {
  static final flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  static void initNotification() {
    const initAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initIOS = DarwinInitializationSettings();

    const initSetting =
        InitializationSettings(android: initAndroid, iOS: initIOS);

    flutterLocalNotificationPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: _onSelectNotification,
      onDidReceiveBackgroundNotificationResponse: _onSelectNotification,
    );
  }

  static void _onSelectNotification(NotificationResponse notificationResponse) {
    moveTheScreen(notificationResponse.payload);
  }

  static Future<void> moveTheScreen(String? payload) async {
    AppLog.print('PAYLOAD $payload');
    if (payload != null) {
      print(payload);
      // final PushData data = PushData.fromMap(jsonDecode(payload));
      // _moveToPage(data);
    }
  }

  // static void _moveToPage(PushData data) {
  //   switch (data.path) {
  //     case 'matching_detail_with_feedback':
  //       _moveToMatchingDetail(data, 0);
  //       break;
  //     case 'message':
  //       if (Get.currentRoute == AppRouter.routerMatchingProductDetail) {
  //         final matchingController =
  //             findController<MatchingProductDetailController>();
  //         if (matchingController.matchingArgument.data?.matchingId !=
  //             data.matchingId) {
  //           _moveToMatchingDetail(data, 1);
  //         } else {
  //           if (matchingController.currentPage.value == 0) {
  //             matchingController.handleTapAt(1);
  //           }
  //         }
  //       } else {
  //         _moveToMatchingDetail(data, 1);
  //       }
  //       break;
  //     default:
  //       if (data.notificationId != null || data.newsId != null) {
  //         Get.toNamed(
  //           AppRouter.routerNotificationDetail,
  //           arguments: NotificationArgument(
  //             id: data.notificationId ?? data.newsId,
  //             type: NotificationTypeImpl.toCase(data.type == 'news' ? 2 : 1),
  //             fromPush: true,
  //           ),
  //           preventDuplicates: false,
  //         );
  //       }
  //   }
  // }
}
