import 'package:flutter/foundation.dart';
import 'package:planner_app/ApiService/api_service.dart';
import 'package:planner_app/models/prayer_times.dart';

class PrayerTimesProvider with ChangeNotifier {
  PrayerTimes? _prayerTimes;
  bool _isLoading = false;
  String? _error;

  PrayerTimes? get prayerTimes => _prayerTimes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPrayerTimes(String city, String country) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await ApiService().getPrayerTimes(city, country);
      _prayerTimes = PrayerTimes.fromJson(response);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
