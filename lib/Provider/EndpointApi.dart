import 'package:notification_page/Model/Response.dart';
import 'package:notification_page/Provider/EndPointService.dart';

import 'RequestApi.dart';

class UserEndPoint extends RequestApi {
  @override
  String baseName = 'Users';
  @override
  String baseUrl = 'https://signal.dinavision.org/api/User';
}

class MessageEndPoint extends RequestApi {
  @override
  String baseName = '';
  @override
  String baseUrl = 'https://signal.dinavision.org/api/Message';
}
// class UserGetterEndPoint extends ApiService{
//
//   String SecUrl = 'https://signal.dinavision.org/userinfo/getuserId?email';
//
//   Future<void> UrlCreator(String Email) async{
//     String Url;
//     Url = SecUrl + Email;
//     ResponseModel response = await Url.httpFind()
//   }
// }
