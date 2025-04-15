import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:eqshare_mobile/src/core/presentation/services/app_dialog_service.dart';
import 'package:eqshare_mobile/src/core/res/extensions/image_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

enum OpenScreenType { bottomSheet, dialog }

class ImageService {
  static void showFullScreenImageViewer(
    BuildContext context,
    String? imageUrl, {
    Color? backgroundColor,
    Color? closeButtonColor,
  }) {
    showImageViewer(
      context,
      Image.network(
        imageUrl ?? '',
        cacheWidth: MediaQuery.sizeOf(context).width.cacheSize(context),
      ).image,
      backgroundColor: backgroundColor ?? Colors.white,
      closeButtonColor: closeButtonColor ?? Colors.red,
    );
  }

  static void showFullScreenAssetImageViewer(
    BuildContext context,
    String? assetImage, {
    Color? backgroundColor,
    Color? closeButtonColor,
  }) {
    showImageViewer(
      context,
      Image.asset(
        assetImage ?? '',
        cacheWidth: MediaQuery.sizeOf(context).width.cacheSize(context),
      ).image,
      backgroundColor: backgroundColor ?? Colors.white,
      closeButtonColor: closeButtonColor ?? Colors.red,
    );
  }

  static Future<File?> pickImage(BuildContext context,
      {OpenScreenType openScreenType = OpenScreenType.dialog,
      int? imageQuality = 80}) async {
    try {
      ImageSource? source;

      source = openScreenType == OpenScreenType.dialog
          ? await _showImageSourceDialog(context)
          : await _showImageSourceBottomSheet(context);
      if (source == null) return null;

      final pickedFile = await ImagePicker()
          .pickImage(source: source, imageQuality: imageQuality ?? 1);
      if (pickedFile == null) return null;

      if (context.mounted) {
        AppDialogService.showLoadingDialog(context);
      }

      final compressedFile = await _compressImage(File(pickedFile.path));
      if (compressedFile != null) {
        final file = File(compressedFile.path);

        debugPrint((await pickedFile.length()).toString());
        debugPrint((await file.length()).toString());
        if (context.mounted) {
          // Navigator.pop(context);
          context.pop();
        }

        return file;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<XFile?> _compressImage(File file) async {
    final filePath = file.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jp'));
    final format = lastIndex == filePath.lastIndexOf('.png')
        ? CompressFormat.png
        : CompressFormat.jpeg;

    final outPath =
        '${filePath.substring(0, lastIndex)}_out${filePath.substring(lastIndex)}';

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 25,
      format: format,
    );

    return compressedImage;
  }

  static Future<ImageSource?> _showImageSourceDialog(
    BuildContext context,
  ) async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) => _buildImageSourceDialog(context),
    );
  }

  static Future<ImageSource?> _showImageSourceBottomSheet(
    BuildContext context,
  ) async {
    return await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => _widgetForBottomSheet(context),
    );
  }

  static SafeArea _widgetForBottomSheet(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 2, left: 8, right: 8, top: 16),
            child: galleryImageSourceButton(context),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: cameraImageSourceButton(context),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  static AlertDialog _buildImageSourceDialog(BuildContext context) {
    return AlertDialog(
      content: const Text('Выберите опцию'),
      contentPadding: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      actions: [
        galleryImageSourceButton(context),
        const SizedBox(height: 8),
        cameraImageSourceButton(context),
      ],
    );
  }

  static ElevatedButton cameraImageSourceButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.camera_alt),
      label: const Text('Камера'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: Theme.of(context).textTheme.titleMedium,
        minimumSize: const Size.fromHeight(50),
      ),
      // onPressed: () => Navigator.pop(context, ImageSource.camera),
      onPressed: () => context.pop(ImageSource.camera),
    );
  }

  static ElevatedButton galleryImageSourceButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.photo_library),
      label: const Text('Галерея'),
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        textStyle:Theme.of(context).textTheme.titleMedium,
        minimumSize: const Size.fromHeight(50),
      ),
      // onPressed: () => Navigator.pop(context, ImageSource.gallery),
      onPressed: () => context.pop(ImageSource.gallery),
    );
  }
}
