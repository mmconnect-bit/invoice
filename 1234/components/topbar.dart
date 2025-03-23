import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Product List', style: TextStyle(fontSize: 20)),
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            icon: const CircleAvatar(child: Icon(Icons.person)),
            items: const [DropdownMenuItem(child: Text('Manager User'))],
            onChanged: (value) {},
          ),
        ),
      ],
    );
  }
}
