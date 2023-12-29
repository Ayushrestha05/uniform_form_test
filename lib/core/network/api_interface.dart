import 'package:uniform_form_app/core/network/api_client.dart';

abstract class NetworkApiInterface {
  ApiClient get client => ApiClient();
}
