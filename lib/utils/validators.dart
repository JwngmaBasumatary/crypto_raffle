class NameValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return "Name can't be Empty";
    } else {
      return null;
    }
  }
}

class YoutubeUrlValidator {
  static String? validate(String value) {
    Pattern pattern =
        r"(https?|http):\\([-A-Z0-9.]+)(\[-A-Z0-9+&@#\%=~_|!:,.;]*)?(\?[A-Z0-9+&@#\%=~_|!:‌​,.;]*)?";
    RegExp regex = RegExp(pattern.toString());
    if (value.isEmpty) {
      return "Youtube Link Can't be Empty";
    } else if (!regex.hasMatch(value)) {
      return 'Enter a valid Youtube video Link';
    } else {
      return null;
    }
  }
}

class Emailvalidator {
  static String? validate(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern.toString());
    if (value.isEmpty) {
      return "Email can't be Empty";
    } else if (!regex.hasMatch(value) || value.isEmpty) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }
}

class Passwordvalidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return "Password can't be Empty";
    } else if (value.length < 6) {
      return "Password lenth is too Short(min 6 chars)";
    } else if (value.length > 10) {
      return "Password lenth is too Long(max 10 chars)";
    } else {
      return null;
    }
  }
}

class PhoneValidator {
  static String? validate(String value) {
    if (value.isEmpty) {
      return "Phone Number can't be Empty";
    } else if (value.length < 10) {
      return "Phone Number lenth is too Short(min 10 chars)";
    } else if (value.length > 10) {
      return "Phone Number lenth is too Long(max 10 chars)";
    } else {
      return null;
    }
  }
}
