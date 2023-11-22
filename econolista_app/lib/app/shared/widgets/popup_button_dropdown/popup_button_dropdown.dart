import 'package:flutter/material.dart';

class PopupButtonDropdown extends StatelessWidget {
  const PopupButtonDropdown(
      {super.key,
      required this.editingSelectedRegister,
      required this.deletingSelectedRegister});

  final Function editingSelectedRegister;
  final Function deletingSelectedRegister;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (String result) {
        //print('Opção selecionada: $result');
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'Editar',
          child: ListTile(
            onTap: () => editingSelectedRegister(),
            leading: const Icon(Icons.edit),
            title: Text(
              'Editar',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: 'Excluir',
          child: ListTile(
            onTap: () => deletingSelectedRegister(),
            leading: const Icon(Icons.delete),
            title: Text(
              'Excluir',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
