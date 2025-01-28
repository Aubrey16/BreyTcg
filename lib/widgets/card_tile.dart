import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  const CardTile({
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(name),
      onTap: onTap,
    );
  }
}
