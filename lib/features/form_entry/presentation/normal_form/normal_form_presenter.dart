// ignore_for_file: unused_field

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniform/uniform.dart';
import 'package:uniform_form_app/core/form_validator/email_validator.dart';
import 'package:uniform_form_app/core/form_validator/older18_validator.dart';
import 'package:uniform_form_app/features/form_entry/domain/entity/form_entity.dart';

enum FormFieldTags { name, dob, email }

class NormalFormPresenterProvider extends AutoDisposeNotifier<FormEntity> {
  late final FormController formController;

  late final TextFieldController _nameController;
  late final FieldController _dobController;
  late final FieldController _emailController;

  @override
  FormEntity build() {
    formController = FormController();

    // formController.addListener(() {
    //   state = state.copyWith(formErrors: formController.errors);
    // });

    _nameController = TextFieldController.create(
      formController,
      tag: 'name',
      autoValidate: true,
    )..setValidators({const InputFieldValidator.required()});

    _dobController = FieldController<DateTime>.create(
      formController,
      tag: 'dob',
      autoValidate: true,
    )..setValidators({const InputFieldValidator.required(), const Older18Validator()});

    _emailController = FieldController<String>.create(
      formController,
      tag: 'email',
      autoValidate: true,
    )..setValidators({const InputFieldValidator.required(), const EmailValidator()});

    return FormEntity();
  }

  void onSave() {
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

final normalFormPresenterProvider =
    NotifierProvider.autoDispose<NormalFormPresenterProvider, FormEntity>(NormalFormPresenterProvider.new);
