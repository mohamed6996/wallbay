// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_search_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotoSearchResponse _$PhotoSearchResponseFromJson(Map<String, dynamic> json) {
  return PhotoSearchResponse(
    json['total'] as int,
    json['total_pages'] as int,
    (json['results'] as List)
        ?.map((e) => e == null
            ? null
            : PhotoResponse.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PhotoSearchResponseToJson(
        PhotoSearchResponse instance) =>
    <String, dynamic>{
      'total': instance.total,
      'total_pages': instance.total_pages,
      'results': instance.results,
    };
