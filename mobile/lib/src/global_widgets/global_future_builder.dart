import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:flutter/material.dart';

class GlobalFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;

  final Widget? errorWidget;
  final Widget? circularProgressWidget;
  final Widget Function(T data) buildWidget;
  final Widget? emptyDataWidget;

  const GlobalFutureBuilder({
    super.key,
    required this.future,
    this.errorWidget,
    this.circularProgressWidget,
    required this.buildWidget,
    this.emptyDataWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return circularProgressWidget ??
                const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return errorWidget ??
                Center(child: Text('hasError:${snapshot.error}'));
          } else if (snapshot.data == null &&
              (snapshot.data.runtimeType == Payload )) {
            return buildWidget(snapshot.data as T);

            // return errorWidget ?? const Center(child: Text('Empty'));
          } else if (snapshot.data == null) {
            return buildWidget(snapshot.data as T);

            // return errorWidget ?? const Center(child: Text('Empty'));
          } else {
            return buildWidget(snapshot.data as T);
          }
        });
  }
}
