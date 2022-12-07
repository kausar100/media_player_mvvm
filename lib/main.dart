import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_flutter/view/screens/home_screen.dart';
import 'package:mvvm_flutter/view_model/media_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: MediaViewModel()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Media Player',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(),
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
                .copyWith(secondary: Colors.blueAccent),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const HomeScreen(),
          },
        ));
  }
}
