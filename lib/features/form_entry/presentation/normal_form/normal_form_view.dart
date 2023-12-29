import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uniform/uniform.dart';
import 'package:uniform_form_app/features/form_entry/presentation/normal_form/normal_form_presenter.dart';

import '../common/form_widget.dart';

class NormalFormView extends ConsumerWidget {
  const NormalFormView({super.key});

  static const kHSpacer = SizedBox(height: 10);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final normalFormPresenter = ref.watch(normalFormPresenterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Normal Form'),
      ),
      body: SafeArea(
        child: InputForm(
          controller: ref.watch(normalFormPresenterProvider.notifier).formController,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ref.watch(normalFormPresenterProvider).formErrors.isNotEmpty
                    ? ErrorFormWidget(errors: ref.read(normalFormPresenterProvider).formErrors)
                    : const SizedBox.shrink(),
                TextInputFieldBuilder(
                  tag: 'name',
                  builder: (_, controller, textController) => TextFormField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      errorText: controller.error.message,
                    ),
                    enabled: !controller.isSubmitted,
                    onChanged: controller.onChanged,
                  ),
                ),
                kHSpacer,
                InputFieldBuilder(
                    tag: 'email',
                    builder: (context, controller, widget) {
                      return TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          errorText: controller.error.message,
                        ),
                        enabled: !controller.isSubmitted,
                        onChanged: controller.onChanged,
                      );
                    }),
                kHSpacer,
                InputFieldBuilder(
                  tag: 'dob',
                  builder: (context, controller, widget) {
                    return ElevatedButton(
                      onPressed: () async {
                        var selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        controller.setValue(selectedDate);
                      },
                      child: Text('Date ${(controller.value != null) ? controller.value.toString() : 'Select'}'),
                    );
                  },
                ),
                kHSpacer,
                ElevatedButton(
                    onPressed: () {
                      ref.read(normalFormPresenterProvider.notifier).onSave();
                    },
                    child: const Text('Submit')),
                kHSpacer,
                ref.watch(normalFormPresenterProvider.notifier).formController.isSubmitted
                    ? SuccessFormWidget(formEntity: ref.read(normalFormPresenterProvider))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
