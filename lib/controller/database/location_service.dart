import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../utils/components/app_url.dart';

  Future<http.Response> getLocationData(String text) async {
    http.Response response;

      response = await http.get(
        Uri.parse("${AppUrl.placeApiAutoCompleteUri}?search_text=$text"),
          headers: {"Content-Type": "application/json"},);

    print(jsonDecode(response.body));
    return response;
  }

  