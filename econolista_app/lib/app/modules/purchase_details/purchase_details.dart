import 'package:econolista_app/app/shared/models/purchased_models.dart';
import 'package:flutter/material.dart';
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

  late TextEditingController _descriptionTextInput;
  //late TextEditingController _marketNameDropDownInput;
  late TextEditingController _dateTimeCreatedTextInput;
  late bool _futurePuchasedCheckBox;

  @override
  void initState() {
    super.initState();

    _descriptionTextInput =
        TextEditingController(text: widget.purchasedModels.description);

    // _marketNameDropDownInput =
    //     TextEditingController(text: widget.purchasedModels.marketName);

    _dateTimeCreatedTextInput = TextEditingController(
        text: widget.purchasedModels.dateTimeCreated.toString());

    _futurePuchasedCheckBox = widget.purchasedModels.futurePuchased;
    _isFuturePurchase = _futurePuchasedCheckBox;
  }

  @override
  void dispose() {
    _descriptionTextInput.dispose();
    //_marketNameDropDownInput.dispose();
    _dateTimeCreatedTextInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
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
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
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
                  //onSaved: (value) => _formData['service_description'] = value!,
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: DropdownButtonFormField(
                    //enableFeedback: _hasPermissionForEdit,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    items: [],
                    // _customersList
                    //     .map(
                    //       (item) => DropdownMenuItem(
                    //         value: item,
                    //         child: Text(item),
                    //       ),
                    //     )
                    //     .toList(),
                    onChanged: (item) =>
                        _isMarketNameSelected = item! as String?,
                    //value: isSelectedOptionOnDropDown,
                    validator: (value) {
                      if (value == 'Selecione A Empresa') {
                        return 'Nenhuma Empresa Selecionada!';
                      }
                      return null;
                    },
                    //onSaved: (value) => _formData['customer_name'] = value!,
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
                  //enabled: _hasPermissionForEdit,
                  type: DateTimePickerType.dateTime,
                  dateMask: 'dd/MM/yyyy HH:mm',
                  icon: const Icon(Icons.event),
                  //initialValue: _formData['service_initial_datetime'] ??
                  // DateTime.now().toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione uma data e hora inicial.';
                    }

                    try {
                      DateTime.parse(value);
                    } catch (e) {
                      return 'Data e hora inicial válida.';
                    }

                    return null;
                  },
                  // onSaved: (value) =>
                  //     _formData['service_initial_datetime'] = value!,
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
                      //backgroundColor: kBackgroundColorGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Criar Lista de Compras',
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
