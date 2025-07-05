import 'package:flutter/material.dart';
import 'package:proklinik_one/models/patient.dart';

class VisitDetailsPageInfoHeader extends StatelessWidget {
  const VisitDetailsPageInfoHeader({
    super.key,
    required this.patient,
    required this.title,
    required this.iconData,
    this.actionButton,
  });
  final Patient patient;
  final String title;
  final IconData iconData;
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(iconData),
        ),
        title: Text(
          patient.name,
        ),
        subtitle: Text(title),
        trailing: actionButton,
      ),
    );
  }
}
