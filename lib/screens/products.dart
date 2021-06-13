import 'package:flutter/material.dart';

import 'addProduct.dart';
import 'list_products_screen.dart';

class Products extends StatelessWidget {
  const Products({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Firebase, Database & Storage :)"),
        actions: [
          MaterialButton(
            child: Icon(Icons.add_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => addProducto()),
              );
            },
          )
        ],
      ),
      body: ListProducts(),
    );
  }
}
