import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HistoryScreen extends StatefulWidget {
  final String url;
  const HistoryScreen({super.key, required this.url});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isFrozen = false; // Флаг фризинга
  final Duration totalDuration = Duration(milliseconds: 3000);
  late Duration remainingDuration; // Для хранения оставшегося времени
  double progress = 0.0; // Текущий прогресс

  @override
  void initState() {
    super.initState();
    remainingDuration =
        totalDuration; // Изначально оставшееся время равно полной длительности
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onLongPressStart: (details) {
          setState(() {
            isFrozen = true; // Фризим
          });
        },
        onLongPressEnd: (details) {
          setState(() {
            isFrozen = false; // Снимаем фриз
          });
        },
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                child: Card(
                  elevation: 0.3,
                  color: Colors.white,
                  child: Image.asset(widget.url, fit: BoxFit.fitHeight),
                ),
              ),
              Align(
                  alignment: Alignment(0.95, -1.0),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close, color: Colors.black)),
                  )),
              if (!isFrozen)
                Align(
                  alignment: Alignment.topCenter,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: progress, end: 1.0),
                    duration: remainingDuration,
                    onEnd: () async {
                      await Future.delayed(Duration(milliseconds: 50));
                      if (context.mounted) Navigator.pop(context);
                    },
                    builder: (context, value, child) {
                      progress = value; // Обновляем текущее значение прогресса
                      return LinearPercentIndicator(
                        percent: progress,
                        lineHeight: 12,
                        barRadius: Radius.circular(10),
                        progressColor: Colors.white,
                        backgroundColor: Colors.grey,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void setState(fn) {
    if (isFrozen) {
      // Сохраняем оставшееся время
      remainingDuration = remainingDuration * (1 - progress);
    }
    super.setState(fn);
  }
}
