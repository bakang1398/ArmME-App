import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ArmMeService {
  String baseUrl = "https://external.srnservices.net";

  Future<String> login(String username, String password) async {
    String endpoint = "/Token";
    var uri = Uri.parse(baseUrl + endpoint);
    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "password",
        "username": username,
        "password": password,
        "client_secret":
            "hN1Ne!4j!2AS@#zAuMbU^iUwQwX5zXTRJ@Bf@u#ux!wmY5Tl16@WMA^dEy01eqZq",
        "client_id": "test",
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data["access_token"];
    } else {
      var error = jsonDecode(response.body);
      debugPrint("the login error: $error");
      var errorMessage = error["error_description"];
      return Future.error(errorMessage);
    }
  }

  Map<String, String> _headers(String token) {
    return {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Bearer $token"
    };
  }

  Map<String, String> _body() {
    return {
      "CL": "TESTBOARD",
      "AC": "41127",
      "PanelCode": "1234",
      "Partition": "1",
      "client_id": "test",
    };
  }

  Future<bool> openConnection(String token) async {
    String endPoint = "/api/v2/DemoSystem/Open";
    var uri = Uri.parse(baseUrl + endPoint);
    var response = await http.post(
        uri,
        headers: _headers(token),
        body: _body()
    );

    debugPrint("the response to opening the connection: ${jsonDecode(response.body)}");

    if(response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      debugPrint("the connection response : $data");
      return data["Succeeded"];
    } else {
      Future.error(response);
    }

    return false;

  }

  Future<bool> getAlarmStatus(String token) async {
    String endPoint = "/api/v2/DemoSystem/PartitionStatus";
    var uri = Uri.parse(baseUrl + endPoint);
    var response = await http.post(
        uri,
        headers: _headers(token),
        body: _body()
    );

    debugPrint("the response from getting the alarm system : ${jsonDecode(response.body)}");

    if(response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      debugPrint("The status : $data");
      return data["AwayArmed"];
    } else {
      Future.error(response);
    }

    return false;

  }

  Future<bool> updateAlarmStatus(String token) async {
    String endPoint = "/api/v2/DemoSystem/AwayArm";
    var uri = Uri.parse(baseUrl + endPoint);
    var response = await http.post(
      uri,
      headers: _headers(token),
      body: _body()
    );

    if(response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      debugPrint("The status updated: $data");
      return data["Succeeded"];
    } else {
      Future.error(response);
    }

    return false;

  }

}
