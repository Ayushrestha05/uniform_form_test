import 'package:flutter/material.dart';

import '../../domain/entity/form_entity.dart';

class ErrorFormWidget extends StatelessWidget {
  final Map errors;
  const ErrorFormWidget({super.key, required this.errors});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.redAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Errors Found in Form!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...errors.entries.map((e) {
              if (e.value.toString().toLowerCase() != 'none') {
                return Text('${e.key}: ${e.value}');
              } else {
                return const SizedBox.shrink();
              }
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class SuccessFormWidget extends StatelessWidget {
  final FormEntity formEntity;
  const SuccessFormWidget({super.key, required this.formEntity});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.greenAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Form Submitted Successfully!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...formEntity.formResults.map((e) {
              return Text('${e.label}: ${e.value}');
            }).toList(),
          ],
        ),
      ),
    );
  }
}
