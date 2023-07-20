class Notlar {
  int? notId;
  int? kategoriId;
  String? kategoriBaslik;
  String? notBaslik;
  String? notIcerik;
  String? notTarih;
  int? notOncelik;

  Notlar(this.kategoriId, this.notBaslik, this.notIcerik, this.notOncelik,
      this.notTarih);
  Notlar.withID(this.notId, this.kategoriId, this.notBaslik, this.notIcerik,
      this.notTarih, this.notOncelik);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["notId"] = notId;
    map["kategoriId"] = kategoriId;
    map["notBaslik"] = notBaslik;
    map["notIcerik"] = notIcerik;
    map["notTarih"] = notTarih;
    map["notOncelik"] = notOncelik;
    return map;
  }

  Notlar.fromMap(Map<String, dynamic> map) {
    notId = map["notId"];
    kategoriId = map["kategoriId"];
    kategoriBaslik = map["kategoriBaslik"];
    notBaslik = map["notBaslik"];
    notIcerik = map["notIcerik"];
    notTarih = map["notTarih"];
    notOncelik = map["notOncelik"];
  }

  @override
  String toString() {
    return "notId : $notId , kategoriId : $kategoriId , notBaslik : $notBaslik , notIcerik : $notIcerik , notTarih : $notTarih , notOncelik : $notOncelik";
  }
}
