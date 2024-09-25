import 'package:ical/src/utils.dart';

import 'abstract.dart';
import 'utils.dart' as utils;

class IAlarmType {
  final String _label;
  @override
  toString() => _label;

  const IAlarmType._(this._label);
  static const DISPLAY = IAlarmType._('DISPLAY');
  static const AUDIO = IAlarmType._('AUDIO');
  static const EMAIL = IAlarmType._('EMAIL');
}

class IAlarm extends AbstractSerializer {
  IAlarmType type;
  Duration duration;
  int repeat;
  DateTime trigger;
  String description, summary;

  IAlarm.display({
    this.duration = const Duration(minutes: 15),
    this.repeat = 1,
    this.trigger,
    this.description,
  }) : type = IAlarmType.DISPLAY;
  IAlarm.audio({
    this.duration = const Duration(minutes: 15),
    this.repeat = 1,
    this.trigger,
  }) : type = IAlarmType.AUDIO;

  // TODO IAlarm.email(
  //    {this.duration,
  //    this.repeat,
  //    this.trigger,
  //    this.description,
  //    this.summary})
  //s    : type = AlarmType.EMAIL;

  String _serializeDescription() => 'DESCRIPTION:${escapeValue(description)}';

  @override
  String serialize() {
    var out = StringBuffer()
      ..write('BEGIN:VALARM$CLRF_LINE_DELIMITER')
      ..write('ACTION:$type$CLRF_LINE_DELIMITER');
    switch (type) {
      case IAlarmType.DISPLAY:
        out.write(_serializeDescription() + CLRF_LINE_DELIMITER);
        break;
      case IAlarmType.EMAIL:
        out.write(_serializeDescription() + CLRF_LINE_DELIMITER);
        out.write('SUMMARY:${escapeValue(summary)}$CLRF_LINE_DELIMITER');

        // TODO ATTENDEE
        break;
    }

    if (repeat > 1) {
      out.write('REPEAT:$repeat$CLRF_LINE_DELIMITER');
      out.write(
          'DURATION:${utils.formatDuration(duration)}$CLRF_LINE_DELIMITER');
    }

    if (trigger != null) {
      out.write(
          'TRIGGER;VALUE=DATE-TIME:${utils.formatDateTime(trigger)}$CLRF_LINE_DELIMITER');
    }

    out.write('END:VALARM$CLRF_LINE_DELIMITER');
    return out.toString();
  }
}
