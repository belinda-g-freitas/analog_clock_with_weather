import 'dart:convert';
import 'package:http/http.dart' as http;

class Network {
  Future<http.Response> postData(String endpoint, [data]) async {
    return await http.post(Uri.parse(endpoint), body: jsonEncode(data));
  }

  Future<http.Response> getData(String endpoint, [String? data = '']) async {
    return await http.get(Uri.parse('$endpoint$data'));
  }
}
