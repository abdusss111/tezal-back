import 'package:flutter/material.dart';

class ListenableTabController extends StatelessWidget {
  final int length;
  final Widget child;
  final int initialIndex;

  final ValueChanged<int> onPageChanged;

  const ListenableTabController({
    super.key,
    required this.length,
    required this.child,
    required this.onPageChanged,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: length,
      child: _ListenableTabController(
        onPageChanged: onPageChanged,
        child: child,
      ),
    );
  }
}

class _ListenableTabController extends StatefulWidget {
  final Widget child;
  final ValueChanged<int> onPageChanged;

  const _ListenableTabController({
    required this.child,
    required this.onPageChanged,
  });

  @override
  State<StatefulWidget> createState() => _ListenableTabControllerState();
}

class _ListenableTabControllerState extends State<_ListenableTabController> {
  TabController? _controller;

  late final VoidCallback _controllerListener;

  @override
  void initState() {
    super.initState();

    _controllerListener = () {
      final index = _controller?.index;

      if (index != null && _controller?.indexIsChanging == false) {
        widget.onPageChanged(index);
      }
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controller = DefaultTabController.maybeOf(context);
    _controller?.removeListener(_controllerListener);
    _controller?.addListener(_controllerListener);
  }

  @override
  void dispose() {
    _controller?.removeListener(_controllerListener);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
