import '../../../../core/data_source/dio_helper.dart';
import '../request/static_page_request.dart';

class StaticPageRepository {
  final DioService dioService;
  StaticPageRepository(this.dioService);
  contactUs({required ContactUsRequest contactUsRequest}) async {
    final body = await contactUsRequest.toJson();
    final respose = await dioService.postData(
        url: "/contactus", isForm: true, loading: true, body: body);
    if (respose.isError == false) {
      return respose.response?.data;
    }
  }

  complain({required ContactUsRequest contactUsRequest}) async {
    final body = await contactUsRequest.complainToJson();
    final respose = await dioService.postData(
        url: "/contactus", isForm: true, loading: true, body: body);
    if (respose.isError == false) {
      return respose.response?.data;
    }
  }

  //////////////
  Future<Map<String, dynamic>?> aboutUs(String type) async {
    final respose = await dioService.getData(
      url: "/pages/$type",
      loading: false, /*  query: {"type": type} */
    );
    if (respose.isError == false) {
      return respose.response?.data["data"]["page"] ?? "";
    }
    return null;
  }
}
