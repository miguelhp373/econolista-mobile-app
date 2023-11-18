// ignore_for_file: prefer_interpolation_to_compose_strings, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econolista_app/app/shared/database/shopping_list_collection/shopping_list_collection.dart';
import 'package:econolista_app/app/shared/utils/converter_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/models/purchased_models.dart';
import '../../purchase_details/purchase_details.dart';

class MyShoppingLists extends StatelessWidget {
  const MyShoppingLists({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: ShoppingListCollection()
              .fetchShoppingList(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              if (streamSnapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.shopping_cart)],
                        ),
                        tileColor: const Color(0xFFced7db),
                        title: Text(
                          documentSnapshot['Description']
                              .toString()
                              .toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        subtitle: Text(
                          ConverterStrings().convertTimeStampToString(
                                documentSnapshot['DateTimeCreated'],
                              ) +
                              ' | ' +
                              documentSnapshot['MarketName']
                                  .toString()
                                  .substring(0, 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => {},
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PurchaseDetails(
                              purchasedModels: PurchasedModels(
                                description: documentSnapshot['Description'],
                                dateTimeCreated:
                                    documentSnapshot['DateTimeCreated']
                                        .toDate(),
                                marketName: documentSnapshot['MarketName'],
                                futurePuchased:
                                    documentSnapshot['ScheduledPurchase'],
                                purchasedId: documentSnapshot.id,
                                status: documentSnapshot['Status'],
                                productsList: [],
                              ),
                            ),
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text('Não Há Dados Para Demonstrar',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                      )),
                );
              }
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
