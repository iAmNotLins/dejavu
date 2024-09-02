import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle({VoidCallback? onSuccess}) async {
    try {
      // Desconectar o usuário atual do Google Sign-In
      await _googleSignIn.signOut();

      // Iniciar o fluxo de login com o Google
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) {
        // Usuário cancelou o login
        print('Login cancelado pelo usuário');
        return;
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Chama a função onSuccess após o login bem-sucedido, se fornecida
      if (onSuccess != null) {
        onSuccess();
      }
    } catch (e) {
      print('Erro ao autenticar com o Google: $e');
    }
  }
}
