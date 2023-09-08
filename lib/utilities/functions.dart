import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_time/utilities/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

bool isDarkMode(BuildContext context) {
  return AdaptiveTheme.of(context).brightness == Brightness.dark;
}

Color getContainerColor(BuildContext context) {
  return isDarkMode(context) ? bgColorDark3 : Colors.grey.shade300;
}

String voteCountFormatter(int voteCount) {
  if (voteCount >= 1000000) {
    double voteCountInM = voteCount / 1000000;
    return '${voteCountInM.toStringAsFixed(1)}M';
  } else if (voteCount >= 1000) {
    double voteCountInK = voteCount / 1000;
    return '${voteCountInK.toStringAsFixed(1)}K';
  } else {
    return voteCount.toString();
  }
}

String totalSeasonsFormattter(int seasonsCount) {
  return seasonsCount == 1 ? '1 Season' : '$seasonsCount Seasons';
}

String totalEpisodesFormatter(int episodesCount) {
  return episodesCount == 1 ? '1 Episode' : '$episodesCount Episodes';
}

String seasonEpisodeFormatter(int seasonNumber, int episodeNumber) {
  return 'S$seasonNumber E$episodeNumber';
}

String runtimeFormatter(int minutes) {
  if (minutes < 60) {
    return '${minutes}min';
  } else {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;

    if (remainingMinutes == 0) {
      return '${hours}h';
    } else {
      return '${hours}h ${remainingMinutes}min';
    }
  }
}

dateFormatter(DateTime dateTime) {
  return DateFormat('MMM dd yyyy').format(dateTime);
}

dateTimeFormatter(DateTime dateTime) {
  return DateFormat('MMM dd yyyy HH:mm:ss').format(dateTime);
}

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}
