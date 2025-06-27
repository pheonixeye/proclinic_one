import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/doctor_profile_items_api.dart';
import 'package:proklinik_one/functions/contains_arabic.dart';
import 'package:proklinik_one/models/doctor_items/_doctor_item.dart';

class PxDoctorProfileItems extends ChangeNotifier {
  final DoctorProfileItemsApi api;

  PxDoctorProfileItems({required this.api}) {
    _fetchItems();
  }

  ApiResult<List<DoctorItem>>? _data;
  ApiResult<List<DoctorItem>>? get data => _data;

  ApiResult<List<DoctorItem>>? _filteredData;
  ApiResult<List<DoctorItem>>? get filteredData => _filteredData;

  Future<void> _fetchItems() async {
    _data = await api.fetchDoctorProfileItems();
    _filteredData = _data;
    notifyListeners();
  }

  Future<void> retry() async => await _fetchItems();

  Future<void> addNewItem(DoctorItem item) async {
    await api.createItem(item);
    await api.fetchDoctorProfileItems();
  }

  Future<void> updateItem(DoctorItem item) async {
    await api.updateItem(item);
    await api.fetchDoctorProfileItems();
  }

  Future<void> deleteItem(DoctorItem item) async {
    await api.deleteItem(item);
    await api.fetchDoctorProfileItems();
  }

  void searchForItems(String item_name) {
    _filteredData = ApiDataResult(
        data: (_data as ApiDataResult<List<DoctorItem>>)
            .data
            .where(
              (e) => containsArabic(item_name)
                  ? e.name_ar.toLowerCase().startsWith(item_name)
                  : e.name_en.toLowerCase().startsWith(item_name),
            )
            .toList());
    notifyListeners();
  }

  void clearSearch() {
    _filteredData = _data;
    notifyListeners();
  }
}
