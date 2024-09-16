import 'package:dejavu/components/my_button.dart';
import 'package:dejavu/components/my_textfield.dart';
import 'package:dejavu/pages/home_page.dart';
import 'package:dejavu/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      showErrorMessage("As senhas não conferem!");
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false, // Remove todas as rotas anteriores
        );
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showErrorMessage(e.message ?? 'Erro desconhecido');
      }
    }
  }

  void signInWithGoogle() async {
    try {
      await AuthService().signInWithGoogle();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false, // Remove todas as rotas anteriores
      );
    } catch (e) {
      showErrorMessage('Falha na autenticação com Google');
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'lib/images/DejavuLogo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 40),
                Text(
                  'Vamos criar uma conta para você!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Senha',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirme a senha',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: "Inscrever-se",
                  onTap: signUserUp,
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Já tem uma conta?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Faça login agora',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Ou entre com',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      imagePath: 'lib/images/google.png',
                      onTap: signInWithGoogle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
