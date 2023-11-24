// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'package:econolista_app/app/modules/purchase_products_list/purchase_products_list.dart';
import 'package:econolista_app/app/shared/widgets/popup_button_dropdown_appbar/popup_button_dropdown_appbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:econolista_app/app/shared/models/purchased_models.dart';
import 'package:econolista_app/app/shared/database/shopping_list_collection/shopping_list_collection.dart';

import 'package:date_time_picker/date_time_picker.dart';

class PurchaseDetails extends StatefulWidget {
  const PurchaseDetails({super.key, required this.purchasedModels});

  final PurchasedModels purchasedModels;

  @override
  State<PurchaseDetails> createState() => _PurchaseDetailsState();
}

class _PurchaseDetailsState extends State<PurchaseDetails> {
  String? _isMarketNameSelected;
  bool? _isFuturePurchase = false;
  String? _purchasedId;
  bool? _hasShowProductsList = false;
  bool? _statusShoppingList;

  late Future<Map<String, dynamic>> isShoppingListCollection;
  late TextEditingController _descriptionTextInput;
  late TextEditingController _dateTimeCreatedTextInput;
  late bool _futurePuchasedCheckBox;
  late TextEditingController _statusTextInputReadOnly;

  final _formKey = GlobalKey<FormState>();

  final _userAuthId = FirebaseAuth.instance.currentUser?.uid;

  void _submitForm(
      BuildContext context, PurchasedModels purchasedModels) async {
    if (_formKey.currentState!.validate()) {
      final submitJsonResult = await ShoppingListCollection()
          .formSubmitShoppingList(purchasedModels);

      if (submitJsonResult[0]['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              submitJsonResult[0]['message'],
            ),
          ),
        );
        _hasShowProductsList = true;

        if (submitJsonResult[0]['type'] == 'create') {
          _purchasedId = submitJsonResult[0]['shoppingID'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PurchaseProductsList(
                shoppingId: _purchasedId,
              ),
            ),
          );
        }

        //Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              submitJsonResult[0]['message'],
            ),
          ),
        );
      }
    }
  }

  void _moreVerticalPopupDropDownActions(BuildContext context) {
    ShoppingListCollection().updateStatusShoppingList(
      _purchasedId.toString(),
      _statusShoppingList == false ? 'Aberta' : 'Encerrada',
    );
    setState(() {
      _statusShoppingList = _statusShoppingList == false ? true : false;

      _statusTextInputReadOnly = TextEditingController(
        text: _statusShoppingList == true
            ? 'Status | Aberta'
            : 'Status | Encerrada',
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _statusShoppingList == true
              ? 'Lista de Compras Aberta com Sucesso'
              : 'Lista de Compras Encerrada com Sucesso',
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    _purchasedId = widget.purchasedModels.purchasedId;

    _hasShowProductsList = _purchasedId?.isNotEmpty;

    _descriptionTextInput =
        TextEditingController(text: widget.purchasedModels.description);

    _dateTimeCreatedTextInput = TextEditingController(
        text: widget.purchasedModels.dateTimeCreated.toString());

    _futurePuchasedCheckBox = widget.purchasedModels.futurePuchased;
    _isFuturePurchase = _futurePuchasedCheckBox;

    _statusTextInputReadOnly = TextEditingController(
        text: 'Status | ${widget.purchasedModels.status}');

    _statusShoppingList =
        widget.purchasedModels.status == 'Aberta' ? true : false;

    isShoppingListCollection =
        ShoppingListCollection().getStoreListForDropdownList(_userAuthId!);

    _isMarketNameSelected = widget.purchasedModels.marketName == ''
        ? 'Selecione o Supermercado'
        : widget.purchasedModels.marketName;
  }

  @override
  void dispose() {
    _descriptionTextInput.dispose();
    _dateTimeCreatedTextInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Informações'),
          centerTitle: true,
          actions: [
            PopupButtonDropdownAppbar(
              voidActionButton01: () =>
                  _moreVerticalPopupDropDownActions(context),
              iconForActionButton01: Icons.check_circle_outline,
              textValueForActionButton01: _statusShoppingList == false
                  ? 'Reabrir Lista de Compras'
                  : 'Encerrar Lista de Compras',
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  //description caption
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: const Text(
                        'Descrição',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  //description input
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _descriptionTextInput,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'Insira a Descrição da Lista',
                        hintStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                      //initialValue: _descriptionTextInput,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'A descrição deve ser preenchida!';
                        }
                        return null;
                      },
                    ),
                  ),
                  //Market Caption
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: const Text(
                        'Supermercado',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  //Market Input
                  // Market Input
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: FutureBuilder(
                        future: isShoppingListCollection,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
                          } else if (snapshot.hasError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Erro ao Carregar a Lista de Supermercados',
                                ),
                              ),
                            );
                            return const SizedBox();
                          } else {
                            List<String> storeNames = (snapshot.data
                                as Map<String, dynamic>)['storeNames'];

                            List<DropdownMenuItem<String>> items = storeNames
                                .map(
                                  (storeName) => DropdownMenuItem(
                                    value: storeName,
                                    child: Text(
                                      storeName,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .color,
                                      ),
                                    ),
                                  ),
                                )
                                .toList();

                            return DropdownButtonFormField<String>(
                              value: _isMarketNameSelected,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context)
                                    .inputDecorationTheme
                                    .fillColor,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              items: items,
                              onChanged: (item) => _isMarketNameSelected = item,
                              validator: (value) {
                                if (value == 'Selecione o Supermercado') {
                                  return 'Nenhum Supermercado Selecionado!';
                                }
                                return null;
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  //Data/Hora Caption
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: const Text(
                        'Data / Hora',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  //Data/Hora Input

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: DateTimePicker(
                      controller: _dateTimeCreatedTextInput,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color),
                      type: DateTimePickerType.dateTime,
                      dateMask: 'dd/MM/yyyy HH:mm',
                      icon: const Icon(Icons.event),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, selecione uma data e hora valida!';
                        }
                        return null;
                      },
                    ),
                  ),
                  //Agendar Compra CheckBox
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          value: _isFuturePurchase,
                          onChanged: (bool? value) {
                            setState(() => _isFuturePurchase = value!);
                          },
                        ),
                        const Text('Agendar Compra')
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  //description input
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      enabled: false,
                      controller: _statusTextInputReadOnly,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            Theme.of(context).inputDecorationTheme.fillColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      margin: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _purchasedId!.isEmpty
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add),
                                    SizedBox(width: 5),
                                    Text('Criar Lista de Compras')
                                  ],
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save),
                                    SizedBox(width: 5),
                                    Text('Salvar Alterações')
                                  ],
                                ),
                          onPressed: () => _submitForm(
                            context,
                            PurchasedModels(
                              purchasedId: _purchasedId!,
                              userId: _userAuthId!,
                              description: _descriptionTextInput.text,
                              dateTimeCreated: DateTime.parse(
                                  _dateTimeCreatedTextInput.text),
                              marketName: _isMarketNameSelected!,
                              productsList: [],
                              futurePuchased: _isFuturePurchase!,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: MediaQuery.of(context).size.width / 4.5,
                      margin: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _hasShowProductsList == true
                              ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PurchaseProductsList(
                                        shoppingId: _purchasedId,
                                      ),
                                    ),
                                  )
                              : null,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Icon(Icons.shopping_cart)],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ]);
  }
}
