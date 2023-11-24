import 'package:flutter/material.dart';

class PopupButtonDropdownAppbar extends StatelessWidget {
  const PopupButtonDropdownAppbar({
    super.key,
    required this.voidActionButton01,
    required this.iconForActionButton01,
    required this.textValueForActionButton01,
  });

  final Function voidActionButton01;
  final IconData iconForActionButton01;
  final String textValueForActionButton01;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (String result) {
        //print('Opção selecionada: $result');
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: textValueForActionButton01,
          child: ListTile(
            onTap: () => voidActionButton01(),
            leading: Icon(iconForActionButton01),
            title: Text(
              textValueForActionButton01,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ),
        ),
        // PopupMenuItem<String>(
        //   value: 'Excluir',
        //   child: ListTile(
        //     onTap: () => {
        //       showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //             title: Text(
        //               'Confirmação',
        //               style: TextStyle(
        //                 color: Theme.of(context).textTheme.bodyMedium!.color,
        //               ),
        //             ),
        //             content: Text('Tem certeza de que deseja excluir?',
        //                 style: TextStyle(
        //                   color: Theme.of(context).textTheme.bodyMedium!.color,
        //                 )),
        //             actions: [
        //               TextButton(
        //                 onPressed: () => Navigator.of(context).pop(false),
        //                 child: const Text('Não'),
        //               ),
        //               TextButton(
        //                 onPressed: () {
        //                   deletingSelectedRegister();
        //                   Navigator.of(context).pop(true);
        //                 },
        //                 child: const Text('Sim'),
        //               ),
        //             ],
        //           );
        //         },
        //       ),
        //     },
        //     leading: const Icon(Icons.delete),
        //     title: Text(
        //       'Excluir',
        //       style: TextStyle(
        //         color: Theme.of(context).textTheme.bodyMedium!.color,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
