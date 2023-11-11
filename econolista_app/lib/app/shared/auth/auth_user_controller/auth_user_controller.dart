import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:econolista_app/app/modules/home/home_page.dart';
import 'package:econolista_app/app/modules/login/login.dart';

class AuthUserController {
  //3 steps
  // 1 - handleAuthState()
  // 2 - SignInWithGoogle()
  // 3 - SignOut()

  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if ((snapshot.hasData)) {
          ///////////////////////////////////////////////////////////////
          //final userFirebaseInstance = FirebaseAuth.instance.currentUser;

          // if (userFirebaseInstance != null) {
          //   PlataformUsersController().putUserIntoPlaform(
          //     PlataformUsers(
          //       user_id: '',
          //       user_email: userFirebaseInstance.email!,
          //       user_profile_photo: userFirebaseInstance.photoURL!,
          //       user_name: userFirebaseInstance.displayName!,
          //       user_notifications: {},
          //       user_partners: {},
          //       user_settings: {},
          //       user_level: '',
          //       last_access_log: DateTime.now().toString(),
          //     ),
          //     context,
          //   );
          // }
          ///////////////////////////////////////////////////////////////
          return const HomePage();
        }
        return const Login();
      },
    );
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
