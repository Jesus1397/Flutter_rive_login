import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final riveUrl = 'assets/animated_login_character.riv';
  StateMachineController? stateMachineController;
  SMITrigger? failTrigger;
  SMITrigger? successTrigger;
  SMIBool? isHandsUp;
  SMIBool? isChecking;
  SMINumber? lookNum;
  Artboard? artboard;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  Color emailBorderColor = Colors.white;
  Color passwordBorderColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();

    emailFocusNode.addListener(_handleFocusChange);
    passwordFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!emailFocusNode.hasFocus && !passwordFocusNode.hasFocus) {
      isChecking?.change(false);
      isHandsUp?.change(false);
    }
  }

  Future<void> _loadRiveFile() async {
    final data = await rootBundle.load(riveUrl);
    final file = RiveFile.import(data);
    final art = file.mainArtboard;
    stateMachineController =
        StateMachineController.fromArtboard(art, 'Login Machine');

    if (stateMachineController != null) {
      art.addController(stateMachineController!);
      _initializeStateMachineInputs();
    }

    setState(() {
      artboard = art;
    });
  }

  void _initializeStateMachineInputs() {
    for (var element in stateMachineController!.inputs) {
      switch (element.name) {
        case 'isChecking':
          isChecking = element as SMIBool;
          break;
        case 'isHandsUp':
          isHandsUp = element as SMIBool;
          break;
        case 'trigSuccess':
          successTrigger = element as SMITrigger;
          break;
        case 'trigFail':
          failTrigger = element as SMITrigger;
          break;
        case 'numLook':
          lookNum = element as SMINumber;
          break;
      }
    }
  }

  void lookAround() {
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  void moveEyes(String value) {
    lookNum?.change(value.length.toDouble());
  }

  void handUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

  void cancelCurrentAnimation() {
    isHandsUp?.change(false);
    isChecking?.change(false);
  }

  void loginClick() {
    cancelCurrentAnimation();

    setState(() {
      if (emailController.text == 'email' &&
          passwordController.text == 'password') {
        successTrigger?.fire();
        emailBorderColor = Colors.green;
        passwordBorderColor = Colors.green;
      } else {
        failTrigger?.fire();
        emailBorderColor = Colors.red;
        passwordBorderColor = Colors.red;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (artboard != null)
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  color: Colors.black,
                ),
                height: 300,
                width: 500,
                child: Rive(
                  artboard: artboard!,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: emailBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: emailBorderColor),
                      ),
                    ),
                    onChanged: moveEyes,
                    onTap: lookAround,
                    focusNode: emailFocusNode,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: passwordBorderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: passwordBorderColor),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    obscureText: true,
                    onTap: handUpOnEyes,
                    onChanged: (value) => handUpOnEyes,
                    focusNode: passwordFocusNode,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: loginClick,
                    style: const ButtonStyle(),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        color: Color(0xFFB04863),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      '¿No tienes cuenta? Regístrate',
                      style: TextStyle(
                        color: Color(0xFFB04863),
                      ),
                    ),
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
