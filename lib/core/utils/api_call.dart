import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class APIManager {

  static Future<Map> postAPICall({required String url, Map? param,String? token}) async {
    // print("Calling post request API: $url");
    Map<String,String> headers ={
      'Content-Type':'application/json',
      'Accept':'application/json'
    };
    if(token != null){
      headers['Authorization'] = 'Token $token';
    }
    Map<String, dynamic> responseJson;
    try {
      var uri = Uri.parse(url);
      final response =  await http.post(uri,
          body: json.encode(param),headers: headers);
      // print(response)
      responseJson = _response(response);
      responseJson['status'] = response.statusCode == 200 || response.statusCode == 201;
    }catch(e) {
      responseJson = {
        'status':false,
        'status_code':502,
        'message':'Bad Gateway or no internet connection'
      };
    }
    return responseJson;
  }
  static Future<Map> putAPICall({required String url, Map? param,String? token}) async {
    // print("Calling put request API: $url");
    Map<String,String> headers ={
      'Content-Type':'application/json',
      'Accept':'application/json'
    };
    if(token != null){
      headers['Authorization'] = 'Token $token';
    }
    Map<String, dynamic> responseJson;
    try {
      var uri = Uri.parse(url);
      final response =  await http.put(uri,
          body: json.encode(param),headers: headers);
      responseJson = _response(response);
      responseJson['status'] = response.statusCode == 200 || response.statusCode == 201;
    }catch(e) {
      responseJson = {
        'status':false,
        'status_code':502,
        'message':'Bad Gateway or no internet connection'
      };
    }
    return responseJson;
  }
  static Future<dynamic> getAPICall({required String url,String? token}) async {
    Map<String,String> headers ={
      'Accept':'application/json'
    };
    if(token != null){
      headers['Authorization'] = 'Token $token';
    }
    Map<String, dynamic> responseJson;
    try {
      var uri = Uri.parse(url);
      final response =  await http.get(uri,headers: headers);
      responseJson = _response(response);
      responseJson['status'] = response.statusCode == 200 || response.statusCode == 201;
    } catch(e) {
      responseJson = {
        'status_code':502,
        'message':'Bad Gateway or no internet connection',
        'status':false,
      };

    }
    return responseJson;
  }

  static dynamic _response(http.Response response) {
    var respBody = json.decode(response.body.toString());
    String message = 'An error occurred';
    switch (response.statusCode) {
      case 200:
      case 201:
        return {
          'status_code':response.statusCode,
          'message':'Successful',
          'data':respBody
        };
      case 400:
        if(respBody['errors'] != null){
          if(respBody['errors'] is List){

          }
        }
        return {
          'status_code':400,
          'message':'Bad Request',
          'data':respBody
        };
      case 401:
      case 403:
        return {
          'status_code':response.statusCode,
          'message':'Unauthorised or credentials mismatch',
          'returned':respBody
        };
      case 500:
      default:
        return {
          'status_code':response.statusCode,
          'message':'Server error',
          'returned':respBody
        };
    }
  }
}