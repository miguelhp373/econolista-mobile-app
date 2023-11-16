// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:econolista_app/app/shared/models/purchased_models.dart';
import 'package:econolista_app/app/shared/database/shopping_list_collection/shopping_list_collection.dart';

import 'package:econolista_app/app/shared/widgets/scaffold_message_alert/scaffold_message_alert.dart';
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

  late Future<Map<String, dynamic>> isShoppingListCollection;
  late TextEditingController _descriptionTextInput;
  late TextEditingController _dateTimeCreatedTextInput;
  late bool _futurePuchasedCheckBox;

  final _formKey = GlobalKey<FormState>();

  final _userAuthId = FirebaseAuth.instance.currentUser?.uid;

  void _submitForm(
      BuildContext context, PurchasedModels purchasedModels) async {
    if (_formKey.currentState!.validate()) {
      final submitSuccess = await ShoppingListCollection()
          .formSubmitShoppingList(purchasedModels);

      if (submitSuccess == true) {
        ScaffoldMessengeAlert().showMessageOnDisplayBottom(
            context, 'Lista de Compras Criada Com Sucesso!');
        Navigator.pop(context);
      } else {
        ScaffoldMessengeAlert().showMessageOnDisplayBottom(
            context, 'Erro ao Tentar Criar Lista de Compras, Tente Novamente!');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _purchasedId = widget.purchasedModels.purchasedId;

    _descriptionTextInput =
        TextEditingController(text: widget.purchasedModels.description);

    _dateTimeCreatedTextInput = TextEditingController(
        text: widget.purchasedModels.dateTimeCreated.toString());

    _futurePuchasedCheckBox = widget.purchasedModels.futurePuchased;
    _isFuturePurchase = _futurePuchasedCheckBox;

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
      appBar: AppBar(),
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
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          ScaffoldMessengeAlert().showMessageOnDisplayBottom(
                            context,
                            'Erro ao Carregar a Lista de Supermercados',
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
                  padding: const EdgeInsets.all(5.0),
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
                SizedBox(height: MediaQuery.of(context).size.height / 8),
                Container(
                  margin: const EdgeInsets.only(top: 30),
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
                          ? const Text('Criar Lista de Compras')
                          : const Text('Salvar Alterações'),
                      onPressed: () => _submitForm(
                        context,
                        PurchasedModels(
                          purchasedId: _purchasedId!,
                          userId: _userAuthId!,
                          description: _descriptionTextInput.text,
                          dateTimeCreated:
                              DateTime.parse(_dateTimeCreatedTextInput.text),
                          marketName: _isMarketNameSelected!,
                          productsList: [],
                          futurePuchased: _isFuturePurchase!,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
