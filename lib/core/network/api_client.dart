import 'package:http/http.dart' as http;

class ApiClient {
  static const kMainEndpoint = 'https://a36ff36c-0b87-4d4b-8674-91d2e1788ec4.mock.pstmn.io';

  Future get(String endpoint) async {
    final response = await http.get(Uri.parse('$kMainEndpoint/$endpoint'));
    return response;
  }
}
