import 'package:uniform/uniform.dart';

class EmailValidator implements InputFieldValidator {
  const EmailValidator();
  @override
  InputFieldError resolve(String? value) {
    if (value != null && value.isNotEmpty) {
      final emailRegex = RegExp(r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(\.[a-zA-Z\d-]{2,})+$');

      if (!emailRegex.hasMatch(value)) {
        return InputFieldError('Please enter a valid email address.');
      }
    }

    return InputFieldError.none();
  }
}
