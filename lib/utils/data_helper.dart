import 'dart:io';
import 'package:bolum28_notsepeti_app/models/kategori.dart';
import 'package:bolum28_notsepeti_app/models/not.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataHelper {
  static DataHelper? _dataObj;
  static Database? _database;
  static String _dbName = "notsepeti.db";
  static String _kategoriTable = "kategori";
  static String _notTable = "notlar";

  factory DataHelper() {
    if (_dataObj == null) {
      _dataObj = DataHelper._internal();
      return _dataObj!;
    } else {
      return _dataObj!;
    }
  }
  DataHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDB();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future<Database> _initializeDB() async {
    Directory applicationDirectory = await getApplicationDocumentsDirectory();

    String dbPath = path.join(applicationDirectory.path, _dbName);
    print(dbPath);
    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      // Copy from asset
      ByteData data = await rootBundle.load(path.join("assets", _dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(dbPath);
  }

  Future<List<Map<String, dynamic>>> kategorileriCagir() async {
    var db = await _getDatabase();
    List<Map<String, dynamic>> resultList = await db.query(_kategoriTable);
    return resultList;
  }

  Future<List<Kategori>> kategoriListesiniOlustur() async {
    /* widget içerisinde "initState()" kısmında oluşturduğumuz listeyi direk olarak "FutureBuilder" içerisinde yada başka yerlerde oluşturarak çağırabileceğimiz metodu yazdık. */
    List<Map<String, dynamic>> dbMap = await kategorileriCagir();
    List<Kategori> olusanListe = [];
    for (Map<String, dynamic> mapOge in dbMap) {
      olusanListe.add(Kategori.fromMap(mapOge));
    }
    return olusanListe;
  }

  Future<int> kategoriEkle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.insert(_kategoriTable, kategori.toMap());
    return sonuc;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.update(_kategoriTable, kategori.toMap(),
        where: "kategoriId = ?", whereArgs: [kategori.kategoriId]);
    return sonuc;
  }

  Future<int> kategoriSil(int kategoriId) async {
    var db = await _getDatabase();
    var sonuc = await db.delete(_kategoriTable,
        where: "kategoriId = ?", whereArgs: [kategoriId]);
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> notlariCagir() async {
    var db = await _getDatabase();
    List<Map<String, dynamic>> resultList = await db.rawQuery(
      "SELECT * FROM  $_notTable INNER JOIN kategori on $_kategoriTable.kategoriId = $_notTable.kategoriId order by notTarih DESC;",
    ); /* ."rawQuery()" ile ".query" ile aynı şeyi yapıyoruz ama ".query" flutter hazır kodu olduğu için farklı tablolar içerisindeki benzer değişkenlerin kontrolünü yapıp bize ona göre bir tablo döndüremiyor. Bu yüzden ".rawQuery()" ile ham "SQL" komutları girdik ve istediğimiz "SQL" tablolarını ilişkilendirip ortak bir yeni tablo oluşturduğumuz bu tabloya ekledik "SQL / INNER JOIN" komutu ile. */
    return resultList;
  }

  Future<List<Notlar>> notListesiniOlustur() async {
    /* widget içerisinde "initState()" kısmında oluşturduğumuz listeyi direk olarak "FutureBuilder" içerisinde yada başka yerlerde oluşturarak çağırabileceğimiz metodu yazdık. */
    List<Map<String, dynamic>> dbMap = await notlariCagir();
    List<Notlar> olusanListe = [];
    for (Map<String, dynamic> mapOge in dbMap) {
      olusanListe.add(Notlar.fromMap(mapOge));
    }
    return olusanListe;
  }

  Future<int> notEkle(Notlar not) async {
    var db = await _getDatabase();
    var sonuc = await db.insert(_notTable, not.toMap());
    return sonuc;
  }

  Future<int> notGuncelle(Notlar not) async {
    var db = await _getDatabase();
    var sonuc = await db.update(_notTable, not.toMap(),
        where: "notId = ?", whereArgs: [not.notId]);
    print("not guncelle çalıştı");
    return sonuc;
  }

  Future<int> notSil(int notId) async {
    var db = await _getDatabase();
    var sonuc =
        await db.delete(_notTable, where: "notId = ?", whereArgs: [notId]);

    return sonuc;
  }

  String gecenZaman(DateTime createdTime, {bool numericDates = true}) {
    DateTime date = createdTime.toLocal();
    final date2 = DateTime.now().toLocal();
    final difference = date2.difference(date);

    if (difference.inSeconds < 5) {
      return 'Az önce';
    } else if (difference.inSeconds <= 60) {
      return '${difference.inSeconds} saniye önce';
    } else if (difference.inMinutes <= 1) {
      return (numericDates) ? '1 dakika önce' : '1 dakika önce';
    } else if (difference.inMinutes <= 60) {
      return '${difference.inMinutes} dakika önce';
    } else if (difference.inHours <= 1) {
      return (numericDates) ? '1 saat önce' : '1 saat önce';
    } else if (difference.inHours <= 60) {
      return '${difference.inHours} saat önce';
    } else if (difference.inDays <= 1) {
      return (numericDates) ? '1 gün önce' : 'Dün';
    } else if (difference.inDays <= 6) {
      return '${difference.inDays} gün önce';
    } else if ((difference.inDays / 7).ceil() <= 1) {
      return (numericDates) ? '1 hafta önce' : 'Geçen hafta';
    } else if ((difference.inDays / 7).ceil() <= 4) {
      return '${(difference.inDays / 7).ceil()} hafta önce';
    } else if ((difference.inDays / 30).ceil() <= 1) {
      return (numericDates) ? '1 ay önce' : 'Geçen ay';
    } else if ((difference.inDays / 30).ceil() <= 30) {
      return '${(difference.inDays / 30).ceil()} ay önce';
    } else if ((difference.inDays / 365).ceil() <= 1) {
      return (numericDates) ? '1 yıl önce' : 'Geçen yıl';
    }
    return '${(difference.inDays / 365).floor()} yıl önce';
  }
}
