import 'package:formz/formz.dart';

class Password extends FormzInput<String, String> {
  const Password.pure() : super.pure('');

  const Password.dirty([String value = '']) : super.dirty(value);

  @override
  String? validator(String value) {
    if (value.contains(' ')) return 'A senha não pode conter espaços';

    if (value.length < 8) return 'Senha muito curta';

    if (value.length > 16) return 'Senha muito longa';

    return null;
  }
}

class NewPassword extends FormzInput<String, String> {
  const NewPassword.pure() : super.pure('');

  const NewPassword.dirty([String value = '']) : super.dirty(value);

  static final _invalidRegExp = RegExp('[áàâãéèêíïóôõöúçñÁÀÂÃÉÈÍÏÓÔÕÖÚÇÑ]+');
  static final _passRegExp = RegExp('^'
      '((?=.*[A-Z])(?=.*[a-z])|'
      '(?=.*[A-Z])(?=.*[0-9])|'
      '(?=.*[A-Z])(?=.*[!@#\$%^&*])|'
      '(?=.*[a-z])(?=.*[0-9])|'
      '(?=.*[a-z])(?=.*[!@#\$%^&*])|'
      '(?=.*[0-9])(?=.*[!@#\$%^&*]))'
      '.*\$');

  @override
  String? validator(String value) {
    if (value.contains(' ')) return 'A senha não pode conter espaços';

    if (value.length < 8 || value.length > 16) {
      return 'Utilize entre 8 e 16 caracteres';
    }

    if (_invalidRegExp.hasMatch(value)) {
      return 'Não utilize caracteres com acento';
    }

    if (!_passRegExp.hasMatch(value)) {
      return 'Utilize ao menos duas opções: letra maiúscula, '
          'letra minúscula, número ou caractere especial';
    }

    return null;
  }
}

class ConfirmedPassword extends FormzInput<String, String> {
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');

  const ConfirmedPassword.dirty({required this.password, String value = ''})
      : super.dirty(value);

  final String password;

  @override
  String? validator(String value) {
    return password == value ? null : 'As senhas precisam ser iguais';
  }
}
