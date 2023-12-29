// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:uniform_form_app/core/enum.dart';

class FormEntity {
  String formTitle;
  List<FormFieldEntity> formFields;
  List<FormFieldResultEntity> formResults;
  Map formErrors;
  FormStatus loadStatus = FormStatus.loading;

  FormEntity({
    this.formTitle = '',
    this.formFields = const <FormFieldEntity>[],
    this.formErrors = const {},
    this.formResults = const <FormFieldResultEntity>[],
    this.loadStatus = FormStatus.loading,
  });

  FormEntity copyWith({
    String? formName,
    String? formDescription,
    List<FormFieldEntity>? formFields,
    Map? formErrors,
    List<FormFieldResultEntity>? formResults,
    FormStatus? loadStatus,
  }) {
    return FormEntity(
      formTitle: formName ?? formTitle,
      formFields: formFields ?? this.formFields,
      formErrors: formErrors ?? this.formErrors,
      formResults: formResults ?? this.formResults,
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }
}

class FormFieldEntity {
  String id;
  String label;
  String type;
  bool? required;
  List? options;
  bool? multiple;

  FormFieldEntity(
      {required this.id, required this.label, required this.type, this.required, this.options, this.multiple});
}

class FormFieldResultEntity {
  String id;
  String label;
  dynamic value;

  FormFieldResultEntity({required this.id, required this.label, this.value});
}
