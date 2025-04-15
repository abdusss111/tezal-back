import 'package:eqshare_mobile/src/core/presentation/widgets/app_circular_progress_indicator.dart';
import 'package:eqshare_mobile/src/core/presentation/widgets/page_wrapper.dart';
import 'package:eqshare_mobile/src/features/main/workers/my_workers/my_worker/my_worker_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';

import '../../../../../core/presentation/routing/app_route.dart';
import '../../../../../core/presentation/widgets/app_primary_button.dart';
import '../../../../../core/presentation/widgets/rating_with_star_widget.dart';

import '../my_worker/my_worker_screen.dart';
import 'my_workers_list_controller.dart';

class MyWorkersListScreen extends StatefulWidget {
  const MyWorkersListScreen({super.key});

  @override
  State<MyWorkersListScreen> createState() => _MyWorkersListScreenState();
}

class _MyWorkersListScreenState extends State<MyWorkersListScreen> {
  late MyWorkersListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MyWorkersListController();
    _controller.setupWorkers(context);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Мои водители'),
          leading: IconButton(
            onPressed: () {
              context.go('/${AppRouteNames.navigation}', extra: {'index': '4'});
            },
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Consumer<MyWorkersListController>(
          builder: (context, controller, child) {
            return PageWrapper(
              child: Column(
                children: [
                  Expanded(
                    child: controller.isContentEmpty
                        ? Center(
                      child: Text(
                        'У вас пока водителей нет...',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                        : WorkerListViewWidget(controller: controller),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: Column(
                      children: [
                        AppPrimaryButtonWidget(
                          onPressed: () {
                            context.pushNamed(AppRouteNames.myWorkersOnMap);
                          },
                          text: 'Показать на карте водителей',
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        AppPrimaryButtonWidget(
                          onPressed: () {
                            context.pushNamed(AppRouteNames.myWorkersListSearch);
                          },
                          text: 'Добавить водителя',
                          textColor: Colors.white,
                          icon: Icons.add_circle_outline_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class WorkerListViewWidget extends StatelessWidget {
  final MyWorkersListController controller;

  const WorkerListViewWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MyWorkersListController>(
      builder: (context, controller, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.view_list,
                        color: controller.isListView ? Colors.orange : Colors.black),
                    onPressed: controller.toggleViewMode,
                  ),
                  IconButton(
                    icon: Icon(Icons.view_module,
                        color: !controller.isListView ? Colors.orange : Colors.black),
                    onPressed: controller.toggleViewMode,
                  ),
                ],
              ),
            ),
            Expanded(
              child: controller.isListView
                  ? _buildListView(context, controller)
                  : _buildGridView(context, controller),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, MyWorkersListController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshAllWorkers(context),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 50),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: controller.workers.length,
        itemBuilder: (context, index) {
          final worker = controller.workers[index];
          return WorkerItem(
            worker: worker,
            onTap: () => _navigateToWorkerScreen(context, worker, controller),
            controller: controller,
            isListView: true,
          );
        },
      ),
    );
  }

  Widget _buildGridView(BuildContext context, MyWorkersListController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshAllWorkers(context),
      child: GridView.builder(
        padding: const EdgeInsets.only(bottom: 50),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: controller.workers.length,
        itemBuilder: (context, index) {
          final worker = controller.workers[index];
          return WorkerItem(
            worker: worker,
            onTap: () => _navigateToWorkerScreen(context, worker, controller),
            controller: controller,
            isListView: false,
          );
        },
      ),
    );
  }

  Future<void> _navigateToWorkerScreen(
      BuildContext context, User worker, MyWorkersListController controller) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (_) => MyWorkerController(),
          child: MyWorkerScreen(worker: worker),
        ),
      ),
    );

    if (result == true) {
      controller.refreshWorkers(context, worker.id.toString());
    }
  }
}

class WorkerItem extends StatelessWidget {
  final User worker;
  final VoidCallback onTap;
  final MyWorkersListController controller;
  final bool isListView;

  const WorkerItem({
    super.key,
    required this.worker,
    required this.onTap,
    required this.controller,
    required this.isListView,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = worker.customUrlImage ??
        'https://liamotors.com.ua/image/catalogues/products/no-image.png';

    return InkWell(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: isListView
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageUrl,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          width: 75,
                          height: 75,
                          child: AppCircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/fallback_image.png',
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildWorkerDetails(context, true),
                  ),
                  Icon(
                    Icons.location_on,
                    color: (worker.isLocationEnabled ?? false)
                        ? Colors.green
                        : Colors.grey,
                    size: 20,
                  ),
                ],
              ),
            ],
          )
              : Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: constraints.maxWidth,
                              height: constraints.maxWidth * 0.95,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                    child: AppCircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/fallback_image.png',
                                  width: constraints.maxWidth,
                                  height: constraints.maxWidth * 0.95,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildWorkerDetails(context, false),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RatingWithStarWidget(rating: worker.rating),
                      Icon(
                        Icons.location_on,
                        color: (worker.isLocationEnabled ?? false)
                            ? Colors.green
                            : Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkerDetails(BuildContext context, bool rating) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            worker.nickName ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          if (rating) RatingWithStarWidget(rating: worker.rating),
        ],
      ),
    );
  }
}