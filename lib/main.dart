import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practica4/screens/addProduct.dart';
import 'package:practica4/screens/products.dart';

import 'screens/list_products_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/new': (BuildContext context) => addProducto(),
      },
      home: Products(),
    );
  }
}
