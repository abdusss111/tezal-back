import 'package:eqshare_mobile/app/app_change_notifier.dart';
import 'package:eqshare_mobile/app/app_safe_change_notifier.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_history/request_history.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_history/statistic.dart';
import 'package:eqshare_mobile/src/features/requests/data/models/request_statistic/request_statistic.dart';
import 'package:eqshare_mobile/src/features/requests/data/repository/sm_request_repository_impl.dart';
import 'package:flutter/material.dart';


class RequestHistoryController extends AppSafeChangeNotifier {
  final int requestId;
  bool isLoading = true;
  bool isContentEmpty = false;
  final appChangeNotifier = AppChangeNotifier();

  RequestHistoryController(this.requestId);

  final _historyList = <Statistic>[];

  List<Statistic> get historyList => List.unmodifiable(_historyList.toList());
  RequestHistory? requestHistoryResponse;
  RequestStatistic? requestStatisticResponse;

  final _requestApiClient = SMRequestRepositoryImpl();

  void setupHistory() async {
    isLoading = true;
    isContentEmpty = false;

    notifyListeners();

    appChangeNotifier.checkConnectivity();

    await loadHistory();

    await loadStatistic();

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    try {
      requestHistoryResponse =
          await _requestApiClient.getRequestHistory(requestId.toString());
      if (requestHistoryResponse != null) {
        _historyList.clear();
        _historyList.addAll(requestHistoryResponse?.statistic ?? <Statistic>[]);

        notifyListeners();
        if (_historyList.isEmpty) {
          isContentEmpty = true;
        } else {
          isContentEmpty = false;
        }

        notifyListeners();
      }

      notifyListeners();
    } catch (e) {
      print('Error: ${e}');
    }
  }

  Future<void> loadStatistic() async {
    requestStatisticResponse =
        await _requestApiClient.getRequestStatistic(requestId.toString());

    notifyListeners();
  }
}
