import 'package:econolista_app/app/shared/database/user_collection/user_collection.dart';
import 'package:econolista_app/app/shared/models/user_models.dart';
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
          final userFirebaseInstance = FirebaseAuth.instance.currentUser;

          if (userFirebaseInstance != null) {
            UserCollection().putUserCollection(
              UserModels(
                userName: userFirebaseInstance.displayName!,
                userEmail: userFirebaseInstance.email!,
                userStoreCollection: {},
              ),
            );
          }

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
