class Kategori {
  int? kategoriId;
  String? kategoriBaslik;

  Kategori(this.kategoriBaslik);
  Kategori.withID(this.kategoriId, this.kategoriBaslik);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["kategoriId"] = kategoriId;
    map["kategoriBaslik"] = kategoriBaslik;
    return map;
  }

  Kategori.fromMap(Map<String, dynamic> map) {
    this.kategoriId = map["kategoriId"];
    this.kategoriBaslik = map["kategoriBaslik"];
  }
  @override
  String toString() {
    return "kategoriId : $kategoriId , kategoriBaslik : $kategoriBaslik";
  }
}
