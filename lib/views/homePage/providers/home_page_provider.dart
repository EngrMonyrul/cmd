import 'package:flutter/foundation.dart';

class HomePageProvider extends ChangeNotifier {
  String _fetchedFilePath = '';
  String _savingFolder = '';
  String _beforeEditVideoData = 'Nothing';
  String _afterEditVideoData = 'Nothing';
  bool _showBeforeData = false;
  bool _showAfterData = false;

  bool get showAfterData => _showAfterData;

  bool get showBeforeData => _showBeforeData;

  String get beforeEditVideoData => _beforeEditVideoData;

  String get afterEditVideoData => _afterEditVideoData;

  String get savingFolder => _savingFolder;

  String get fetchedFilePath => _fetchedFilePath;

  void setShowAfterData() {
    if (_showBeforeData) {
      _showBeforeData = false;
    }
    _showAfterData = !_showAfterData;
    notifyListeners();
  }

  void setShowBeforeData() {
    if (_showAfterData) {
      _showAfterData = false;
    }
    _showBeforeData = !_showBeforeData;
    notifyListeners();
  }

  void setBeforeEditVideoData({required String data}) {
    _beforeEditVideoData = data;
    notifyListeners();
  }

  void setAfterEditVideoData({required String data}) {
    _afterEditVideoData = data;
    notifyListeners();
  }

  void setSavingPath({required String path}) {
    _savingFolder = path;
    notifyListeners();
  }

  void setFetchedFile({required String path}) {
    _fetchedFilePath = path;
    notifyListeners();
  }
}
