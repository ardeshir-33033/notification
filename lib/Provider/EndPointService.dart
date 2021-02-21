import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:notification_page/Model/QueryModel.dart';
import 'package:notification_page/Model/Response.dart';

class EndPointService extends ApiService {
  @override
  String baseName = 'Users';
  @override
  String baseUrl = 'https://signal.dinavision.org/api';

  @override
  String SecUrl = 'https://dinavision.org/userinfo';
      /////'getuserId?email=';
}

enum HeaderEnum {
  EmptyHeaderEnum,
  BasicHeaderEnum,
  FormDataHeaderEnum,
  BearerHeaderEnum,
  ImageHeaderEnum,
}

enum ResponseEnum {
  ResponseModelEnum,
  Unit8ListEnum,
}

abstract class ApiService {
  List includes;
  String baseName;
  String baseUrl;
  String SecUrl;
  String parameter = "";
  String query = "";
  String token = "";

  Object getBearerHeader(String _token) {
    return {
      HttpHeaders.authorizationHeader: 'Bearer $token',
      "Accept": "application/json",
      "content-type": "application/json; charset=utf-8",
    };
  }

  Object formDataHeader = {
    "Accept": "multipart/form-data",
    "content-type": "application/json; charset=utf-8",
  };

  Object basicHeader = {
    "Accept": "application/json",
    "content-type": "application/json; charset=utf-8",
  };

  Object headerGetter(HeaderEnum typeEnum) {
    switch (typeEnum) {
      // case HeaderEnum.ImageHeaderEnum:
      //   return imageHeader;
      //   break;
      case HeaderEnum.BearerHeaderEnum:
        return getBearerHeader('');
        break;
      case HeaderEnum.FormDataHeaderEnum:
        return formDataHeader;
        break;
      case HeaderEnum.BasicHeaderEnum:
        return basicHeader;
        break;
      case HeaderEnum.EmptyHeaderEnum:
        return null;
        break;
      default:
        return basicHeader;
    }
  }

  responseGetter(ResponseEnum typeEnum, http.Response response) {
    switch (typeEnum) {
      case ResponseEnum.ResponseModelEnum:
        String data = utf8.decode(response.bodyBytes);

        if (data == null || data.isEmpty)
          return null;

        return json.decode(data);
        break;
      case ResponseEnum.Unit8ListEnum:
        return response.bodyBytes;
        break;
      default:
        return response.bodyBytes;
    }
  }

  prepend() {
    return this.query == "" ? '?' : '&';
  }

  include(List includes) {
    this.query += "${this.prepend()}include=${includes.join(',')}";
    return this;
  }

  SetupApi(String baseName, String parameter, List<QueryModel> queries) {
    this.baseName =
        baseName != null && baseName.isNotEmpty ? "/$baseName" : "/Users";
    this.parameter =
        parameter != null && parameter.isNotEmpty ? "/$parameter" : "";
    if (queries != null && queries.length > 0) {
      queries.forEach((element) {
        String nm = element.name;
        String vl = element.value;

        this.query += "${this.prepend()}$nm=$vl";
      });
    }

    return this;
  }

  setBaseName(String name) {
    this.baseName = "/$name";
    return this;
  }

  addParameter(String parameter) {
    this.parameter = "/$parameter";
    return this;
  }

  addToQuery(String queryName, String value) {
    this.query += "${this.prepend()}$queryName=$value";
    return this;
  }

  addRangeToQuery(List<QueryModel> queries) {
    if (queries != null && queries.length > 0) {
      queries.forEach((element) {
        String nm = element.name;
        String vl = element.value;

        this.query += "${this.prepend()}$nm=$vl";
      });
    }

    return this;
  }

  httpGet2(HeaderEnum headerType, ResponseEnum responseType) {
    String URL2 = "$SecUrl$baseName$parameter$query";
    return http
        .get(
      "$SecUrl$baseName$parameter$query",
      headers: headerGetter(headerType),
    )
        .then(
          (http.Response response) => responseGetter(
        responseType,
        response,
      ),
    );
  }

  httpGet(HeaderEnum headerType, ResponseEnum responseType) {
    return http
        .get(
          "$baseUrl$baseName$parameter$query",
          headers: headerGetter(headerType),
        )
        .then(
          (http.Response response) => responseGetter(
            responseType,
            response,
          ),
        );
  }

  httpDelete(HeaderEnum headerType, ResponseEnum responseType) {
    return http
        .delete(
          "$baseUrl$baseName$parameter$query",
          headers: headerGetter(headerType),
        )
        .then(
          (http.Response response) => responseGetter(
            responseType,
            response,
          ),
        );
  }

  httpFind(id, HeaderEnum headerType, ResponseEnum responseType) {
    return http
        .get(
          "$baseUrl$baseName$parameter$query",
          headers: headerGetter(headerType),
        )
        .then(
          (http.Response response) => responseGetter(
            responseType,
            response,
          ),
        );
  }

  httpPost(
    var body,
    HeaderEnum headerType,
    ResponseEnum responseType,
  ) async {
    return http
        .post(
          "$baseUrl$baseName$parameter$query",
          headers: headerGetter(headerType),
          body: body,
        )
        .then(
          (http.Response response) => responseGetter(
            responseType,
            response,
          ),
        );
  }

  Future httpPut(
    var body,
    HeaderEnum headerType,
    ResponseEnum responseType,
  ) {
    return http
        .put(
          "$baseUrl$baseName$parameter$query",
          headers: headerGetter(headerType),
          body: body,
        )
        .then(
          (http.Response response) => responseGetter(
            responseType,
            response,
          ),
        );
  }

  httpPutFile({FormData body}) async {
    Dio dio = Dio();
    return dio
        .put("$baseUrl$baseName$parameter$query", data: body)
        .then((value) {
      return json.decode(value.data);
    });
  }
}
