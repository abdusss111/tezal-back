import 'dart:developer';

class PaginatorLoadResult<T> {
  final List<T> data;
  final int currentOffset;
  final int total;

  PaginatorLoadResult({
    required this.data,
    required this.currentOffset,
    required this.total,
  });
}

typedef PaginatorLoad<T> = Future<PaginatorLoadResult<T>> Function(int);

class Paginator<T> {
  final List<T> _data = [];
  int _currentOffset = 0;
  int _total = -1;
  bool _isLoadingInProgress = false;
  final PaginatorLoad<T> load;

  List<T> get data => _data;

  Paginator(this.load);

  bool needToUpdate() {
    return !(_isLoadingInProgress ||
        (_total != -1 && _currentOffset >= _total));
  }

  Future<void> loadNextPage() async {
    if (_isLoadingInProgress || (_total != -1 && _currentOffset >= _total)) {
      return;
    }

    _isLoadingInProgress = true;

    try {
      final result = await load(_currentOffset);

      _data.addAll(result.data);
      _currentOffset += result.data.length;

      _total = result.total;
    } catch (e) {
      log('Ошибка загрузки данных: $e'); // TODO ошибка при нуловы
    } finally {
      _isLoadingInProgress = false;
    }
  }

  Future<void> reset() async {
    _currentOffset = 0;
    _total = 0;
    _data.clear();
    await loadNextPage();
  }
}
