import 'dart:io';

import 'package:eqshare_mobile/src/core/presentation/services/image_picker_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_form_field_label.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PickImagesForAdWhenCreateWidget extends StatefulWidget {
  final String inputFieldLabelText;
  final int selectedImagesLength;
  final void Function(String) onImagePicked;
  final void Function(int) onImageRemoved;

  final List<String> selectedImages;
  const PickImagesForAdWhenCreateWidget(
      {super.key,
      required this.inputFieldLabelText,
      required this.selectedImagesLength,
      required this.onImagePicked,
      required this.selectedImages,
      required this.onImageRemoved});

  @override
  State<PickImagesForAdWhenCreateWidget> createState() => _PickImagesForAdWhenCreateWidgetState();
}

class _PickImagesForAdWhenCreateWidgetState extends State<PickImagesForAdWhenCreateWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppInputFieldLabel(text: widget.inputFieldLabelText, isRequired: false),
            const SizedBox(width: 22),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  minimumSize: Size.zero),
              onPressed: () async {
                if (widget.selectedImagesLength  < 5) {
                  File? selectedImage = await ImageService.pickImage(context,imageQuality: 50);
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
        (widget.selectedImages.isNotEmpty)
            ? GridView.builder(
                itemCount: widget.selectedImages.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 4.0),
                itemBuilder: (BuildContext context, int index) {
                  return (widget.selectedImages[index] == 'place_holder')
                      ? InkWell(
                          onTap: () async {
                            if (widget.selectedImages.length - 1 < 5) {
                              File? selectedImage =
                                  await ImageService.pickImage(context);
                              if (selectedImage != null) {
                                widget.onImagePicked(selectedImage.path);
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Достигнут максимальный предел'),
                                    content: const Text(
                                        'Вы можете выбрать до 5 изображений.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Navigator.pop(context);
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
                                File(widget.selectedImages[index]),
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
                                  widget.onImageRemoved(index);
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
}
