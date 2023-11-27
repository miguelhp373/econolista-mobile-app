// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econolista_app/app/shared/widgets/popup_button_dropdown/popup_button_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/database/shopping_list_collection/shopping_list_collection.dart';
import '../../../shared/models/purchased_models.dart';
import '../../../shared/utils/converter_strings.dart';
import '../../purchase_details/purchase_details.dart';

class MyPurchasesMade extends StatelessWidget {
  const MyPurchasesMade({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: ShoppingListCollection()
              .fetchShoppingList(
                FirebaseAuth.instance.currentUser?.email,
                'Encerrada',
              )
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
                              documentSnapshot['MarketName'].toString(),
                        ),
                        trailing: PopupButtonDropdown(
                          editingSelectedRegister: () => Navigator.push(
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
                          deletingSelectedRegister: () async {
                            final deletingAction =
                                await ShoppingListCollection()
                                    .deleteShoppingList(documentSnapshot.id);

                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    deletingAction[0]['message'],
                                  ),
                                ),
                              );
                              Navigator.of(context).pop();
                            } catch (e) {
                              ///
                            }
                          },
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
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, size: 30),
                      const SizedBox(height: 10),
                      Text(
                        'Não Há Lista de Compras Finalizadas',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
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
