import 'dart:io';

import 'package:eqshare_mobile/src/core/presentation/services/image_picker_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_form_field_label.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PickImagesWhenRedactAd extends StatefulWidget {
  final String inputFieldLabelText;
  final int selectedImagesLength;
  final List<String> networkImages;
  final void Function(String) onImagePicked;
  final void Function(int) onImageRemoved;
  final void Function(int)? onNetworkImageRemoved;

  final List<String> selectedImages;
  const PickImagesWhenRedactAd(
      {super.key,
      required this.inputFieldLabelText,
      required this.selectedImagesLength,
      required this.onImagePicked,
      required this.selectedImages,
      required this.onImageRemoved,
      required this.networkImages,
      this.onNetworkImageRemoved,


      });

  @override
  State<PickImagesWhenRedactAd> createState() => _PickImagesWhenRedactAdState();
}

class _PickImagesWhenRedactAdState extends State<PickImagesWhenRedactAd> {
  Widget showImages(int index, BuildContext context) {
    // Если индекс относится к сетевым изображениям
    if (index < widget.networkImages.length) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(
              widget.networkImages[index],
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
              onTap: () async {
                if (widget.onNetworkImageRemoved != null) {
                  widget.onNetworkImageRemoved!(index);
                }
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
    } else {
      // Иначе выводим локальные изображения (из файлов)
      int localImageIndex = index - widget.networkImages.length;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.file(
              File(widget.selectedImages[localImageIndex]),
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
              onTap: () async {
                // Удаляем локальное изображение
                widget.onImageRemoved(localImageIndex);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppInputFieldLabel(
                text: widget.inputFieldLabelText, isRequired: false),
            const SizedBox(width: 22),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  minimumSize: Size.zero),
              onPressed: () async {
                final lengthOfImages =
                    widget.selectedImages.length + widget.networkImages.length;
                if (lengthOfImages < 5) {
                  File? selectedImage =
                      await ImageService.pickImage(context, imageQuality: 50);
                  if (selectedImage != null) {
                    widget.onImagePicked(selectedImage.path);
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Достигнут максимальный предел'),
                        content:
                            const Text('Вы можете выбрать до 5 изображений.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Icon(Icons.upload_outlined, color: Colors.black),
            ),
          ],
        ),
        (widget.networkImages.isNotEmpty || widget.selectedImages.isNotEmpty)
            ? GridView.builder(
                itemCount:
                    widget.networkImages.length + widget.selectedImages.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 4.0),
                itemBuilder: (BuildContext context, int index) {
                  return showImages(index, context);
                },
              )
            : const SizedBox(),
      ],
    );
  }
}
