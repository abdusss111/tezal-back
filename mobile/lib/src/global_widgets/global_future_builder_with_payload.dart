import 'dart:developer';

import 'package:eqshare_mobile/src/core/data/models/payload/payload.dart';
import 'package:eqshare_mobile/src/core/data/services/storage/token_provider_service.dart';
import 'package:eqshare_mobile/src/global_widgets/global_future_builder.dart';
import 'package:flutter/material.dart';

class GlobalFutureBuilderWithPayload<T,K> extends StatelessWidget {
  final Widget? errorWidget;
  final Widget? circularProgressWidget;
  final Widget Function(T data,Payload payload) buildWidgetForClient;
  final Widget Function(K data,Payload payload) buildWidgetForDriverOrOwner;
  final Widget? emptyDataWidget;
  final Future<T> futureForClient;
  final Future<K> futureForDriverOrOwner;


  const GlobalFutureBuilderWithPayload({
    super.key,
    this.errorWidget,
    this.circularProgressWidget,
    required this.buildWidgetForClient,
    required this.buildWidgetForDriverOrOwner,
    this.emptyDataWidget,
    required this.futureForClient,
    required this.futureForDriverOrOwner,

  });

  Future<Payload?> getPayload() async {
    final token = await TokenService().getToken();
    if(token!= null){
   final payload = TokenService().extractPayloadFromToken(token!);
    return payload;
    }
    return null;
 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Payload?>(
        future: getPayload(),
        builder: (context, payloadSnapshot) {
          if (payloadSnapshot.connectionState == ConnectionState.waiting) {
            return circularProgressWidget ??
                const Center(child: CircularProgressIndicator());
          } else if (payloadSnapshot.hasError) {

            log(payloadSnapshot.toString(),name: 'Error with payload');

            return errorWidget ??
                const Center(child: Text('Ошибка загрузки данных'));
          } else if (!payloadSnapshot.hasData) {
            log(payloadSnapshot.toString(),name: 'Error with payload');
             return GlobalFutureBuilder<T>(
                future: futureForClient,
                buildWidget: (data) => buildWidgetForClient(data,payloadSnapshot.data ?? Payload()),
                errorWidget: errorWidget,
                circularProgressWidget: circularProgressWidget,
                emptyDataWidget: emptyDataWidget,
              );
            // return emptyDataWidget ?? const Center(child: Text('Нет данных'));
          } else {
            final payload = payloadSnapshot.data!;
            log(payload.toString(),name: 'Payload: ');
            if (payload.aud == 'CLIENT') {
              return GlobalFutureBuilder<T>(
                future: futureForClient,
                buildWidget: (data) => buildWidgetForClient(data,payload),
                errorWidget: errorWidget,
                circularProgressWidget: circularProgressWidget,
                emptyDataWidget: emptyDataWidget,
              );
            } else {
              return GlobalFutureBuilder<K>(
                future: futureForDriverOrOwner,
                buildWidget: (data) => buildWidgetForDriverOrOwner(data,payload),
                errorWidget: errorWidget,
                circularProgressWidget: circularProgressWidget,
                emptyDataWidget: emptyDataWidget,
              );
            }
          }
        },
      ),
    );
  }
}
