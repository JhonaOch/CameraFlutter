import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/bloc/provider.dart';
import 'package:validacion_formularios/src/models/models.dart';
import 'package:validacion_formularios/src/providers/productos_provider.dart';

class HomePage extends StatelessWidget {
  // const HomePage({Key? key}) : super(key: key);

  final productosProvider = ProductosProvider();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: _crearListado(context),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(BuildContext context) {
    return FutureBuilder(
        future: productosProvider.cargarProductos(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final productos = snapshot.data;
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, i) {
                return _crearItem(context, productos[i]);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget _crearItem(context, ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          productosProvider.borrarProducto(producto.id as String);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
                  ? const Image(image: AssetImage('assets/no-image.jpg'))
                  : FadeInImage(
                      image: NetworkImage(producto.fotoUrl as String),
                      placeholder: const AssetImage('assets/loading.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id as String),
                onTap: () => Navigator.pushNamed(context, 'producto',
                    arguments: producto),
              ),
            ],
          ),
        ));
  }

  _crearBoton(context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () {
        Navigator.pushNamed(context, 'producto');
      },
    );
  }
}
