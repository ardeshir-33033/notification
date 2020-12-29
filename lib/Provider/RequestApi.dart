import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:notification_page/Model/QueryModel.dart';
import 'package:notification_page/Model/Response.dart';
import 'package:http/http.dart' as http;

enum HeaderTypeEnum {
  EmptyHeaderEnum,
  BasicHeaderEnum,
  FormDataHeaderEnum,
  BearerHeaderEnum,
  ImageHeaderEnum,
}

enum ResponseTypeEnum {
  ResponseModelEnum,
  Unit8ListEnum,
}

abstract class RequestApi {
  List includes;
  String baseName;
  String baseUrl;
  String parameter = "";
  String query = "";

  Object formDataHeader = {
    "Accept": "multipart/form-data",
    "content-type": "application/json; charset=utf-8",
  };

  Object basicHeader = {
    "Accept": "application/json",
    "content-type": "application/json; charset=utf-8",
  };

  Object headerTypeGetter(HeaderTypeEnum typeEnum) {
    switch (typeEnum) {
      case HeaderTypeEnum.FormDataHeaderEnum:
        return formDataHeader;
        break;
      case HeaderTypeEnum.BasicHeaderEnum:
        return basicHeader;
        break;
      case HeaderTypeEnum.EmptyHeaderEnum:
        return null;
        break;
      default:
        return basicHeader;
    }
  }

  responseTypeGetter(ResponseTypeEnum typeEnum, http.Response response) {
    switch (typeEnum) {
      case ResponseTypeEnum.ResponseModelEnum:
        String data = utf8.decode(response.bodyBytes);

        return ResponseModel().fromJson(
          json.decode(data),
        );
        break;
      case ResponseTypeEnum.Unit8ListEnum:
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

  httpGet(HeaderTypeEnum headerType, ResponseTypeEnum responseType) {
    return http
        .get(
          "$baseUrl$parameter$query",
          headers: headerTypeGetter(headerType),
        )
        .then(
          (http.Response response) => responseTypeGetter(
            responseType,
            response,
          ),
        );
  }

  httpDelete(HeaderTypeEnum headerType, ResponseTypeEnum responseType) {
    return http
        .delete(
          "$baseUrl$parameter$query",
          headers: headerTypeGetter(headerType),
        )
        .then(
          (http.Response response) => responseTypeGetter(
            responseType,
            response,
          ),
        );
  }

  httpFind(id, HeaderTypeEnum headerType, ResponseTypeEnum responseType) {
    return http
        .get(
          "$baseUrl",
          headers: headerTypeGetter(headerType),
        )
        .then(
          (http.Response response) => responseTypeGetter(
            responseType,
            response,
          ),
        );
  }

  httpPost(
    var body,
    HeaderTypeEnum headerType,
    ResponseTypeEnum responseType,
  ) async {
    return http
        .post(
          "$baseUrl$parameter$query",
          headers: headerTypeGetter(headerType),
          body: body,
        )
        .then(
          (http.Response response) => responseTypeGetter(
            responseType,
            response,
          ),
        );
  }

  Future httpPut(
    var body,
    HeaderTypeEnum headerType,
    ResponseTypeEnum responseType,
  ) {
    return http
        .put(
          "$baseUrl/$baseName$parameter$query",
          headers: headerTypeGetter(headerType),
          body: body,
        )
        .then(
          (http.Response response) => responseTypeGetter(
            responseType,
            response,
          ),
        );
  }

  Future httpPutFile({FormData body}) async {
    Dio dio = Dio();
    return dio.put(
      "user",
      data: body,
      options: Options(
        headers: {
          HttpHeaders.authorizationHeader: "Bearer token",
        },
      ),
      onSendProgress: (int sent, int total) {
        print((sent / total * 100).toString() + '%');
      },
    ).then((response) {
      return json.decode(response.data);
    });
  }
}
