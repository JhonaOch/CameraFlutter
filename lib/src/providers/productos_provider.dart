// ignore_for_file: unnecessary_null_comparison, unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:mime_type/mime_type.dart';
import 'package:validacion_formularios/src/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProductosProvider {
  final String _url = 'https://flutter-1fae9-default-rtdb.firebaseio.com';

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';

    final resp =
        await http.post(Uri.parse(url), body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    //print( decodedData );

    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json';

    final resp =
        await http.put(Uri.parse(url), body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    //print( decodedData );

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json';
    final resp = await http.get(Uri.parse(url));

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = [];

    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;

      productos.add(prodTemp);
    });

    // print( productos[0].id );

    return productos;
  }

  // ignore: duplicate_ignore
  Future<int> borrarProducto(String id) async {
    final url = '$_url/productos/$id.json';
    // ignore:
    final resp = await http.delete(Uri.parse(url));

    //print( resp.body );

    return 1;
  }

  Future<String?> subirImagen(File imagen) async {
    final url = Uri.parse(
        'http://res.cloudinary.com/dzbrxacvj/image/upload/v1649454032/sj2iogtrghqbxxuoflxj.jpg');
    final mimeType = mime(imagen.path)?.split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mimeType![0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      // print('Algo salio mal');
      // print( resp.body );
      return null;
    }

    final respData = json.decode(resp.body);
    // print( respData);

    return respData['secure_url'];
  }
}
