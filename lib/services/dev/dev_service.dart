import "dart:developer" as devtools show log;

class DevService {
  void log(Object message) {
    devtools.log(message.toString());
  }
}
