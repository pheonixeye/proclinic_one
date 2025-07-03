import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/widgets/central_error.dart';
import 'package:proklinik_one/widgets/central_loading.dart';

class BuildLoadErrorStateWidget<T> extends StatelessWidget {
  const BuildLoadErrorStateWidget({
    super.key,
    required this.child,
    required this.result,
    required this.retry,
  });
  final Widget child;
  final ApiResult<T>? result;
  final Future<void> Function() retry;
  @override
  Widget build(BuildContext context) {
    //TODO: needs to be refactored to accept being generic
    while (result == null) {
      return const CentralLoading();
    }

    while (result is ApiErrorResult) {
      return CentralError(
        code: (result as ApiErrorResult).errorCode,
        toExecute: retry,
      );
    }
    while (result != null &&
            result is ApiDataResult<T> &&
            (((result as ApiDataResult<T>).data is List<T> &&
                (result as ApiDataResult<List<T>>).data.isEmpty)) ||
        // ignore: unnecessary_type_check
        ((result as ApiDataResult<T>)).data is T) {
      return Center(
        child: Card.outlined(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(context.loc.noItemsFound),
          ),
        ),
      );
    }
    return child;
  }
}
