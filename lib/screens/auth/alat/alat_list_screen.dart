import 'package:flutter/material.dart';
import 'package:target_3/widgets/alat_card.dart';

class AlatList extends StatelessWidget {
  const AlatList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (_, i) => const AlatCard(),
    );
  }
}