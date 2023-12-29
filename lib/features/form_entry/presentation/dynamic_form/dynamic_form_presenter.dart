import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniform/uniform.dart';
import 'package:uniform_form_app/core/form_validator/email_validator.dart';
import 'package:uniform_form_app/core/form_validator/phone_validator.dart';
import 'package:uniform_form_app/features/form_entry/domain/entity/form_entity.dart';
import 'package:uniform_form_app/features/form_entry/domain/form_usecase.dart';

class DynamicFormPresenterProvider extends AutoDisposeNotifier<FormEntity> {
  late FormController formController;

  @override
  FormEntity build() {
    formController = FormController();
    state = FormEntity();

    getFormStructure();

    return state;
  }

  Future<void> getFormStructure() async {
    state = await FormUseCase().getFormStructure();
    log(state.loadStatus.toString());
    _createInputControllers();
  }

  void _createInputControllers() {
    for (FormFieldEntity field in state.formFields) {
      FieldController.create(formController, tag: field.id).setValidators({
        if (field.required ?? false) const InputFieldValidator.required(),
        if (field.type == 'email') const EmailValidator(),
        if (field.type == 'tel') const PhoneValidator(),
      });
    }
  }

  void submitForm() {
    if (formController.validate()) {
      log('Form is valid');
      formController.setSubmitted(true);
      state = state.copyWith(
        formName: 'Normal Form',
        formDescription: 'This is a normal form',
        formResults: [
          ...formController.values.entries
              .map((e) => FormFieldResultEntity(
                    id: e.key.toString(),
                    label: e.key.toString(),
                    value: e.value,
                  ))
              .toList()
        ],
        formErrors: {},
      );
    } else {
      formController.setSubmitted(false);
      log('Form is invalid');
      log('Form Controller Errors: ${formController.errors}');
      state = state.copyWith(
        formErrors: formController.errors,
      );
    }
  }
}

final dynamicFormPresenterProvider =
    NotifierProvider.autoDispose<DynamicFormPresenterProvider, FormEntity>(DynamicFormPresenterProvider.new);
