import 'package:flutter/material.dart';
import 'package:proklinik_one/models/clinic/prescription_details.dart';
import 'package:proklinik_one/models/visit_data/visit_form_item.dart';
import 'package:screenshot/screenshot.dart';

enum PrescriptionView {
  regular,
  forms;
}

class PxVisitPrescriptionState extends ChangeNotifier {
  PxVisitPrescriptionState() {
    init();
  }

  final ScreenshotController _screenshotController1 = ScreenshotController();
  ScreenshotController get screenshotControllerWithImage =>
      _screenshotController1;

  final ScreenshotController _screenshotController2 = ScreenshotController();
  ScreenshotController get screenshotControllerWithoutImage =>
      _screenshotController2;

  Map<String, bool> _visitPrescriptionVisibility = {};
  Map<String, bool> get visitPrescriptionVisibility =>
      _visitPrescriptionVisibility;

  void init() {
    _visitPrescriptionVisibility = Map.fromEntries(
      PrescriptionDetails.initial().details.keys.map(
        (e) {
          return MapEntry(e, true);
        },
      ),
    );
    notifyListeners();
  }

  void toggleVisibility(String key) {
    _visitPrescriptionVisibility[key] = !_visitPrescriptionVisibility[key]!;
    notifyListeners();
  }

  PrescriptionView _view = PrescriptionView.regular;
  PrescriptionView get view => _view;

  void toggleView() {
    _view = _view == PrescriptionView.regular
        ? PrescriptionView.forms
        : PrescriptionView.regular;
    notifyListeners();
  }

  List<SingleFieldData>? _formItems;
  List<SingleFieldData>? get formItems => _formItems;

  String? _selectedFormId;
  String? get selectedFormId => _selectedFormId;

  void selectFormItems(List<SingleFieldData>? items, String? formId) {
    _formItems = items;
    _selectedFormId = formId;
    notifyListeners();
  }

  CrossAxisAlignment _formItemsCrossAxisAlignment = CrossAxisAlignment.center;
  CrossAxisAlignment get formItemsCrossAxisAlignment =>
      _formItemsCrossAxisAlignment;

  TextAlign _formItemsTextAlign = TextAlign.center;
  TextAlign get formItemsTextAlign => _formItemsTextAlign;

  void toggleAxisAlignment() {
    final _index = _axisAlignments.indexOf(_formItemsCrossAxisAlignment);
    try {
      _formItemsCrossAxisAlignment = _axisAlignments[_index + 1];
      notifyListeners();
    } catch (e) {
      _formItemsCrossAxisAlignment = _axisAlignments[0];
      notifyListeners();
    }
  }

  void toggleTextAlignment() {
    final _index = _textAlignments.indexOf(_formItemsTextAlign);
    try {
      _formItemsTextAlign = _textAlignments[_index + 1];
      notifyListeners();
    } catch (e) {
      _formItemsTextAlign = _textAlignments[0];
      notifyListeners();
    }
  }
}

final _axisAlignments = [
  CrossAxisAlignment.center,
  CrossAxisAlignment.start,
  CrossAxisAlignment.end,
];

final _textAlignments = [
  TextAlign.center,
  TextAlign.right,
  TextAlign.left,
];
