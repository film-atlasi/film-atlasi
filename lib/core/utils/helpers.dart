import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  /// 🎬 Film Türlerini ID'den İsme Çeviren Fonksiyon
  static final Map<int, String> genreMap = {
    28: "Aksiyon",
    12: "Macera",
    16: "Animasyon",
    35: "Komedi",
    80: "Suç",
    99: "Belgesel",
    18: "Dram",
    10751: "Aile",
    14: "Fantastik",
    36: "Tarih",
    27: "Korku",
    10402: "Müzik",
    9648: "Gizem",
    10749: "Romantik",
    878: "Bilim Kurgu",
    10770: "TV Filmi",
    53: "Gerilim",
    10752: "Savaş",
    37: "Western",
  };

  static int colorToInt(Color color) {
    return int.parse('0xFF${color.value.toRadixString(16).substring(2)}');
  }

  static Color intToColor(int color) {
    return Color(color);
  }

  // 🔥 Timestamp'i "x dakika önce" formatına çeviren fonksiyon
  static String formatTimestamp(Timestamp timestamp) {
    DateTime postTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(postTime);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} saniye önce";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} dakika önce";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} saat önce";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} gün önce";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} hafta önce";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} ay önce";
    } else {
      return "${(difference.inDays / 365).floor()} yıl önce";
    }
  }

  /// 🔄 Film Türlerini Dönüştürme
  static String getGenres(List<int>? genreIds) {
    if (genreIds == null || genreIds.isEmpty) return 'Bilinmiyor';
    return genreIds.map((id) => genreMap[id] ?? 'Bilinmiyor').join(', ');
  }

  /// 📆 Yayınlanış Tarihini "Gün Ay Yıl" formatına çevirme
  static String reverseDate(String? releaseDate) {
    if (releaseDate == null || releaseDate.isEmpty) return 'Bilinmiyor';
    try {
      final parts = releaseDate.split('-');
      if (parts.length == 3) {
        final day = parts[2];
        final month = parts[1];
        final year = parts[0];

        // Ay numarasını Türkçe yazıya çevir
        const months = [
          'Ocak',
          'Şubat',
          'Mart',
          'Nisan',
          'Mayıs',
          'Haziran',
          'Temmuz',
          'Ağustos',
          'Eylül',
          'Ekim',
          'Kasım',
          'Aralık'
        ];
        final monthName = months[int.parse(month) - 1];

        return "$day $monthName $year";
      }
      return 'Bilinmiyor';
    } catch (e) {
      return 'Bilinmiyor';
    }
  }

  /// 📅 Tarihi biçimlendirme (örn: "12 Ocak 2025")
  static String formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return DateFormat('dd MMMM yyyy', 'tr')
        .format(date); // Türkçe tarih formatı
  }
}

/// 🔹 Dikey Boşluk Eklemek İçin Widget
Widget AddVerticalSpace(BuildContext context, double size) => SizedBox(
      height: MediaQuery.of(context).size.height * size,
    );

/// 🔹 Yatay Boşluk Eklemek İçin Widget
Widget AddHorizontalSpace(BuildContext context, double size) => SizedBox(
      width: MediaQuery.of(context).size.width * size,
    );
