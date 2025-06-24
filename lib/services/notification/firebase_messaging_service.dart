// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get_utils/src/platform/platform.dart';
// import 'package:gis_disaster_flutter/base/cache_manager.dart';
// import 'package:gis_disaster_flutter/global/app_log.dart';
// import 'package:gis_disaster_flutter/services/notification/local_notification_handler.dart';

// class FirebaseMessagingService with CacheManager {
//   FirebaseMessaging? messaging = FirebaseMessaging.instance;

//   Future<void> requestPermission() async {
//     final settings = await messaging!.requestPermission(
//         alert: true,
//         announcement: true,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true);
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       AppLog.print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       AppLog.print('User granted provisional permission');
//     } else {
//       AppLog.print('User declined or has not accepted permission');
//     }
//   }

//   void setupFirebase() {
//     NotificationHandler.initNotification();
//     _firebaseCloudMessagingListener();
//     _createNotificationChannel();
//   }

//   static Future<void> handleInitialMessage() async {
//     await FirebaseMessagingService().registerFcmToken();
//     if (GetPlatform.isAndroid) {
//       NotificationHandler.flutterLocalNotificationPlugin
//           .getNotificationAppLaunchDetails()
//           .then((NotificationAppLaunchDetails? value) {
//         if (value?.notificationResponse?.payload != null) {
//           // if (RemoteManager().initialMessageActive == false) {
//           //   RemoteManager().initialMessageActive = true;
//           //   NotificationHandler.moveTheScreen(
//           //       value?.notificationResponse?.payload);
//           // }
//         }
//       });
//     } else {
//       FirebaseMessaging.instance
//           .getInitialMessage()
//           .then((RemoteMessage? message) async {
//         if (message != null) {
//           NotificationHandler.moveTheScreen(message.data.toString());
//         }
//       });
//     }
//   }

//   Future<void> registerFcmToken() async {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       if (getFcmToken() == null || getRegisterFcm() != true) {
//         messaging?.getToken().then((token) async {
//           AppLog.dbPrint('FCM => $token');
//           _createFcmToken(token);
//         });
//       } else {
//         // messaging?.onTokenRefresh.listen(
//         //   (String? refreshToken) {
//         //     if (refreshToken != null && getFcmToken() != refreshToken) {
//         //       AppLog.dbPrint('Refresh FCM TOKEN');
//         //       _createFcmToken(refreshToken);
//         //     }
//         //   },
//         // );
//       }
//     });
//   }

//   Future<void> _createFcmToken(String? token) async {
//     NotificationUseCase().createFcmToken(
//       fcmParam: FcmParam(fcmToken: token, deviceId: await getDeviceId()),
//       onSuccess: () async {
//         await saveFcmToken(token);
//         saveRegisterFcm();
//         AppLog.dbPrint(
//             '=============> REGISTER FCM TOKEN SUCCESS <=============');
//       },
//       onFailure: (err) => removeFCMToken(),
//     );
//   }

//   Future<void> _firebaseCloudMessagingListener() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       AppLog.dbPrint('=============> onMessage <=============');
//       updateDataWhenReceive(message);
//       if (Get.currentRoute == AppRouter.routerMatchingProductDetail) {
//         final matchingController =
//             findController<MatchingProductDetailController>();
//         if (matchingController.currentPage.value == 0) {
//           showNotification(message);
//         } else {
//           if ('${matchingController.matchingArgument.data?.matchingId}' !=
//               message.data['matching_id']) {
//             showNotification(message);
//           }
//         }
//       } else {
//         showNotification(message);
//       }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       AppLog.dbPrint('=============> onMessageOpenedApp <=============');
//       NotificationHandler.moveTheScreen(jsonEncode(message.data));
//     });
//   }

//   Future<void> updateDataWhenReceive(RemoteMessage message) async {
//     Future(() {
//       if (Get.isRegistered<DashboardController>()) {
//         final PushData data =
//             PushData.fromMap(jsonDecode(jsonEncode(message.data)));
//         final dashboardController = Get.find<DashboardController>();
//         switch (data.path) {
//           case 'notification_detail':
//             if (Get.isRegistered<NotificationController>()) {
//               final noticeController = Get.find<NotificationController>();
//               if (noticeController.notificationParam.value.type == 1) {
//                 noticeController.onRefresh();
//               }
//             } else {
//               dashboardController.updateBadge();
//             }
//             break;
//           case 'matching_detail':
//             dashboardController.updateBadge(
//                 tapAtDashBoard: true, pushData: data);
//             break;
//           case 'message':
//             dashboardController.updateMatchingList();
//             break;
//           default:
//             dashboardController.updateBadge();
//         }
//       }
//     });
//   }

//   static Future<void> _createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_importance_channel',
//       'High Importance Notifications',
//       importance: Importance.max,
//     );
//     final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   static Future<void> showNotification(RemoteMessage message) async {
//     final String? picturePath = await _picturePath(message);
//     final android = AndroidNotificationDetails(
//       'high_importance_channel',
//       'High Importance Notifications',
//       importance: Importance.max,
//       priority: Priority.max,
//       ticker: 'HALELEA Ticker',
//       icon: '@mipmap/ic_launcher',
//       enableVibration: true,
//       channelShowBadge: true,
//       styleInformation: picturePath != null
//           ? BigPictureStyleInformation(
//               FilePathAndroidBitmap(picturePath),
//               hideExpandedLargeIcon: false,
//               htmlFormatContentTitle: true,
//               htmlFormatSummaryText: true,
//             )
//           : null,
//       largeIcon:
//           picturePath != null ? FilePathAndroidBitmap(picturePath) : null,
//     );
//     final ios = DarwinNotificationDetails(
//       presentAlert: true,
//       presentSound: true,
//       presentBadge: true,
//       attachments: picturePath != null
//           ? <DarwinNotificationAttachment>[
//               DarwinNotificationAttachment(
//                 picturePath,
//               ),
//             ]
//           : null,
//     );
//     final platformChannelSpecific =
//         NotificationDetails(android: android, iOS: ios);
//     final rng = Random();
//     final rngInt = rng.nextInt(900000) + 100;
//     if (GetPlatform.isAndroid) {
//       if (message.data['title'] != null) {
//         await NotificationHandler.flutterLocalNotificationPlugin.show(
//           message.data['id'] ?? rngInt,
//           parse(message.data['title']).body?.text,
//           parse(message.data['body']).body?.text,
//           platformChannelSpecific,
//           payload: jsonEncode(message.data),
//         );
//       }
//     } else {
//       if (message.notification?.title != null) {
//         await NotificationHandler.flutterLocalNotificationPlugin.show(
//           message.data['id'] ?? rngInt,
//           parse(message.notification?.title).body?.text,
//           parse(message.notification?.body).body?.text,
//           platformChannelSpecific,
//           payload: jsonEncode(message.data),
//         );
//       }
//     }
//   }
// }
