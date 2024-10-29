class NextNodeNameGenerator {
  bool _literals = false;
  int _nextNodeName = 1;

  NextNodeNameGenerator(this._literals);

  String getNextNodeName() {
    if (_literals) {
      return numberToLiteral(_nextNodeName++);
    } else {
      return (_nextNodeName++).toString();
    }
  }

  String numberToLiteral(int number) {
    if (!_literals) {
      return number.toString();
    }

    String result = "";
    while (number > 0) {
      int remainder = (number - 1) % 26;
      result = String.fromCharCode(65 + remainder) + result;
      number = (number - 1) ~/ 26;
    }
    return result;
  }
}