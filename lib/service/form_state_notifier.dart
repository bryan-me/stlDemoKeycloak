// form_state_notifier.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';

class FormStateNotifier with ChangeNotifier {
  Map<String, dynamic> _formData = {};
  List<SignatureController> _signatureControllers = [];

  FormStateNotifier() {
    _loadFormData(); // Load saved form data on initialization
  }

  void updateFormData(String key, dynamic value) {
    _formData[key] = value;
    notifyListeners();
    _saveFormData(); // Save form data to SharedPreferences
  }

  dynamic getFormData(String key) => _formData[key];

  void addSignatureController(SignatureController controller) {
    _signatureControllers.add(controller);
  }

  SignatureController getSignatureController(int index) {
    return _signatureControllers[index];
  }

  Future<void> _saveFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('formData', jsonEncode(_formData));
  }

  Future<void> _loadFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('formData');
    if (savedData != null) {
      _formData = jsonDecode(savedData);
      notifyListeners();
    }
  }

  Future<void> clearFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('formData');
    _formData.clear();
    notifyListeners();
  }
}
