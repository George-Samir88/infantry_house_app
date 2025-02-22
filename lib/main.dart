import 'package:flutter/material.dart';

import 'views/widgets/home_view/home_view.dart';

void main() {
  runApp(CoffeeShopApp());
}

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeView());
  }
}
