import 'package:flutter/material.dart';

class AppBottomNavBarWidget extends StatelessWidget {
  const AppBottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.requestsCount,
    this.messagesCount,
  });

  final int currentIndex;
  final Function(int) onTap;
  final int? requestsCount;
  final int? messagesCount;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: onTap,
      currentIndex: currentIndex,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Главная',
        ),
        BottomNavigationBarItem(
          icon: _buildBadgeIcon(Icons.sort, requestsCount),
          label: 'Заказы',
        ),
        BottomNavigationBarItem(
          icon: Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.add_box_outlined,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
          ),
          label: 'Создать',
        ),
        BottomNavigationBarItem(
          icon: _buildBadgeIcon(Icons.email_outlined, messagesCount),
          label: 'Сообщения',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_sharp),
          label: 'Профиль',
        ),
      ],
    );
  }

  Widget _buildBadgeIcon(IconData icon, int? count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count != null && count > 0)
          Positioned(
            top: -5,
            right: -10,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
