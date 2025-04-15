import 'dart:io';

import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/src/core/presentation/utils/date_format_helper.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_form_field_label.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/res/theme/app_colors.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_primary_button.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_build_amount_of_hours.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_request_description_input_field.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/ad_total_price_widget.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/app_location_picker_row_item.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'ad_sm_request_create_controller.dart';

class AdSMRequestCreateScreen extends StatefulWidget {
  final String adSMId;
  final double adSMPrice;

  const AdSMRequestCreateScreen(
      {super.key, required this.adSMId, required this.adSMPrice});

  @override
  State<AdSMRequestCreateScreen> createState() =>
      _AdSMRequestCreateScreenState();
}

class _AdSMRequestCreateScreenState extends State<AdSMRequestCreateScreen> {
  late AdSMRequestCreateController controller;
  @override
  void initState() {
    super.initState();
    controller =
        Provider.of<AdSMRequestCreateController>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация по аренде'),
        leading: IconButton(
          // onPressed: () => Navigator.pop(context),
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Consumer<AdSMRequestCreateController>(
          builder: (context, controller, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Детали аренды:',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                _buildDateTimePick(context),
                const SizedBox(height: 8),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Время окончания работы'),
                  value: controller.isEndTimeEnabled,
                  onChanged: (bool? newValue) {
                    controller.toggleEndTime(newValue);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 8),
                controller.isEndTimeEnabled == true
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.appFormFieldFillColor,
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppInputFieldLabel(
                                    text: 'Время окончания работы',
                                    isRequired: false),
                                const SizedBox(height: 5),
                                Text(
                                  controller.toDate != null
                                      ? DateTimeUtils.formatDateTimeLabel(
                                          controller.toDate!,
                                          controller.toTime!)
                                      : 'Выберите время',
                                ),
                              ],
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () async =>
                                  controller.showSecondDateTimePicker(context),
                              child: Text(
                                'Изменить',
                                style: Theme.of(context).textTheme.displaySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                if (controller.toDateTime != null &&
                    controller.fromDateTime != null) ...[
                  const SizedBox(height: 16),
                  buildAmountOfHours(),
                ],
                const SizedBox(height: 16),
                buildImageOfObject(context),
                const SizedBox(height: 16),
                AdRequestDescriptionInputField(
                  textEditingController: controller.descriptionController,
                ),
                const SizedBox(height: 16),
                const AppInputFieldLabel(
                    text: 'Адрес работы', isRequired: true),
                const SizedBox(height: 8),
                AppLocationPickerRowItem(
                  onLocationSelected: controller.handleLocationSelected,
                  selectedAddress: controller.address,
                  hintText: 'Добавить адрес объекта',
                ),
                if (controller.toDateTime != null &&
                    controller.fromDateTime != null) ...[
                  const SizedBox(height: 16),
                  AdTotalPriceWidget(
                      totalPrice: (widget.adSMPrice *
                              (controller.calculateHoursDifference() ?? 0)
                                  .toDouble())
                          .toString())
                ],
                const SizedBox(height: 16),
                AppPrimaryButtonWidget(
                    buttonType: ButtonType.filled,
                    onPressed: () {
                      if (controller.isValid()) {
                        controller.onSendPressed(
                            context, widget.adSMId, widget.adSMPrice);
                      } else {
                        AppDialogService.showNotValidFormDialog(
                          context,
                        );
                      }
                    },
                    textColor: Colors.white,
                    text: AppChangeNotifier().userMode == UserMode.client ||
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

  Container _buildDateTimePick(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.appFormFieldFillColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppInputFieldLabel(
                    text: 'Время начала работы', isRequired: true),
                const SizedBox(height: 5),
                Text(
                  controller.fromDate != null
                      ? DateTimeUtils.formatDateTimeLabel(
                          controller.fromDate!, controller.fromTime!)
                      : 'Выберите время',
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () async =>
                  controller.showFirstDateTimePicker(context),
              child: Text(
                'Изменить',
                style: Theme.of(context).textTheme.displaySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column buildImageOfObject(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppInputFieldLabel(text: 'Фото объекта', isRequired: false),
        const SizedBox(height: 16),
        AppPrimaryButtonWidget(
          onPressed: () async {
            await controller.onSelectImageButtonPressed(context);
          },
          text: 'Добавить фото',
          icon: Icons.add_to_photos_outlined,
          buttonType: ButtonType.elevated,
        ),
        const SizedBox(height: 16),
        (controller.selectedImages.isNotEmpty &&
                controller.selectedImages.length > 1)
            ? GridView.builder(
                itemCount: controller.selectedImages.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 4.0),
                itemBuilder: (BuildContext context, int index) {
                  return (controller.selectedImages[index] == 'place_holder')
                      ? InkWell(
                          onTap: () async {
                            await controller
                                .onSelectImageButtonPressed(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 90,
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 28.0,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.file(
                                File(controller.selectedImages[index]),
                                fit: BoxFit.fitHeight,
                                width: MediaQuery.of(context).size.width,
                                height: 110,
                                filterQuality: FilterQuality.low,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 110,
                                    color: Colors.black,
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 15,
                              right: 8,
                              child: InkWell(
                                onTap: () {
                                  controller.removeImage(index);
                                },
                                child: const CircleAvatar(
                                  radius: 15.0,
                                  backgroundColor: Colors.black45,
                                  child: Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                },
              )
            : const SizedBox(),
      ],
    );
  }

  Widget buildAmountOfHours() {
    return AdBuildAmountOfHours(
        amountHour: controller.calculateHoursDifference().toString());
  }
}
