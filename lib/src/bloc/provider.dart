import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/bloc/login_bloc.dart';
export 'package:validacion_formularios/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget {
  static Provider? _instancia;
  factory Provider({Key? key, Widget? child}) {
    // ignore: prefer_conditional_assignment
    if (_instancia == null) {
      _instancia = Provider._internal(key: key, child: child);
    }
    return _instancia!;
  }

  Provider._internal({Key? key, Widget? child})
      : super(key: key, child: child!);

  final loginBloc = LoginBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!.loginBloc;
  }
}
