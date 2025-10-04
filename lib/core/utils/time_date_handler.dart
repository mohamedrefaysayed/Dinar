import 'package:flutter/material.dart';

class MyTimeDate {
  // for getting formatted time from milliSecondsSinceEpochs String
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  // for getting formatted time for sent & read
  static String getMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }
    if (now.day == sent.day + 1 &&
        now.month == sent.month &&
        now.year == sent.year) {
      return 'yesterday on $formattedTime';
    }

    if (now.day - 6 < sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return '${_getWeek(sent.weekday)} on $formattedTime';
    }

    return now.year == sent.year
        ? '${sent.day} ${_getMonth(sent)} on $formattedTime'
        : '${sent.day} ${_getMonth(sent)} ${sent.year} on $formattedTime';
  }

  //get last message time (used in chat user card)
  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return showYear
        ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
        : '${sent.day} ${_getMonth(sent)}';
  }

  //get formatted last active time of user in chat screen
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    //if time is not available then return below statement
    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);

    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  // get month name from month no. or index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }

  static String _getWeek(int day) {
    switch (day) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
    }
    return 'Mon';
  }

  // Arabic datetime functions

  // Get Arabic formatted time from milliSecondsSinceEpochs String
  static String getFormattedTimeArabic({required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final hour = date.hour;
    final minute = date.minute;
    final period = hour >= 12 ? 'مساءً' : 'صباحاً';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  // Get Arabic formatted datetime for messages
  static String getMessageTimeArabic({required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    final formattedTime = getFormattedTimeArabic(time: time);

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }

    if (now.day == sent.day + 1 &&
        now.month == sent.month &&
        now.year == sent.year) {
      return 'أمس في $formattedTime';
    }

    if (now.day - 6 < sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return '${_getWeekArabic(sent.weekday)} في $formattedTime';
    }

    return now.year == sent.year
        ? '${sent.day} ${_getMonthArabic(sent)} في $formattedTime'
        : '${sent.day} ${_getMonthArabic(sent)} ${sent.year} في $formattedTime';
  }

  // Get Arabic last message time (used in chat user card)
  static String getLastMessageTimeArabic(
      {required String time, bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return getFormattedTimeArabic(time: time);
    }

    return showYear
        ? '${sent.day} ${_getMonthArabic(sent)} ${sent.year}'
        : '${sent.day} ${_getMonthArabic(sent)}';
  }

  // Get Arabic formatted last active time of user in chat screen
  static String getLastActiveTimeArabic({required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    if (i == -1) return 'آخر ظهور غير متاح';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = getFormattedTimeArabic(time: lastActive);

    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'آخر ظهور اليوم في $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'آخر ظهور أمس في $formattedTime';
    }

    String month = _getMonthArabic(time);
    return 'آخر ظهور في ${time.day} $month في $formattedTime';
  }

  // Get Arabic month name from DateTime
  static String _getMonthArabic(DateTime date) {
    switch (date.month) {
      case 1:
        return 'يناير';
      case 2:
        return 'فبراير';
      case 3:
        return 'مارس';
      case 4:
        return 'أبريل';
      case 5:
        return 'مايو';
      case 6:
        return 'يونيو';
      case 7:
        return 'يوليو';
      case 8:
        return 'أغسطس';
      case 9:
        return 'سبتمبر';
      case 10:
        return 'أكتوبر';
      case 11:
        return 'نوفمبر';
      case 12:
        return 'ديسمبر';
    }
    return 'غير متاح';
  }

  // Get Arabic day name from weekday number
  static String _getWeekArabic(int day) {
    switch (day) {
      case 1:
        return 'الاثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      case 7:
        return 'الأحد';
    }
    return 'الاثنين';
  }

  // Get current datetime in Arabic format
  static String getCurrentDateTimeArabic() {
    final now = DateTime.now();
    final weekday = _getWeekArabic(now.weekday);
    final month = _getMonthArabic(now);
    final time =
        getFormattedTimeArabic(time: now.millisecondsSinceEpoch.toString());

    return '$weekday، ${now.day} $month ${now.year} - $time';
  }

  // Get date only in Arabic format
  static String getDateOnlyArabic({required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final weekday = _getWeekArabic(date.weekday);
    final month = _getMonthArabic(date);

    return '$weekday، ${date.day} $month ${date.year}';
  }
}
