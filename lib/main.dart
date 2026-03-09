import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ngaananoaatqwcikxuob.supabase.co',
    anonKey: 'sb_publishable_T5h4UqYEdpNWYVlMgeUGjg_PaKFIl3T',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Dashboard',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      ),
      home: HomeScreen(),
    );
  }
}