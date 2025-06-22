import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proklinik_one/models/patient.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

class PatientInfoCard extends StatefulWidget {
  const PatientInfoCard({
    super.key,
    required this.patient,
    required this.index,
  });
  final Patient patient;
  final int index;

  @override
  State<PatientInfoCard> createState() => _PatientInfoCardState();
}

class _PatientInfoCardState extends State<PatientInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: FloatingActionButton.small(
            heroTag: widget.patient.id,
            onPressed: null,
            child: Text('${widget.index + 1}'),
          ),
          title: Text(widget.patient.name),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  DateFormat(
                    'dd/MM/yyyy',
                    context.read<PxLocale>().lang,
                  ).format(
                    DateTime.parse(widget.patient.dob),
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: widget.patient.phone,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        web.window.open(
                          'tel://+2${widget.patient.phone}',
                          '_blank',
                        );
                      },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
