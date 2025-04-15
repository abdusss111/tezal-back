import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'chats_controller.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with SingleTickerProviderStateMixin {
  late final ChatsController chatsController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    chatsController = Provider.of<ChatsController>(context, listen: false);
    chatsController.loadNotifications(); // Load notifications on initialization
    _tabController = TabController(
        length: 3, vsync: this); // Initialize TabController for 3 tabs
  }

  Future<void> _onRefresh() async {
    // Reload notifications when the user pulls to refresh
    await chatsController.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
        bottom: TabBar(
          dividerColor: Colors.transparent,
          tabAlignment: TabAlignment.center,
          indicatorSize: TabBarIndicatorSize.tab,
          isScrollable: true,
          controller: _tabController,
          tabs: [
            _buildTab('Ожидание', _getPendingCount()),
            _buildTab('Принято', _getAcceptedCount()),
            _buildTab('Отклонено', _getRejectedCount()),
          ],
        ),
      ),
      body: Consumer<ChatsController>(
        builder: (context, controller, _) {
          // Always show the RefreshIndicator
          return RefreshIndicator(
            onRefresh: _onRefresh, // Trigger a refresh when pulled down
            child: controller.allNotifications.isEmpty
                ? const Center(child: Text('Нет уведомлений'))
                : TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationList(
                    controller.allNotifications
                        .where((n) => n.status.toLowerCase() == 'pending')
                        .toList(),
                    context),
                _buildNotificationList(
                    controller.allNotifications
                        .where((n) => n.status.toLowerCase() == 'accepted')
                        .toList(),
                    context),
                _buildNotificationList(
                    controller.allNotifications
                        .where((n) => n.status.toLowerCase() == 'rejected')
                        .toList(),
                    context),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to build notification list for each tab
  Widget _buildNotificationList(
      List<NotificationMessage> notifications, BuildContext context) {
    if (notifications.isEmpty) {
      return const Center(
          child: Text(
              'Заявок пока нет')); // Display message when no notifications are available
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        // Print the full name to the console
        String fullName = notification.full_name;
        print('Full Name: $fullName');
        final role = notification.accessRole ?? 'UNKNOWN'; // Get the role

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              borderRadius: BorderRadius.circular(16), // Rounded corners
              boxShadow: [
                BoxShadow(
                  offset: const Offset(-1, -1), // Offset for the shadow
                  blurRadius: 5, // Blur radius
                  color: const Color.fromRGBO(0, 0, 0, 0.04), // Shadow color
                ),
                BoxShadow(
                  offset: const Offset(1, 1), // Offset for the shadow
                  blurRadius: 5, // Blur radius
                  color: const Color.fromRGBO(0, 0, 0, 0.04), // Shadow color
                ),
              ],
            ),
            child: ListTile(
              title: const Text('Заявка на присоединение к бизнесу',
                  style: TextStyle(fontSize: 18)),
              subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role == 'OWNER'
                          ? '$fullName'
                          : 'От кого: $fullName',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),

                    Text(
                      'Статус: ${_translateStatus(notification.status)}\nСоздано: ${formatCreatedAt(notification.createdAt)}',
                    )

                  ]),
              trailing: Icon(
                Icons.circle,
                color: _getStatusColor(notification.status),
              ),
              isThreeLine: true,
              onTap: () {
                if (notification.status.toLowerCase() == 'pending') {
                  _showRespondDialog(context, notification);
                }
              },
            ),
          ),
        );
      },
    );
  }

  // Method to translate status to Russian
  String _translateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Ожидает';
      case 'accepted':
        return 'Принято';
      case 'rejected':
        return 'Отклонено';
      default:
        return 'Неизвестно';
    }
  }

  // Format the creation date
  String formatCreatedAt(String createdAt) {
    final DateTime dateTime = DateTime.parse(createdAt);
    final DateFormat formatter = DateFormat("d MMM yyyy 'г.' HH:mm", 'ru_RU');
    return formatter.format(dateTime);
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get the count for 'pending' notifications
  int _getPendingCount() {
    return chatsController.allNotifications
        .where((n) => n.status.toLowerCase() == 'pending')
        .length;
  }

  // Helper method to get the count for 'accepted' notifications
  int _getAcceptedCount() {
    return chatsController.allNotifications
        .where((n) => n.status.toLowerCase() == 'accepted')
        .length;
  }

  // Helper method to get the count for 'rejected' notifications
  int _getRejectedCount() {
    return chatsController.allNotifications
        .where((n) => n.status.toLowerCase() == 'rejected')
        .length;
  }

  // Helper method to create the tab with a count in a circle
  Widget _buildTab(String text, int count) {
    return Tab(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text),
              const SizedBox(
                  width: 8), // Add space between the text and the count
              if (count > 0)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to show the dialog for accepting/rejecting notifications
  void _showRespondDialog(
      BuildContext context, NotificationMessage notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтвердите действие'),
          content: Text(
            'Владелец бизнеса хочет добавить вас. Принять или отклонить?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                chatsController.respondToNotification(
                    notification.ownerId, false); // Reject the notification
                // Reload notifications after accepting or rejecting
                chatsController.loadNotifications();
              },
              child: const Text('Отклонить'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                chatsController.respondToNotification(
                    notification.ownerId, true); // Accept the notification
                // Reload notifications after accepting or rejecting
                chatsController.loadNotifications();
              },
              child: const Text('Принять'),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          ],
        );
      },
    );
  }
}
