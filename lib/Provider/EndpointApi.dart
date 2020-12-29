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
