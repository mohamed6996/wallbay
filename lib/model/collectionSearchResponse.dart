
import 'package:json_annotation/json_annotation.dart';
import 'package:wallbay/model/collection_response.dart';

part 'collectionSearchResponse.g.dart';

@JsonSerializable()
class CollectionSearchResponse{
  int total;
  int total_pages;

  List<CollectionResponse> results;

  CollectionSearchResponse(this.total, this.total_pages, this.results);

  factory CollectionSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$CollectionSearchResponseFromJson(json);

}