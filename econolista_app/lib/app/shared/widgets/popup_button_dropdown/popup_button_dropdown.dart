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
            onTap: () => {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Confirmação',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    content: Text('Tem certeza de que deseja excluir?',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        )),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Não'),
                      ),
                      TextButton(
                        onPressed: () {
                          deletingSelectedRegister();
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Sim'),
                      ),
                    ],
                  );
                },
              )
            },
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
