import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var riveUrl = 'assets/animated_login_character.riv';
  StateMachineController? stateMachineController;
  SMITrigger? failTrigger;
  SMITrigger? successTrigger;
  SMIBool? isHandsUp;
  SMIBool? isChecking;
  SMINumber? lookNum;
  Artboard? artboard;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    rootBundle.load(riveUrl).then((value) {
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(art, 'Login Machine');

      if (stateMachineController != null) {
        art.addController(stateMachineController!);
        for (var element in stateMachineController!.inputs) {
          if (element.name == 'isChecking') {
            isChecking = element as SMIBool;
          } else if (element.name == 'isHandsUp') {
            isHandsUp = element as SMIBool;
          } else if (element.name == 'trigSuccess') {
            successTrigger = element as SMITrigger;
          } else if (element.name == 'trigFail') {
            failTrigger = element as SMITrigger;
          } else if (element.name == 'numLook') {
            lookNum = element as SMINumber;
          }
        }
      }
      setState(() => artboard = art);
    });
    super.initState();
  }

  void lookAround() {
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  void moveEyes(value) {
    lookNum?.change(value.length.toDouble());
  }

  void handUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

  void loginClick() {
    isChecking?.change(false);
    isHandsUp?.change(false);
    if (emailController.text == 'email' &&
        passwordController.text == 'password') {
      successTrigger?.fire();
    } else {
      failTrigger?.fire();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (artboard != null)
              Column(
                children: [
                  SizedBox(
                    height: 300,
                    width: 500,
                    child: Rive(
                      artboard: artboard!,
                    ),
                  ),
                  const Divider(height: 1),
                ],
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      moveEyes(value);
                    },
                    onTap: lookAround,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    obscureText: true,
                    onTap: handUpOnEyes,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      loginClick();
                    },
                    child: const Text('Iniciar Sesión'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('¿No tienes cuenta? Regístrate'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
