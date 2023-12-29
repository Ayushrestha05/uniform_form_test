import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniform/uniform.dart';
import 'package:uniform_form_app/core/enum.dart';
import 'package:uniform_form_app/features/form_entry/presentation/common/form_widget.dart';
import 'package:uniform_form_app/features/form_entry/presentation/dynamic_form/dynamic_form_presenter.dart';

import '../../domain/entity/form_entity.dart';

class DynamicFormView extends ConsumerWidget {
  const DynamicFormView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formProvider = ref.watch(dynamicFormPresenterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Form'),
      ),
      body: SafeArea(
        child: Center(
            child: switch (formProvider.loadStatus) {
          FormStatus.success => SingleChildScrollView(
              child: InputForm(
                controller: ref.watch(dynamicFormPresenterProvider.notifier).formController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ref.watch(dynamicFormPresenterProvider).formErrors.isNotEmpty
                          ? ErrorFormWidget(errors: ref.read(dynamicFormPresenterProvider).formErrors)
                          : const SizedBox.shrink(),
                      ...formProvider.formFields.map((e) => buildFormFieldWidgets(e)).toList(),
                      ...formProvider.formFields.isNotEmpty
                          ? [
                              ElevatedButton(
                                onPressed: () => ref.watch(dynamicFormPresenterProvider.notifier).submitForm(),
                                child: const Text('Submit'),
                              ),
                            ]
                          : [],
                      ref.watch(dynamicFormPresenterProvider.notifier).formController.isSubmitted
                          ? SuccessFormWidget(formEntity: ref.read(dynamicFormPresenterProvider))
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          FormStatus.error => const Text('Some Error Occurred! Please try again later.'),
          _ => const CircularProgressIndicator(),
        }),
      ),
    );
  }
}

Widget buildFormFieldWidgets(FormFieldEntity field) {
  return switch (field.type) {
    'text' || 'email' || 'textarea' || 'tel' => InputFieldBuilder(
        tag: field.id,
        builder: (context, controller, widget) {
          return TextFormField(
            decoration: InputDecoration(
              hintText: field.label,
              errorText: controller.error.message,
            ),
            enabled: !controller.isSubmitted,
            onChanged: controller.onChanged,
            maxLines: field.type == 'textarea' ? null : 1,
            //KeyboardType might be useful on mobile
            keyboardType: switch (field.type) {
              'text' => TextInputType.text,
              'email' => TextInputType.emailAddress,
              'address' => TextInputType.streetAddress,
              'tel' => TextInputType.phone,
              _ => TextInputType.text,
            },
          );
        }),
    'radio' => InputFieldBuilder(
        tag: field.id,
        builder: (context, controller, widget) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
              ),
              ...field.options?.map((e) => RadioListTile<String>(
                        title: Text(e ?? ''),
                        value: e,
                        groupValue: controller.value.toString(),
                        onChanged: controller.onChanged,
                      )) ??
                  [],
            ],
          );
        }),
    'checkbox' => InputFieldBuilder(
        tag: field.id,
        builder: (context, controller, widget) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(field.label),
              Checkbox.adaptive(
                value: (controller.value ?? false) as bool?,
                onChanged: (val) => controller.onChanged(val),
              ),
            ],
          );
        }),
    'select' => InputFieldBuilder(
        tag: field.id,
        builder: (context, controller, widget) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
              ),
              DropdownButtonFormField<String>(
                value: null,
                onChanged: controller.onChanged,
                items: field.options
                        ?.map((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e ?? ''),
                            ))
                        .toList() ??
                    [],
              ),
            ],
          );
        }),
    'file' => InputFieldBuilder(
        tag: field.id,
        builder: (context, controller, widget) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
              ),
              controller.value != null
                  ? Text((controller.value as FilePickerResult).files.first.path ?? 'Path Not Found!')
                  : const SizedBox.shrink(),
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  controller.onChanged(result);
                },
                child: const Text('Upload File'),
              ),
            ],
          );
        }),
    'date' => InputFieldBuilder(
        tag: field.id,
        builder: (context, controller, widget) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                field.label,
              ),
              controller.value != null
                  ? Text('Selected Date:- ${(controller.value as DateTime).toString()}')
                  : const SizedBox.shrink(),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  controller.onChanged(pickedDate);
                },
                child: const Text('Pick Date'),
              ),
            ],
          );
        }),
    _ => const SizedBox.shrink(),
  };
}
