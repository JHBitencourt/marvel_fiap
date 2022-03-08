import 'package:formz/formz.dart';
import 'package:marvel/domain/extensions/string_extension.dart';

class Email extends FormzInput<String, String> {
  const Email.pure() : super.pure('');

  const Email.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String? value) {
    if (value == null || value.isEmpty) return 'Preencha o e-mail';

    if (value.contains(' ')) return 'O e-mail não pode conter espaços';

    if (!value.isValidMail()) return 'E-mail inválido';

    return null;
  }
}
