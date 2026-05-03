class Validator {
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return "Please enter your name";
    }
    return null;
  }

  static String? validEmail(String? email) {
    if (email == null) return null;
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      return "Please enter valid email address";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password!.length < 6) {
      return "Password must be 6 chars long";
    }
    return null;
  }
}
