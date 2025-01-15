import 'period.dart';

class OpeningHours {
  bool? openNow;
  List<Period>? periods;
  List<dynamic>? weekdayText;

  OpeningHours({this.openNow, this.periods, this.weekdayText});

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
        openNow: json['open_now'] as bool?,
        periods: (json['periods'] as List<dynamic>?)
            ?.map((e) => Period.fromJson(e as Map<String, dynamic>))
            .toList(),
        weekdayText: json['weekday_text'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'open_now': openNow,
        'periods': periods?.map((e) => e.toJson()).toList(),
        'weekday_text': weekdayText,
      };
}
