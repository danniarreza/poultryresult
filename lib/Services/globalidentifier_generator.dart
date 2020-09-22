import 'dart:math';

generate_GlobalIdentifier() {

  var ms = (DateTime.now()).millisecondsSinceEpoch;

  var randomNumber = Random().nextInt(10);
  String globalidentifier = (ms * randomNumber).toString();

  return globalidentifier;

}