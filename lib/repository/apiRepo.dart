
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallbay/constants.dart';
import 'package:wallbay/model/collectionSearchResponse.dart';
import 'package:wallbay/model/collection_model.dart';
import 'package:wallbay/model/collection_response.dart';
import 'package:wallbay/model/me_model.dart';
import 'package:wallbay/model/me_response.dart';
import 'package:wallbay/model/photo_details_model.dart';
import 'package:wallbay/model/photo_details_response.dart';
import 'package:wallbay/model/photo_search_response.dart';
import 'package:wallbay/repository/Repository.dart';
import 'package:wallbay/model/photo_model.dart';
import 'package:wallbay/model/photo_response.dart';
import 'package:dio/dio.dart';
class ApiRepo{
  Dio dio;

  ApiRepo(this.dio);



}