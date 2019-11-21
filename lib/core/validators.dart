RegExp _digit = new RegExp(r'[0-9]');
RegExp _alpha = new RegExp(r'[a-zA-Z]');

bool isDigit(String char) => _digit.hasMatch(char);

bool isLetter(String char) => _alpha.hasMatch(char);