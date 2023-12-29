import 'package:uniform/uniform.dart';

class Older18Validator implements InputFieldValidator {
  const Older18Validator();

  @override
  InputFieldError resolve(DateTime value) {
    if (value.isAfter(DateTime.now().subtract(const Duration(days: 18 * 365)))) {
      return InputFieldError('You must be older than 18 years');
    }
    return InputFieldError.none();
  }
}
