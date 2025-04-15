import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/core/presentation/services/image_picker_service.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/rating_with_star_widget.dart';

class MyWorkerHeader extends StatefulWidget {
  final User worker;
  final ProfileController profileController;
  final Function(User) onWorkerUpdated; // Новый параметр
  const MyWorkerHeader({
    super.key,
    required this.worker,
    required this.profileController,
    required this.onWorkerUpdated,
  });

  @override
  State<MyWorkerHeader> createState() => MyWorkerHeaderState();
}

class MyWorkerHeaderState extends State<MyWorkerHeader> {
  late User _worker;

  @override
  void initState() {
    super.initState();
    _worker = widget.worker;
  }

  void updateWorker(User updatedWorker) {
    setState(() {
      _worker = updatedWorker;
      widget.onWorkerUpdated(_worker);
    });
  }

  Future<void> _updateWorkerNickname(String newNickname) async {
    setState(() {
      _worker = _worker.copyWith(nickName: newNickname);
    });
  }

  Future<void> _updateWorkerImageUrl(String newImageUrl) async {
    setState(() {
      _worker = _worker.copyWith(customUrlImage: newImageUrl);
    });
    widget.onWorkerUpdated(_worker);
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _worker.customUrlImage ??
        'https://liamotors.com.ua/image/catalogues/products/no-image.png';

    return SizedBox(
      height: 140,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
              onTap: () async {
                final data = await ImageService.pickImage(context,
                    openScreenType: OpenScreenType.bottomSheet,
                    imageQuality: 5);
                if (context.mounted && data != null) {
                  final response =
                      await widget.profileController.patchWorkerImage(
                    context,
                    data,
                    _worker.id,
                  );
                  if (response != null) {
                    // Обновляем URL только если он строка
                    final String imageUrl = response;
                    await _updateWorkerImageUrl(imageUrl);
                  }
                  // Пример смены никнейма
                }
              },
              child: SizedBox(
                width: 120,
                height: 120,
                child: Image.network(
                  width: 120,
                  height: 120,
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    } else if (progress.cumulativeBytesLoaded <
                        (progress.expectedTotalBytes ?? 0)) {
                      return const SizedBox(
                          width: 120,
                          height: 120,
                          child: AppCircularProgressIndicator());
                    } else {
                      return child;
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // Показываем заглушку, если произошла ошибка загрузки
                    return const Icon(
                      Icons.broken_image,
                      size: 120,
                      color: Colors.grey,
                    );
                  },
                ),
              )),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_worker.nickName ?? 'Без имени',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 22),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2),
                Text(_worker.phoneNumber ?? 'Нет номера',
                    style: Theme.of(context).textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                const SizedBox(height: 8),
                RatingWithStarWidget(rating: _worker.rating),
              ],
            ),
          )
        ],
      ),
    );
  }
}
