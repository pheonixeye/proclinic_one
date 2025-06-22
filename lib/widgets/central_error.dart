import 'package:flutter/material.dart';
import 'package:proklinik_one/assets/assets.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/shell_function.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:provider/provider.dart';

class CentralError extends StatelessWidget {
  const CentralError({
    super.key,
    required this.code,
    required this.toExecute,
  });
  final int code;
  final Future<void> Function() toExecute;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card.outlined(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              Image.asset(
                AppAssets.errorIcon,
                width: 75,
                height: 75,
              ),
              Text(
                CodeToError(code)
                    .errorMessage(context.read<PxLocale>().isEnglish),
                textAlign: TextAlign.center,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await shellFunction(
                    context,
                    toExecute: () async {
                      await toExecute();
                    },
                  );
                },
                label: Text(context.loc.retry),
                icon: Icon(
                  Icons.refresh,
                  color: Colors.green.shade100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
