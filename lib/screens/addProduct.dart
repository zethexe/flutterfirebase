import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practica4/firebase/firebase_provider.dart';
import 'package:practica4/models/products_dao.dart';
import 'package:uuid/uuid.dart';

class addProducto extends StatefulWidget {
  addProducto({Key key}) : super(key: key);

  @override
  _addProductoState createState() => _addProductoState();
}

class _addProductoState extends State<addProducto> {
  final picker = ImagePicker();
  String imagePath = "";
  TextEditingController txtName = TextEditingController();

  TextEditingController txtDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imgFinal = imagePath == ""
        ? Container(
            height: 150.0,
            width: 150.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://st4.depositphotos.com/14953852/22772/v/600/depositphotos_227725020-stock-illustration-image-available-icon-flat-vector.jpg"),
                    fit: BoxFit.fill),
                shape: BoxShape.rectangle),
          )
        : Container(
            height: 150.0,
            width: 150.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(File(imagePath)), fit: BoxFit.fill),
                shape: BoxShape.rectangle),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo Producto"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue, Colors.blue])),
                child: Container(
                  width: double.infinity,
                  height: 250.0,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        imgFinal,
                        SizedBox(
                          height: 5.0,
                        ),
                        FloatingActionButton(
                          child: Icon(Icons.camera_alt),
                          // Provide an onPressed callback.
                          onPressed: () async {
                            final file = await picker.getImage(
                                source: ImageSource.gallery);
                            imagePath = file.path;
                            setState(() {});
                          },
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                )),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Nombre del producto",
                      style: TextStyle(color: Colors.blue, fontSize: 28.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: txtName,
                      //initialValue: 'Zeth Alux',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      "Descripción",
                      style: TextStyle(color: Colors.blue, fontSize: 28.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: txtDescription,
                      // initialValue: '4645793708',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        letterSpacing: 2.0,
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        var imagen = File(imagePath);
                        Guardar(
                            txtName.text, txtDescription.text, imagen, context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.blue, Colors.blueGrey]),
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 100.0,
                            maxHeight: 40.0,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Guardar",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}

void Guardar(nombre, desc, imagen, context) async {
  if (nombre != "" && desc != "" && imagen != null) {
    FirebaseProvider firebaseProvider = FirebaseProvider();
    var imgName = nombre + "_" + Uuid().v1() + ".jpg";
    var url = "";
    print(imgName);
    final Reference reference =
        FirebaseStorage.instance.ref().child("/images/$imgName");

    await reference.putFile(imagen).whenComplete(() async {
      url = await reference.getDownloadURL();
      ProductDAO producto = ProductDAO(
        name: nombre,
        description: desc,
        image: url,
      );

      await firebaseProvider.saveProduct(producto);
      Navigator.pop(context);
    });
  } else {
    print("vacio");
  }
}
