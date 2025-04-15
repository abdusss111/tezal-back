import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'ad_sm_client_request_create_controller.dart';

class AdSMClientRequestCreateScreen extends StatefulWidget {
  final String adClientId;
  final String type;

  const AdSMClientRequestCreateScreen(
      {super.key, required this.adClientId, required this.type});

  @override
  State<AdSMClientRequestCreateScreen> createState() =>
      _AdSMClientRequestCreateScreenState();
}

class _AdSMClientRequestCreateScreenState
    extends State<AdSMClientRequestCreateScreen> {
  late AdSMClientRequestCreateController controller;

  @override
  void initState() {
    super.initState();
    controller =
        Provider.of<AdSMClientRequestCreateController>(context, listen: false);
    controller.loadUserMode(context);
    controller.setupWorkers(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказ клиенту'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Consumer<AdSMClientRequestCreateController>(
          builder: (context, controller, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Детали заказа:',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                buildDescription(),
                const SizedBox(height: 16),
                AppPrimaryButtonWidget(
                    textColor: Colors.white,
                    onPressed: () async => await controller.onButtonPressed(
                        context,
                        adClientId: widget.adClientId,
                        type: widget.type),
                    text:  AppChangeNotifier().userMode == UserMode.client ||
                            AppChangeNotifier().userMode == UserMode.guest
                        ? 'Отправить заказ'
                        : 'Принять заказ'),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }

  Column buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          maxLines: 3,
          controller: controller.descriptionController,
          decoration: InputDecoration(
            hintText: 'Введите описание заказа',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
