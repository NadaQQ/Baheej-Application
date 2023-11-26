import 'package:flutter/material.dart';
import 'package:baheej/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:baheej/screens/SignInScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationManager().iniNotification();

  Stripe.publishableKey =
      "pk_test_51NxYJkAzFvFRBXEyZnGjEuJ7jTJPSyBsKtpMvLAO4J1Kz1kAlAF8GsmbmYecdjQi7uMNAcC89JuyPPKPgH8cpQw700qsNegMUZ";
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();

  FirebaseApp app;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  // NotificationApi.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the NotificationApi and pass the context
    // NotificationApi.init(context: context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInScreen(),
    );
  }
}
