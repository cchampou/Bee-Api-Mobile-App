
class FormMessage<T> {

  String message = '';

  reset() {
    message = '';
  }

  setMessage(String value) {
    message = value;
  }

  String getValue() {
    return message;
  }

}