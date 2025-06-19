import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proklinik_one/models/patient.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class CreatePatientDialog extends StatefulWidget {
  const CreatePatientDialog({super.key});

  @override
  State<CreatePatientDialog> createState() => _CreatePatientDialogState();
}

class _CreatePatientDialogState extends State<CreatePatientDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  DateTime? _dob;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text('Add New Patient')),
          IconButton.outlined(
            onPressed: () {
              Navigator.pop(context, null);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.all(8),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Name'),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'رباعي بالعربي',
                  ),
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter patient name';
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Mobile Number'),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '01XX-XXXX-XXX',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter patient phone';
                    }
                    if (value.length != 11) {
                      return 'enter valid patient phone';
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Date Of Birth'),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'dd-MM-yyyy',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'select patient date of birth';
                    }
                    return null;
                  },
                  enabled: false,
                ),
              ),
              trailing: FloatingActionButton.small(
                heroTag: 'patient-dob-picker',
                onPressed: () async {
                  _dob = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now().subtract(
                      const Duration(days: 36525),
                    ),
                    lastDate: DateTime.now(),
                  );
                  if (_dob == null) {
                    return;
                  }
                  setState(() {
                    _dobController.text = DateFormat(
                      'dd-MM-yyyy',
                      context.read<PxLocale>().lang,
                    ).format(_dob!);
                  });
                },
                child: const Icon(Icons.calendar_month),
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: [
        ElevatedButton.icon(
          onPressed: () {
            if (formKey.currentState!.validate() && _dob != null) {
              final _patient = Patient(
                id: '',
                name: _nameController.text,
                phone: _phoneController.text,
                dob: _dob!.toIso8601String(),
              );
              Navigator.pop(context, _patient);
            }
          },
          label: Text('Confirm'),
          icon: const Icon(Icons.check),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, null);
          },
          label: Text('Cancel'),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}
