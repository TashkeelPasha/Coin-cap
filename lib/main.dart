import 'dart:convert';

import 'package:coincap/models/app-config.dart';
import 'package:coincap/pages/home_page.dart';
import 'package:coincap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Load();
  registerHTTPService();
  runApp(const MyApp());
}

Future<void> Load() async {
  String configContent = await rootBundle.loadString("assets/config/main.json");

  Map configData = jsonDecode(configContent);
  GetIt.instance.registerSingleton<AppConfig>(AppConfig(
    COIN_API_BASE_URL: configData["COIN_API_BASE_URL"],
  ));
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HTTPSService>(HTTPSService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinCap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromRGBO(88, 60, 197, 1.0),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
