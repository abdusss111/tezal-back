import 'package:eqshare_mobile/src/core/presentation/widgets/page_wrapper.dart';
import 'package:eqshare_mobile/src/features/ad/presentation/widgets/history_widget/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget>
    with SingleTickerProviderStateMixin {
  SwiperController controller = SwiperController();
  late AnimationController animationController;

  double percedWathced = 0;

  @override
  initState() {
    super.initState();
    animationController = AnimationController(vsync: this);

    // Добавляем слушатель для перерисовки виджета при изменении анимации
  }

  final List<String> images = [
    'assets/history/history_1.jpg',
    'assets/history/history_2.jpg',
    'assets/history/history_4.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.18,
      child: Column(
        children: [
          Expanded(
            child: Swiper(
              autoplay: true,
              outer: true,
              viewportFraction: 0.88,
              scale: 0.9,
              autoplayDelay: 2500,
              duration: 1000,
              itemCount: images.length,
              controller: controller,
              itemBuilder: (context, index) {
                return imagesWidget(images[index]);
              },
            ),
          ),
        ],
      ),
    ));
  }

  Widget imagesWidget(String url) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
        child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HistoryScreen(url: url);
              }));
            },
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Image.asset(
                  url,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: child,
                    );
                  },
                ))),
      ),
    );
  }
}
