// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/bloc/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  // const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _crearFondo(context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: const Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: [
        fondoMorado,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, right: 300.0, child: circulo),
        Container(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: const <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              SizedBox(height: 10.0, width: double.infinity),
              Text('Jonnathan Ochoa',
                  style: TextStyle(color: Colors.white, fontSize: 25.0))
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            margin: const EdgeInsets.symmetric(vertical: 50.0),
            width: size.width * 0.85,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                const Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                const SizedBox(height: 60.0),
                _crearEmail(bloc, context),
                const SizedBox(height: 30.0),
                _crearPassword(bloc, context),
                const SizedBox(height: 30.0),
                _crearBoton(bloc, context)
              ],
            ),
          ),
          const Text('¿Olvido la contraseña?'),
          const SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc, context) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (context, AsyncSnapshot snapshot) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: const Icon(Icons.alternate_email,
                      color: Colors.deepPurple),
                  hintText: 'ejemplo@correo.com',
                  labelText: 'Correo electrónico',
                  counterText: snapshot.data,
                  errorText: snapshot.error as String),
              onChanged: (value) {
                bloc.changeEmail(value);
              },
            ));
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc, context) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (context, AsyncSnapshot snapshot) {
        //snapshot.error;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: const Icon(Icons.lock_outline, color: Colors.deepPurple),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error as String,
            ),
            onChanged: (value) {
              bloc.changePassword(value);
            },
          ),
        );
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc, context) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: const Text('Ingresar'),
          ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(5.0)
          // ),
          // elevation: 0.0,
          // color: Colors.deepPurple,
          // textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
        );
      },
    );
  }

  _login(LoginBloc bloc, context) {
    //print('================');
    // print('Email: ${bloc.email}');
    //print('Password: ${bloc.password}');
    //print('================');

    Navigator.pushReplacementNamed(context, 'home');
  }
}
