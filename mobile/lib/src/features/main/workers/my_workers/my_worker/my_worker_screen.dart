import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/main/profile/profile_page/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../../main.dart';
import 'my_worker_controller.dart';
import 'widgets/my_worker_actions.dart';
import 'widgets/my_worker_header.dart';
import 'widgets/my_worker_orders.dart';

class MyWorkerScreen extends StatefulWidget {
  final User worker;

  const MyWorkerScreen({
    super.key,
    required this.worker,
  });

  @override
  State<MyWorkerScreen> createState() => _MyWorkerScreenState();
}

class _MyWorkerScreenState extends State<MyWorkerScreen> {
  final GlobalKey<MyWorkerHeaderState> _headerKey =
      GlobalKey<MyWorkerHeaderState>();

  late User _currentWorker;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentWorker = widget.worker; // Initialize with the passed worker
  }

  void updateCurrentWorker(User updatedWorker) {
    setState(() {
      _currentWorker = updatedWorker;
    });
  }

  Future<void> _editNickname(BuildContext context) async {
    final controller = Provider.of<MyWorkerController>(context, listen: false);
    final TextEditingController nicknameController =
        TextEditingController(text: _currentWorker.nickName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать имя'),
          content: TextField(
            controller: nicknameController,
            decoration: const InputDecoration(
              labelText: 'Имя',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отменить'),
            ),
            TextButton(
              onPressed: () async {
                final newNickname = nicknameController.text.trim();
                if (newNickname.isNotEmpty) {
                  final success = await controller.updateNickname(
                    widget.worker.id!,
                    newNickname,
                  );

                  if (success) {
                    setState(() {
                      _currentWorker =
                          _currentWorker.copyWith(nickName: newNickname);
                      _headerKey.currentState?.updateWorker(_currentWorker);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Имя водителя было изменено.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ошибка при смене имени.')),
                    );
                  }
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop(true);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Мои водители'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editNickname(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            MyWorkerHeader(
              key: _headerKey,
              worker: _currentWorker,
              profileController: ProfileController(appChangeNotifier: appChangeNotifier),
              onWorkerUpdated: updateCurrentWorker, // Передаем метод
            ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedTabIndex = 0;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedTabIndex == 0
                              ? Colors.orange
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16)),
                          ),
                        ),
                        child: const Text('Заказы'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedTabIndex = 1;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedTabIndex == 1
                              ? Colors.orange
                              : Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                          ),
                        ),
                        child: const Text('Действия'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SlideTransition(
                        position: animation.drive(Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).chain(CurveTween(curve: Curves.easeInOut))),
                        child: child,
                      );
                    },
                    child: _selectedTabIndex == 0
                        ? OrdersContent(
                            key: ValueKey<int>(_selectedTabIndex),
                            workerId: widget.worker.id,
                          )
                        : ActionsContent(
                            key: ValueKey<int>(_selectedTabIndex),
                            workerId: widget.worker.id as int,
                            phoneNumber: widget.worker.phoneNumber as String,
                          ),
                  ),
                ),
              ],
            ),
          ));
        }
}
