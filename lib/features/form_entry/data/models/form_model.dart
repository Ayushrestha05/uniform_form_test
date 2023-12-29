import 'package:uniform_form_app/core/enum.dart';

class FormModel {
  String formTitle;
  List<FormFieldModel> formFields;
  FormStatus status = FormStatus.loading;

  FormModel({
    required this.formTitle,
    required this.formFields,
    this.status = FormStatus.loading,
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      formTitle: json['formTitle'] as String,
      formFields:
          (json['formFields'] as List<dynamic>).map((e) => FormFieldModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

class FormFieldModel {
  String id;
  String label;
  String type;
  bool? required;
  List? options;
  dynamic value;
  bool? multiple;

  FormFieldModel({
    required this.id,
    required this.label,
    required this.type,
    this.required,
    this.options,
    this.value,
    this.multiple,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    return FormFieldModel(
      id: json['id'] as String,
      label: json['label'] as String,
      type: json['type'] as String,
      options: json['options'] as List?,
      required: json['required'] as bool?,
      value: json['value'],
      multiple: json['multiple'] as bool?,
    );
  }
}
