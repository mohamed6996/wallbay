// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collectionSearchResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionSearchResponse _$CollectionSearchResponseFromJson(
    Map<String, dynamic> json) {
  return CollectionSearchResponse(
    json['total'] as int,
    json['total_pages'] as int,
    (json['results'] as List)
        ?.map((e) => e == null
            ? null
            : CollectionResponse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CollectionSearchResponseToJson(
        CollectionSearchResponse instance) =>
    <String, dynamic>{
      'total': instance.total,
      'total_pages': instance.total_pages,
      'results': instance.results,
    };
