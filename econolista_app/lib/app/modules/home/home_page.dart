import 'package:econolista_app/app/shared/models/purchased_models.dart';
import 'package:econolista_app/app/shared/widgets/drawer_sidebar/drawer_sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:econolista_app/app/modules/home/tabs/my_purchases_made.dart';
import 'package:econolista_app/app/modules/home/tabs/my_shopping_lists.dart';

import '../purchase_details/purchase_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerSidebar(
        authUserPhoto: FirebaseAuth.instance.currentUser?.photoURL,
        authUserName: FirebaseAuth.instance.currentUser?.displayName,
        authUserEmail: FirebaseAuth.instance.currentUser?.email,
      ),
      appBar: AppBar(
        title: const Text('EconoLista'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.note_alt),
              text: 'Listas de Compras',
            ),
            Tab(
              icon: Icon(Icons.shopping_bag),
              text: 'Compras Realizadas',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: MyShoppingLists()),
          Center(child: MyPurchasesMade()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseDetails(
              purchasedModels: PurchasedModels(
                dateTimeCreated: DateTime.now(),
                productsList: [],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
