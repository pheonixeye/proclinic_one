import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';

class CentralLoading extends StatelessWidget {
  const CentralLoading({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO: show specialities icons spinning
    return Center(
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              color: Colors.blue.shade500,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(context.loc.loading)
          ],
        ),
      ),
    );
  }
}
