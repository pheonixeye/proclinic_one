import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/models/patient.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class CreateEditPatientDialog extends StatefulWidget {
  const CreateEditPatientDialog({super.key, this.patient});
  final Patient? patient;

  @override
  State<CreateEditPatientDialog> createState() =>
      _CreateEditPatientDialogState();
}

class _CreateEditPatientDialogState extends State<CreateEditPatientDialog> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient?.name ?? '');
    _phoneController = TextEditingController(text: widget.patient?.phone ?? '');
    _dobController = TextEditingController(
        text: DateFormat(
      'dd-MM-yyyy',
      context.read<PxLocale>().lang,
    ).format(DateTime.tryParse(widget.patient?.dob ?? '') ?? DateTime.now()));
    _emailController = TextEditingController(text: widget.patient?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  late DateTime? _dob = DateTime.parse(widget.patient?.dob ?? '');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: widget.patient == null
                ? Text(context.loc.addNewPatient)
                : Text(context.loc.editPatientData),
          ),
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
                child: Text(context.loc.name),
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
                      return context.loc.enterPatientName;
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.mobileNumber),
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
                      return context.loc.enterPatientPhone;
                    }
                    if (value.length != 11) {
                      return context.loc.enterValidPatientPhone;
                    }
                    return null;
                  },
                ),
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.dateOfBirth),
              ),
              titleAlignment: ListTileTitleAlignment.center,
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'dd-MM-yyyy',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.loc.selectPatientDateOfBirth;
                          }
                          return null;
                        },
                        enabled: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: FloatingActionButton.small(
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
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.email),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'test@example.com',
                  ),
                  validator: _emailController.text.trim().isEmpty
                      ? null
                      : (value) {
                          if (value != null &&
                              !EmailValidator.validate(value)) {
                            return context.loc.invalidEmailAddress;
                          }
                          return null;
                        },
                ),
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
                id: widget.patient?.id ?? '',
                name: _nameController.text,
                phone: _phoneController.text,
                dob: _dob!.toIso8601String(),
                email: _emailController.text,
              );
              Navigator.pop(context, _patient);
            }
          },
          label: Text(context.loc.confirm),
          icon: Icon(
            Icons.check,
            color: Colors.green.shade100,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.pop(context, null);
          },
          label: Text(context.loc.cancel),
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
