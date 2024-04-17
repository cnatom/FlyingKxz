import 'abstract.dart';
import 'utils.dart' as utils;

class ICalendar extends AbstractSerializer {
  List<ICalendarElement> _elements = <ICalendarElement>[];
  String company;
  String product;
  String lang;
  Duration refreshInterval;

  List<ICalendarElement> get elements => _elements;

  ICalendar({
    this.company = 'dartclub',
    this.product = 'ical/serializer',
    this.lang = 'EN',
    this.refreshInterval,
  });

  addAll(List<ICalendarElement> elements) => _elements.addAll(elements);
  addElement(ICalendarElement element) => _elements.add(element);

  @override
  String serialize() {
    var out = StringBuffer()
      ..write('BEGIN:VCALENDAR$CLRF_LINE_DELIMITER')
      ..write('VERSION:2.0$CLRF_LINE_DELIMITER')
      ..write('PRODID://${company}//${product}//${lang}$CLRF_LINE_DELIMITER');

    if (refreshInterval != null) {
      out.write(
          'REFRESH-INTERVAL;VALUE=DURATION:${utils.formatDuration(refreshInterval)}$CLRF_LINE_DELIMITER');
    }

    for (ICalendarElement element in _elements) {
      out.write(element.serialize());
    }

    out.write('END:VCALENDAR$CLRF_LINE_DELIMITER');
    return out.toString();
  }
}
