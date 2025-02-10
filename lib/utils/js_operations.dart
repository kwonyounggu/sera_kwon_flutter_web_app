@JS()
library callable_function;

import 'dart:js';
import 'package:js/js.dart';

/// Allows assigning a function to be callable from `window.functionName()`
@JS('setPath')
external set _setPath(void Function() f);

/// Allows calling the assigned function from Dart as well.
@JS()
external void setPath();
