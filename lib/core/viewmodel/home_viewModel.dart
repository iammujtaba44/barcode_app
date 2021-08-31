import 'package:barcode_app/utils/plugins.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  late HomeService _homeService;
  HomeViewModel({required HomeService homeService})
      : _homeService = homeService;

  Future<ApiResponse> get_attendance() async {
    setBusy(true);
    ApiResponse response = await _homeService.get_attendance();
    setBusy(false);
    return response;
  }
}
