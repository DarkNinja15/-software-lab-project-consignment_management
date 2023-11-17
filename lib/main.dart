import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_consignment/models/consignment_model.dart';
import 'package:flutter_consignment/models/product_model.dart';
// import 'package:flutter_consignment/models/user_model.dart';
// import 'package:flutter_consignment/provider/user_provider.dart';
import 'package:flutter_consignment/screens/company.dart';
import 'package:flutter_consignment/screens/home.dart';
// import 'package:flutter_consignment/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_consignment/screens/login.dart';
import 'package:flutter_consignment/services/databse.dart';
// import 'package:flutter_consignment/services/local%20storage/user_preferences.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Consignment>>.value(
          value: Database().getConsignmnets,
          initialData: const [],
        ),
        StreamProvider<List<Product>>.value(
          value: Database().getProducts,
          initialData: const [],
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: SelectionArea(
          child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const HomePage();
                }
                if (snapshot.hasError) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Something went wrong!'),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const Login();
              }),
        ),
      ),
    );
  }
}
