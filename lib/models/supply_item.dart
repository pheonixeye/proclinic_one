import 'package:equatable/equatable.dart';

class SupplyItem extends Equatable {
  final String id;
  final String name_en; //required
  final String name_ar;
  final String unit_en; //required
  final String unit_ar;
  final num reorder_quantity;
  final num buying_price;
  final num selling_price;
  final bool notify_on_reorder_quantity;

  const SupplyItem({
    required this.id,
    required this.name_en,
    required this.name_ar,
    required this.unit_en,
    required this.unit_ar,
    required this.reorder_quantity,
    required this.buying_price,
    required this.selling_price,
    required this.notify_on_reorder_quantity,
  });

  SupplyItem copyWith({
    String? id,
    String? name_en,
    String? name_ar,
    String? unit_en,
    String? unit_ar,
    num? reorder_quantity,
    num? buying_price,
    num? selling_price,
    bool? notify_on_reorder_quantity,
  }) {
    return SupplyItem(
      id: id ?? this.id,
      name_en: name_en ?? this.name_en,
      name_ar: name_ar ?? this.name_ar,
      unit_en: unit_en ?? this.unit_en,
      unit_ar: unit_ar ?? this.unit_ar,
      reorder_quantity: reorder_quantity ?? this.reorder_quantity,
      buying_price: buying_price ?? this.buying_price,
      selling_price: selling_price ?? this.selling_price,
      notify_on_reorder_quantity:
          notify_on_reorder_quantity ?? this.notify_on_reorder_quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name_en': name_en,
      'name_ar': name_ar,
      'unit_en': unit_en,
      'unit_ar': unit_ar,
      'reorder_quantity': reorder_quantity,
      'selling_price': selling_price,
      'buying_price': buying_price,
      'notify_on_reorder_quantity': notify_on_reorder_quantity,
    };
  }

  factory SupplyItem.fromJson(Map<String, dynamic> map) {
    return SupplyItem(
      id: map['id'] as String,
      name_en: map['name_en'] as String,
      name_ar: map['name_ar'] as String,
      unit_en: map['unit_en'] as String,
      unit_ar: map['unit_ar'] as String,
      reorder_quantity: map['reorder_quantity'] as num,
      buying_price: map['buying_price'] as num,
      selling_price: map['selling_price'] as num,
      notify_on_reorder_quantity: map['notify_on_reorder_quantity'] as bool,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name_en,
      name_ar,
      unit_en,
      unit_ar,
      reorder_quantity,
      buying_price,
      selling_price,
      notify_on_reorder_quantity,
    ];
  }
}
