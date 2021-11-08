import 'package:flutter/cupertino.dart';

import '../services/paging/base_page_repository.dart';

abstract class PagingDataProvider<T> extends ChangeNotifier {
  List<T>? get data => _data;

  bool get isLoading => _isLoading;

  bool get hasNext => dataRepo!.hasNext;

  final BasePageRepository? dataRepo;

  PagingDataProvider({this.dataRepo});

  List<T>? _data;

  bool _isLoading = false;
  bool _isDisposed = false;

  Future<void> getData() async {
    if (_isLoading) return;
    if (!hasNext) {
      _isLoading = true;
      _updateState();
      await Future.delayed(const Duration(milliseconds: 500), () {
        _isLoading = false;
      });
      _updateState();
      return;
    }
    _isLoading = true;
    _updateState();

    final _apiData = await dataRepo!.getData();

    _data = [..._data ?? [], ..._apiData as Iterable<T>? ?? []];
    await Future.delayed(const Duration(milliseconds: 300), () {
      _isLoading = false;
    });
    _updateState();
  }

  Future<void> refresh() {
    dataRepo!.refresh();
    _data = null;
    _updateState();
    return Future.delayed(const Duration(milliseconds: 300), getData);
  }

  void _updateState() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
