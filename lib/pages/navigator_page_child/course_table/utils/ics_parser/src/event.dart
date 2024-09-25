import 'abstract.dart';
import 'subcomponents.dart';
import 'utils.dart' as utils;

class IEvent extends ICalendarElement with EventToDo {
  IEventStatus status = IEventStatus.CONFIRMED;
  DateTime start;
  DateTime end;
  Duration duration;
  ITimeTransparency transparency = ITimeTransparency.OPAQUE;

  String location;
  double lat, lng;
  List<String> resources;
  IAlarm alarm;
  IOrganizer organizer;
  int priority;

  IEvent({
    IOrganizer organizer,
    String uid,
    this.status,
    this.start,
    this.end,
    this.duration,
    String summary,
    String description,
    List<String> categories,
    String url,
    IClass classification = IClass.PRIVATE,
    String comment,
    IRecurrenceRule rrule,
    this.transparency,
    this.location,
    this.lat,
    this.lng,
    this.resources,
    this.alarm,
    this.priority = 0,
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
        );

  @override
  String serialize() {
    super.serialize();
    var out = StringBuffer()
      ..write('BEGIN:VEVENT$CLRF_LINE_DELIMITER')
      ..write(
          'DTSTAMP:${utils.formatDateTime(start ?? DateTime.now())}$CLRF_LINE_DELIMITER');

    if ((end == null && duration == null)) {
      out.write(
          'DTSTART;VALUE=DATE:${utils.formatDate(start)}$CLRF_LINE_DELIMITER');
    } else {
      out.write('DTSTART:${utils.formatDateTime(start)}$CLRF_LINE_DELIMITER');
    }

    if (end != null) {
      out.write('DTEND:${utils.formatDateTime(end)}$CLRF_LINE_DELIMITER');
    }
    if (duration != null) {
      out.write(
          'DURATION:${utils.formatDuration(duration)}$CLRF_LINE_DELIMITER');
    }
    if (transparency != null) {
      out.write('TRANSP:$transparency$CLRF_LINE_DELIMITER');
    }

    out
      ..write('STATUS:$status$CLRF_LINE_DELIMITER')
      ..write(super.serialize())
      ..write(serializeEventToDo())
      ..write('END:VEVENT$CLRF_LINE_DELIMITER');
    return out.toString();
  }
}

class IEventStatus {
  final String _label;
  @override
  toString() => _label;

  const IEventStatus._(this._label);
  static const TENTATIVE = IEventStatus._('TENTATIVE');
  static const CONFIRMED = IEventStatus._('CONFIRMED');
  static const CANCELLED = IEventStatus._('CANCELLED');
}

class ITimeTransparency {
  final String _label;
  @override
  toString() => _label;
  const ITimeTransparency._(this._label);
  static const OPAQUE = ITimeTransparency._('OPAQUE');
  static const TRANSPARENT = ITimeTransparency._('TRANSPARENT');
}
