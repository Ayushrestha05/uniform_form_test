import 'dart:developer';

import 'package:uniform_form_app/core/enum.dart';
import 'package:uniform_form_app/features/form_entry/data/form_repo.dart';
import 'package:uniform_form_app/features/form_entry/data/models/form_model.dart';
import 'package:uniform_form_app/features/form_entry/domain/entity/form_entity.dart';

class FormUseCase {
  Future<FormEntity> getFormStructure() async {
    FormModel responseModel = await FormRepo().getFormData();
    log(responseModel.status.toString());
    return responseModel.status == FormStatus.success
        ? FormEntity(
            formTitle: responseModel.formTitle,
            formFields: responseModel.formFields
                .map((e) => FormFieldEntity(
                      id: e.id,
                      label: e.label,
                      type: e.type,
                      required: e.required,
                      options: e.options,
                      multiple: e.multiple,
                    ))
                .toList(),
            loadStatus: FormStatus.success,
          )
        : FormEntity(
            formTitle: '',
            formFields: [],
            formResults: [],
            formErrors: {},
            loadStatus: FormStatus.loading,
          );
  }
}
