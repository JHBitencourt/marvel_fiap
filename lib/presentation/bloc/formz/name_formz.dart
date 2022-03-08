import 'package:formz/formz.dart';

class Name extends FormzInput<String, String> {
  const Name.pure() : super.pure('');

  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) return 'Preencha o seu nome';
    if (value.length < 8) return 'Nome muito curto';

    return null;
  }
}
