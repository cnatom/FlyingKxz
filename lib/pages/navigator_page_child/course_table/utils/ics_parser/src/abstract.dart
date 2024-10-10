
import 'package:nanoid2/nanoid2.dart';

import 'utils.dart' as utils;
import 'subcomponents.dart';

import 'utils.dart';

const CLRF_LINE_DELIMITER = "\r\n";

abstract class AbstractSerializer {
  String serialize();
}

class IClass {
  final String _label;
  @override
  toString() => _label;
  const IClass._(this._label);
  static const PUBLIC = IClass._('PUBLIC');
  static const PRIVATE = IClass._('PRIVATE');
  static const CONFIDENTIAL = IClass._('CONFIDENTIAL');
}

class IRecurrenceFrequency {
  final String _label;
  @override
  toString() => _label;
  const IRecurrenceFrequency._(this._label);
  static const SECONDLY = IRecurrenceFrequency._('SECONDLY');
  static const MINUTELY = IRecurrenceFrequency._('MINUTELY');
  static const HOURLY = IRecurrenceFrequency._('HOURLY');
  static const DAILY = IRecurrenceFrequency._('DAILY');
  static const WEEKLY = IRecurrenceFrequency._('WEEKLY');
  static const MONTHLY = IRecurrenceFrequency._('MONTHLY');
  static const YEARLY = IRecurrenceFrequency._('YEARLY');
  static const BYSECOND = IRecurrenceFrequency._('BYSECOND');
  static const BYMINUTE = IRecurrenceFrequency._('BYMINUTE');
  static const BYHOUR = IRecurrenceFrequency._('BYHOUR');
  static const BYDAY = IRecurrenceFrequency._('BYDAY');
  static const BYMONTHDAY = IRecurrenceFrequency._('BYMONTHDAY');
  static const BYYEARDAY = IRecurrenceFrequency._('BYYEARDAY');
  static const BYWEEKNO = IRecurrenceFrequency._('BYWEEKNO');
  static const BYMONTH = IRecurrenceFrequency._('BYMONTH');
  static const BYSETPOS = IRecurrenceFrequency._('BYSETPOS');
  static const WKST = IRecurrenceFrequency._('WKST');
}

class IRecurrenceRule {
  IRecurrenceFrequency frequency = IRecurrenceFrequency.DAILY;
  DateTime untilDate;
  int count;
  int interval;
  int weekday;
  // TODO BYSECOND, BYMINUTE, BYHOUR, BYDAY,BYMONTHDAY,BYYEARDAY,BYWEEKNO,BYMONTH,BYSETPOS,WKST

  static List<String> weekdays = <String>[
    "SU",
    "MO",
    "TU",
    "WE",
    "TH",
    "FR",
    "SA"
  ];
  IRecurrenceRule({
    required this.frequency,
    required this.untilDate,
    this.count = 0,
    this.interval = 0,
    this.weekday = 0,
  });
  String serialize() {
    var out = StringBuffer();
    out..write('RRULE:FREQ=$frequency');

    if (untilDate != null) {
      out.write(';UNTIL=${utils.formatDateTime(untilDate)}');
    }
    if (count > 0) {
      out.write(';COUNT=$count');
    }
    if (interval > 0) {
      out.write(';INTERVAL=$interval');
    }
    if (weekday > 0 && weekday < 8) {
      out.write(';WKST=${weekdays[weekday - 1]}');
    }
    out.write(CLRF_LINE_DELIMITER);
    return out.toString();
  }
}

class IOrganizer {
  String? name;
  String? email;
  IOrganizer({this.name, this.email});
  String serializeOrganizer() {
    var out = StringBuffer()..write('ORGANIZER');
    if (name != null) {
      out.write(';CN=${escapeValue(name!)}');
    }
    if (email == null) {
      return '';
    }
    out.write(':mailto:$email$CLRF_LINE_DELIMITER');
    return out.toString();
  }
}

abstract class ICalendarElement extends AbstractSerializer {
  IOrganizer? organizer;
  String? uid;
  String? summary;
  String? description;
  List<String>? categories;
  String? url;
  IClass? classification;
  String? comment;
  IRecurrenceRule? rrule;

  ICalendarElement({
    this.organizer,
    this.uid,
    this.summary,
    this.description,
    this.categories,
    this.url,
    this.classification = IClass.PRIVATE,
    this.comment,
    this.rrule,
  });

  String _foldLiens(String value, {String preamble = "DESCRIPTION:"}) {
    const CONTENT_LINES_MAX_OCTETS = 75;
    const CONTENT_LINES_MAX_OCTETS_WITHOUT_SPACE = CONTENT_LINES_MAX_OCTETS - 1;

    if (value == null || value.isEmpty) return '';

    final lines = [];
    var v = value;

    final LINE_LENGTH_WITHOUT_PREAMBLE =
        CONTENT_LINES_MAX_OCTETS - preamble.length;

    if (v.length > LINE_LENGTH_WITHOUT_PREAMBLE) {
      lines.add(v.substring(0, LINE_LENGTH_WITHOUT_PREAMBLE));
      v = v.substring(LINE_LENGTH_WITHOUT_PREAMBLE);
    }

    while (v.length > CONTENT_LINES_MAX_OCTETS_WITHOUT_SPACE) {
      lines.add(v.substring(0, CONTENT_LINES_MAX_OCTETS_WITHOUT_SPACE));
      v = v.substring(CONTENT_LINES_MAX_OCTETS_WITHOUT_SPACE);
    }
    if (v.isNotEmpty) lines.add(v);

    return lines.length == 1
        ? lines.first
        : lines.join("$CLRF_LINE_DELIMITER\t");
  }

  String serialize() {
    var out = StringBuffer();

    uid ??= nanoid(length: 32);

    out.write('UID:$uid$CLRF_LINE_DELIMITER');

    if (categories != null) {
      out.write(
          'CATEGORIES:${categories?.map(escapeValue).join(',')}$CLRF_LINE_DELIMITER');
    }

    if (comment != null) {
      out.write('COMMENT:${escapeValue(comment!)}$CLRF_LINE_DELIMITER');
    }
    if (summary != null) {
      out.write('SUMMARY:${escapeValue(summary!)}$CLRF_LINE_DELIMITER');
    }
    if (url != null) {
      out.write('URL:${url}$CLRF_LINE_DELIMITER');
    }
    if (classification != null) {
      out.write('CLASS:$classification$CLRF_LINE_DELIMITER');
    }
    if (description != null) {
      out.write(
          'DESCRIPTION:${_foldLiens(escapeValue(description!))}$CLRF_LINE_DELIMITER');
    }
    if (rrule != null) out.write(rrule!.serialize());

    return out.toString();
  }
  // TODO ATTENDEE
  // TODO CONTACT
}

// Component Properties for Event + To-Do

mixin EventToDo {
  String? location;
  double? lat;
  double? lng;
  int? priority;
  List<String>? resources;
  IAlarm? alarm;

  String serializeEventToDo() {
    var out = StringBuffer();
    if (location != null) {
      out.write('LOCATION:${escapeValue(location!)}$CLRF_LINE_DELIMITER');
    }
    if (lat != null && lng != null) {
      out.write('GEO:$lat;$lng$CLRF_LINE_DELIMITER');
    }
    if (resources != null) {
      out.write(
          'RESOURCES:${resources?.map(escapeValue).join(',')}$CLRF_LINE_DELIMITER');
    }
    if (priority != null) {
      priority = (priority! >= 0 && priority! <= 9) ? priority : 0;
      out.write('PRIORITY:$priority$CLRF_LINE_DELIMITER');
    }
    if (alarm != null) out.write(alarm!.serialize());

    return out.toString();
  }
}
