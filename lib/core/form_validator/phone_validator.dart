import 'package:uniform/uniform.dart';

class PhoneValidator implements InputFieldValidator {
  const PhoneValidator();
  @override
  InputFieldError resolve(String? value) {
    if (value != null && value.isNotEmpty) {
      final phoneNumberRegExp = RegExp(r'^\+\d{1,3}[1-9][0-9]{9}$');

      if (!phoneNumberRegExp.hasMatch(value)) {
        return InputFieldError('Please enter a valid phone number with a country code. eg: +977XXXXXXXXXX');
      }
    }

    return InputFieldError.none();
  }
}
