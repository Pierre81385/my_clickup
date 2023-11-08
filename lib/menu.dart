import 'package:flutter/material.dart';

class MenuComponent extends StatefulWidget {
  const MenuComponent({super.key});

  @override
  State<MenuComponent> createState() => _MenuComponentState();
}

class _MenuComponentState extends State<MenuComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Requires JWT'),
            OutlinedButton(onPressed: () {}, child: Text('POST: Login')),
            OutlinedButton(onPressed: () {}, child: Text('GET: Trash')),
            OutlinedButton(onPressed: () {}, child: Text('GET: Automations')),
          ],
        ),
      ),
    );
  }
}
