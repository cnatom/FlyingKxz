import 'abstract.dart';
import 'subcomponents.dart';
import 'utils.dart' as utils;

class ITodoStatus {
  final String _label;
  @override
  toString() => _label;

  const ITodoStatus._(this._label);
  static const NEEDS_ACTION = ITodoStatus._('NEEDS_ACTION');
  static const COMPLETED = ITodoStatus._('COMPLETED');
  static const IN_PROCESS = ITodoStatus._('IN_PROCESS');
  static const CANCELLED = ITodoStatus._('CANCELLED');
}

class ITodo extends ICalendarElement with EventToDo {
  ITodoStatus status;
  DateTime completed;
  DateTime due;
  DateTime start;
  Duration duration;

  String location;
  double lat;
  double lng;
  List<String> resources;
  IAlarm alarm;
  int priority;

  int _complete;
  set complete(int c) {
    assert(c >= 0 && c <= 100);
    _complete = c;
  }

  get complete => _complete;

  ITodo({
    IOrganizer organizer,
    String uid,
    this.status = ITodoStatus.NEEDS_ACTION,
    this.start,
    this.due,
    this.duration,
    this.location,
    this.lat,
    this.lng,
    this.resources,
    this.alarm,
    int percentComplete = 0,
    this.priority = 0,
    String summary,
    String description,
    List<String> categories,
    String url,
    IClass classification = IClass.PRIVATE,
    String comment,
    IRecurrenceRule rrule,
  }) : super(
          organizer: organizer,
          uid: uid,
          summary: summary,
          description: description,
          categories: categories,
          url: url,
          classification: classification,
          comment: comment,
          rrule: rrule,
        ) {
    complete = percentComplete;
  }

  @override
  String serialize() {
    var out = StringBuffer()
      ..write('BEGIN:VTODO$CLRF_LINE_DELIMITER')
      ..write(
          'DTSTAMP:${utils.formatDateTime(start ?? DateTime.now())}$CLRF_LINE_DELIMITER')
      ..write(
          'DTSTART;VALUE=DATE:${utils.formatDate(start)}$CLRF_LINE_DELIMITER')
      ..write('STATUS:$status$CLRF_LINE_DELIMITER');

    if (due != null) {
      out.write('DUE;VALUE=DATE:${utils.formatDate(due)}$CLRF_LINE_DELIMITER');
    }
    if (duration != null) {
      out.write(
          'DURATION:${utils.formatDuration(duration)}$CLRF_LINE_DELIMITER');
    }

    if (complete != null) {
      out.write('PERCENT-COMPLETE:$_complete$CLRF_LINE_DELIMITER');
    }

    out.write(super.serialize());
    out.write(serializeEventToDo());
    out.write('END:VTODO$CLRF_LINE_DELIMITER');
    return out.toString();
  }
}
