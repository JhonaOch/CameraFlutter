import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validacion_formularios/src/models/models.dart';
import 'package:validacion_formularios/src/utils/utils.dart' as utils;

import '../providers/productos_provider.dart';

class ProductoPage extends StatefulWidget {
  const ProductoPage({Key? key}) : super(key: key);

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = ProductosProvider();

  // ignore: unnecessary_new
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File? foto;

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData =
        ModalRoute.of(context)!.settings.arguments as ProductoModel;
    // ignore: unnecessary_null_comparison
    if (prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value as String,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.parse(value!),
      validator: (value) {
        if (utils.isNumeric(value!)) {
          return null;
        } else {
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: const Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20.0)
      // ),
      // color: Colors.deepPurple,
      // textColor: Colors.white,
      label: const Text('Guardar'),
      icon: const Icon(Icons.save),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productoProvider.subirImagen(foto!);
    }

    if (producto.id == null) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }

    // setState(() {_guardando = false; });
    mostrarSnackbar('Registro guardado');

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    // ignore: unused_local_variable
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: const Duration(milliseconds: 1500),
    );

    // scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return Container();
    } else {
      if (foto != null) {
        return Image.file(
          foto!,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.jpg');
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final _picker = ImagePicker();

    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(
      source: origen,
    );

    foto = File(pickedFile!.path);

    if (foto != null) {
      producto.fotoUrl = null;
    }

    setState(() {});

    //   if ( foto != null ) {
    //     producto.fotoUrl = null;
    //   }

    //   setState(() {});
  }
}
