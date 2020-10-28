import 'package:http/http.dart';
import 'dart:convert';

Future postData(Map<String, dynamic> params, String url) async {
  String completeUrl = "https://poultryresultbe-sandbox.mxapps.io/api/v1/$url";
  String bodyJson = json.encode(params);

  const header = {
    'Content-Type': 'application/json'
  };

  try {
    Response response = await post(completeUrl, headers: header, body: bodyJson);

    var responseJSON = jsonDecode(response.body);
    return responseJSON;
  } catch (error) {
    print(error);
    return error;
  }

}

Future postDataQueue(String bodyJson, String url) async {
  String completeUrl = "https://poultryresultbe-sandbox.mxapps.io/api/v1/$url";

  const header = {
    'Content-Type': 'application/json'
  };

  try {
    Response response = await post(completeUrl, headers: header, body: bodyJson);

    var responseJSON = jsonDecode(response.body);
    return responseJSON;
  } catch (error) {
    print(error);
    return error;
  }

}