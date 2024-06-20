import 'package:dio/dio.dart';
import 'package:e_commerce_flutter/src/data/sharepre.dart';
import 'package:e_commerce_flutter/src/model/bill.dart';
import 'package:e_commerce_flutter/src/model/book.dart';
import 'package:e_commerce_flutter/src/model/cart.dart';
import 'package:e_commerce_flutter/src/model/category.dart';
import 'package:e_commerce_flutter/src/model/productnew.dart';
import 'package:e_commerce_flutter/src/model/register.dart';
import 'package:e_commerce_flutter/src/model/request.dart';
import 'package:e_commerce_flutter/src/model/update.dart';
import 'package:e_commerce_flutter/src/model/user.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class API {
  final Dio _dio = Dio();
  String baseUrl = "http://192.168.0.107:8090";

  API() {
    _dio.options.baseUrl = "$baseUrl/api";
  }

  Dio get sendRequest => _dio;
}

class APIRepository {
  API api = API();

  Map<String, dynamic> header(String token) {
    return {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '/',
      'Authorization': 'Bearer $token',
    };
  }

  Future<String> login(String userName, String password) async {
    try {
      var requestBody = {'userName': userName, 'password': password};
      Response res = await api.sendRequest.post('/Account/Login',
          options: Options(headers: header('no token')), data: requestBody);
      if (res.statusCode == 200) {
        final tokenData = res.data;
        print("ok login");
        Map<String, dynamic> decodedToken = JwtDecoder.decode(tokenData);
        String temp = decodedToken[
            'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'];
        int userId = int.parse(temp);
        saveID(userId);
        saveToken(tokenData);
        return tokenData;
      } else {
        return "login fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<User> current(int id, String token) async {
    try {
      print(token);
      Response res = await api.sendRequest.get('/Customer/GetCustomerById/$id',
          options: Options(headers: header(token)));
      return User.fromJson(res.data);
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<ProNew>> getProduct(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Book/GetAllBooks', options: Options(headers: header(token)));
      return res.data.map((e) => ProNew.fromJson(e)).cast<ProNew>().toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<ProNew>> getAlProduct(String token) async {
    try {
      Response res = await api.sendRequest
          .get('/Book/GetAllBooks', options: Options(headers: header(token)));
      return res.data.map((e) => ProNew.fromJson(e)).cast<ProNew>().toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<ProNew>> getProductsByKeyword(
      String token, String keyword) async {
    try {
      Response res = await api.sendRequest.get(
          '/Book/GetAllBooksByKeyword/$keyword',
          options: Options(headers: header(token)));
      return res.data.map((e) => ProNew.fromJson(e)).cast<ProNew>().toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<String> register(Register user) async {
    try {
      var requestBody = {
        "fullName": user.fullname,
        "address": user.address,
        "phone": user.phone,
        "userName": user.username,
        "password": user.password,
        "dob": user.dob,
        "gender": user.gender,
        "avatar": user.avatar
      };
      Response res = await api.sendRequest.post('/Customer/Register',
          options: Options(headers: header('no token')), data: requestBody);
      if (res.statusCode == 200) {
        print("ok");
        return "ok";
      } else {
        print("fail");
        return "register fail";
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<BookModel> getBookByID(String token, int id) async {
    try {
      Response res = await api.sendRequest.get('/Book/GetBookDetailById/$id',
          options: Options(headers: header(token)));

      return BookModel.fromJson(res.data);
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<Categories>> getAllCategories() async {
    try {
      Response res = await api.sendRequest.get('/Category/GetAllCategories',
          options: Options(headers: header('no token')));
      return res.data
          .map((e) => Categories.fromJson(e))
          .cast<Categories>()
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<String> checkout(final json, String token) async {
    try {
      var body = json;
      await api.sendRequest.get('/Customer/CustomerPayPalSuccess',
          options: Options(headers: header(token)), data: body);
      return 'success';
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> addBill(PaypalSuccessRequest request, String token) async {
    try {
      Response res = await api.sendRequest.post(
          '/Customer/CustomerPayPalSuccess',
          options: Options(headers: header(token)),
          data: request);
      if (res.statusCode == 200) {
        print("add bill ok");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<BillModel>> getHistory(String id) async {
    try {
      Response res = await api.sendRequest.get(
          '/Customer/GetAllInvoiceByCustomerId/$id',
          options: Options(headers: header('no token')));
      print(res.data
          .map((e) => BillModel.fromJson(e))
          .cast<BillModel>()
          .toList());
      return res.data
          .map((e) => BillModel.fromJson(e))
          .cast<BillModel>()
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<List<BillDetailModel>> getHistoryDetail(String billID) async {
    try {
      Response res = await api.sendRequest.get(
          '/Customer/GetAllInvoiceDetailByInvoiceId/$billID',
          options: Options(headers: header('no token')));
      return res.data
          .map((e) => BillDetailModel.fromJson(e))
          .cast<BillDetailModel>()
          .toList();
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }

  Future<bool> updateUser(UpdateModel updateModel) async {
    try {
      Response res = await api.sendRequest.put(
          '/Customer/UpdateCustomerInformation',
          options: Options(headers: header('no token')),
          data: updateModel);
      if (res.statusCode == 200) {
        print("update ok");
        return true;
      } else {
        return false;
      }
    } catch (ex) {
      print(ex);
      rethrow;
    }
  }
}
