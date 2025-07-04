import 'package:equatable/equatable.dart';

class SingleFieldData extends Equatable {
  final String id;
  final String field_name;
  final String field_value;

  const SingleFieldData({
    required this.id,
    required this.field_name,
    required this.field_value,
  });

  SingleFieldData copyWith({
    String? id,
    String? field_name,
    String? field_value,
  }) {
    return SingleFieldData(
      id: id ?? this.id,
      field_name: field_name ?? this.field_name,
      field_value: field_value ?? this.field_value,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'field_name': field_name,
      'field_value': field_value,
    };
  }

  factory SingleFieldData.fromJson(Map<String, dynamic> map) {
    return SingleFieldData(
      id: map['id'] as String,
      field_name: map['field_name'] as String,
      field_value: map['field_value'] as String,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        id,
        field_name,
        field_value,
      ];
}

class VisitFormData extends Equatable {
  final Map<String, List<SingleFieldData>> forms_data;
  const VisitFormData({
    required this.forms_data,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      ...forms_data,
    };
  }

  factory VisitFormData.fromJson(Map<String, dynamic> map) {
    return VisitFormData(
      forms_data: Map.fromEntries(
        map.entries.map(
          (e) => MapEntry(
            e.key,
            (e.value as List<dynamic>)
                .map((x) => SingleFieldData.fromJson(x))
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [forms_data];
}
