import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniform_form_app/core/enum.dart';
import 'package:uniform_form_app/core/network/api_interface.dart';
import 'package:uniform_form_app/features/form_entry/data/models/form_model.dart';

class FormRepo extends NetworkApiInterface {
  Future<FormModel> getFormData() async {
    try {
      var response = await client.get('employee_form');
      var decode = jsonDecode(response.body);
      return FormModel.fromJson(decode)..status = FormStatus.success;
    } catch (e) {
      log(e.toString());
      return FormModel(formTitle: '', formFields: [], status: FormStatus.error);
    }
  }
}

final formRepoProvider = Provider<FormRepo>((ref) => FormRepo());
