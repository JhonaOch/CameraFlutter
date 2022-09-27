import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:validacion_formularios/src/bloc/validators.dart';

class LoginBloc with Validators {
  final _passwordController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();

  //Recuperar los datos del Stream

  Stream<String> get emailStream {
    return _emailController.stream.transform(validarEmail);
  }

  Stream<String> get passwordStream {
    return _passwordController.stream.transform(validarPassword);
  }

  Stream<bool> get formValidStream =>
      CombineLatestStream.combine2(emailStream, passwordStream, (e, p) => true);

  //Insetar valores al Stream

  Function(String) get changeEmail {
    return _emailController.sink.add;
  }

  Function(String) get changePassword {
    return _passwordController.sink.add;
  }

  //Obtener el ultimo valor ingresado a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
