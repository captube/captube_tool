import 'package:captube/locator.dart';
import 'package:captube/services/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:captube/routing/route_names.dart';

class CapturedListViewModel extends ChangeNotifier {
  final NavigationService _navigationService = locator<NavigationService>();

  void navigateToEpisode(String index) {
    _navigationService.navigateTo(CapturedRoute, queryParams: {'id': index});
  }
}
