import 'package:econolista_app/app/shared/widgets/drawer_sidebar/drawer_sidebar.dart';
import 'package:flutter/material.dart';

import 'package:econolista_app/app/modules/home/tabs/my_purchases_made.dart';
import 'package:econolista_app/app/modules/home/tabs/my_shopping_lists.dart';

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
      appBar: AppBar(
        title: const Text('EconoLista App'),
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
      drawer: const DrawerSidebar(),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: MyShoppingLists()),
          Center(child: MyPurchasesMade()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => {},
      ),
    );
  }
}
