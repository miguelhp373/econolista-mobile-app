import 'package:econolista_app/app/modules/supermarket_list/supermarket_list.dart';
import 'package:flutter/material.dart';

import '../../auth/auth_user_controller/auth_user_controller.dart';
import '../custom_bool_alert_dialog/custom_bool_alert_dialog.dart';

class DrawerSidebar extends StatelessWidget {
  const DrawerSidebar({
    super.key,
    this.authUserPhoto,
    this.authUserName,
    this.authUserEmail,
  });

  final String? authUserPhoto;
  final String? authUserName;
  final String? authUserEmail;

  @override
  Widget build(BuildContext context) {
    final isAuthUserController = AuthUserController();
    final displayUserName =
        authUserName!.length > 30 ? authUserName?.split(' ')[0] : authUserName;

    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xffE6E6E6),
                        radius: 30,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: authUserPhoto != ''
                              ? Image.network(authUserPhoto!)
                              : const Icon(Icons.person, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        displayUserName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                )),
            ListTile(
              leading: const Icon(Icons.store),
              title: Text(
                'Lista de Supermercados',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        SupermarketList(userEmail: authUserEmail),
                  ),
                )
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () => {
                CustomBoolAlertDialog()
                    .showBooleanAlertDialog(context, 'Sair Da Aplicação',
                        'Tem Certeza Que Deseja Sair?')
                    .then(
                  (confirmed) {
                    if (confirmed!) {
                      isAuthUserController.signOut();
                    }
                  },
                ),
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.45),
            const SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Versão 1.0.0',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
