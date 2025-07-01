import 'package:equatable/equatable.dart';

class BookkeepingItem extends Equatable {
  final String id;
  final String name;
  final String item_id;
  final String collection_id;
  final String added_by;
  final String updated_by;
  final double amount;
  final String type; //in,out;
  final String update_reason;
  final bool auto_add;
  final Map<DateTime, BookkeepingItem> old_values;

  const BookkeepingItem({
    required this.id,
    required this.name,
    required this.item_id,
    required this.collection_id,
    required this.added_by,
    required this.updated_by,
    required this.amount,
    required this.type,
    required this.update_reason,
    required this.auto_add,
    required this.old_values,
  });

  BookkeepingItem copyWith({
    String? id,
    String? name,
    String? item_id,
    String? collection_id,
    String? added_by,
    String? updated_by,
    double? amount,
    String? type,
    String? update_reason,
    bool? auto_add,
    Map<DateTime, BookkeepingItem>? old_values,
  }) {
    return BookkeepingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      item_id: item_id ?? this.item_id,
      collection_id: collection_id ?? this.collection_id,
      added_by: added_by ?? this.added_by,
      updated_by: updated_by ?? this.updated_by,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      update_reason: update_reason ?? this.update_reason,
      auto_add: auto_add ?? this.auto_add,
      old_values: old_values ?? this.old_values,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'item_id': item_id,
      'collection_id': collection_id,
      'added_by': added_by,
      'updated_by': updated_by,
      'amount': amount,
      'type': type,
      'update_reason': update_reason,
      'auto_add': auto_add,
      'old_values': old_values,
    };
  }

  factory BookkeepingItem.fromJson(Map<String, dynamic> map) {
    return BookkeepingItem(
      id: map['id'] as String,
      name: map['name'] as String,
      item_id: map['item_id'] as String,
      collection_id: map['collection_id'] as String,
      added_by: map['added_by'] as String,
      updated_by: map['updated_by'] as String,
      amount: map['amount'] as double,
      type: map['type'] as String,
      update_reason: map['update_reason'] as String,
      auto_add: map['auto_add'] as bool,
      old_values: Map.fromEntries((map['old_values'] as Map<String, dynamic>)
          .entries
          .map((e) => MapEntry(
              DateTime.parse(e.key), BookkeepingItem.fromJson(e.value)))),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      item_id,
      collection_id,
      added_by,
      updated_by,
      amount,
      type,
      update_reason,
      auto_add,
      old_values,
    ];
  }
}
