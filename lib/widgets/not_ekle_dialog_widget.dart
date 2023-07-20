import 'package:bolum28_notsepeti_app/const/sett.dart';
import 'package:bolum28_notsepeti_app/models/kategori.dart';
import 'package:bolum28_notsepeti_app/models/not.dart';
import 'package:bolum28_notsepeti_app/utils/data_helper.dart';
import 'package:flutter/material.dart';

class NotEkleDialog extends StatefulWidget {
  final String notDialogBaslik;
  Notlar? notGuncelleOge;
  NotEkleDialog({required this.notDialogBaslik, this.notGuncelleOge, Key? key})
      : super(key: key);

  @override
  _NotEkleDialogState createState() => _NotEkleDialogState();
}

class _NotEkleDialogState extends State<NotEkleDialog> {
  List<Kategori>? kategoriListe;
  DataHelper? _dataHelper;
  int? _initKategoriId;
  int? _initOncelikId;
  List<String> oncelikListe = ["Düşük", "Normal", "Yüksek"];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _notBaslik, _notIcerik;
  @override
  void initState() {
    super.initState();
    // güncelleme butonu için gelen "<Notlar>" veritipindeki nesnenin durumuna göre kullanacağımız "<DropdownMenu>" "value:" lerinin atamasını yapıyoruz.
    if (widget.notGuncelleOge != null) {
      _initKategoriId = widget.notGuncelleOge!.kategoriId;
      _initOncelikId = widget.notGuncelleOge!.notOncelik;
    } else {
      _initKategoriId = 1;
      _initOncelikId = 2;
    }
    kategoriListe = [];
    _dataHelper = DataHelper();
    _dataHelper!.kategorileriCagir().then((dbMapListesi) {
      for (Map<String, dynamic> mapItem in dbMapListesi) {
        if (widget.notGuncelleOge != null) {
          _initKategoriId = widget.notGuncelleOge!.kategoriId;
          _initOncelikId = widget.notGuncelleOge!.notOncelik;
        } else {
          _initKategoriId = 1;
          _initOncelikId = 2;
        }
        setState(() {
          kategoriListe?.add(Kategori.fromMap(mapItem));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SimpleDialog(
        contentPadding: EdgeInsets.all(8),
        title: Column(
          children: [
            Text(
              widget.notDialogBaslik,
              textAlign: TextAlign.center,
              style: Setts.headTitle2,
            ),
            Divider(),
          ],
        ),
        shape: Setts.dialogShape,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Kategori",
                style: Setts.subTitle1,
              ),
              DropdownButton(
                underline: Container(
                  height: 1,
                  color: Setts.secondColor,
                ),
                items: kategoriMenu(),
                value: _initKategoriId,
                onChanged: (secilenItem) {
                  setState(() {
                    _initKategoriId = secilenItem as int;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Öncelik",
                style: Setts.subTitle1,
              ),
              DropdownButton(
                underline: Container(
                  height: 1,
                  color: Setts.secondColor,
                ),
                items: oncelikMenu(),
                value: _initOncelikId,
                onChanged: (secilenItem) {
                  setState(() {
                    _initOncelikId = secilenItem as int;
                  });
                },
              ),
            ],
          ),
          TextFormField(
            initialValue: widget.notGuncelleOge != null
                ? widget.notGuncelleOge!.notBaslik
                : "",
            onSaved: (inputText) {
              _notBaslik = inputText;
            },
            validator: (inputText) {
              if (inputText!.length < 3) {
                return "En az 3 karakter giriniz";
              }
            },
            decoration: Setts.kategoriEkleDeco.copyWith(
                labelText: "Başlık",
                labelStyle: Setts.subTitle1.copyWith(
                  color: Setts.primaryColor,
                )),
          ),
          SizedBox(
            height: 5,
          ),
          TextFormField(
            initialValue: widget.notGuncelleOge != null
                ? widget.notGuncelleOge!.notIcerik
                : "",
            onSaved: (inputText) {
              _notIcerik = inputText;
            },
            maxLines: 2,
            /*  validator: (inputText) {
              if (inputText!.length < 3) {
                return "En az 3 karakter giriniz";
              }
            }, */
            decoration: Setts.kategoriEkleDeco.copyWith(
                labelText: "İçerik",
                labelStyle: Setts.subTitle1.copyWith(
                  color: Setts.primaryColor,
                )),
          ),
          ButtonBar(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Vazgeç",
                    style: TextStyle(
                      color: Setts.secondColor,
                    ),
                  )),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      DateTime currentTime = DateTime.now();

                      if (widget.notGuncelleOge == null) {
                        _dataHelper!
                            .notEkle(Notlar(
                                _initKategoriId,
                                _notBaslik,
                                _notIcerik,
                                _initOncelikId,
                                currentTime.toString()))
                            .then((notID) {
                          if (notID != 0) {
                            print(_dataHelper!.gecenZaman(currentTime));
                            print("$notID id'li not kaydedildi.");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Not Kaydedildi"),
                              duration: Duration(seconds: 2),
                            ));
                            Navigator.pop(context);
                          }
                        });
                      } else if (widget.notGuncelleOge != null) {
                        _dataHelper!
                            .notGuncelle(Notlar.withID(
                                widget.notGuncelleOge!.notId,
                                _initKategoriId,
                                _notBaslik,
                                _notIcerik,
                                currentTime.toString(),
                                _initOncelikId))
                            .then((notID) {
                          if (notID != 0) {
                            print("$notID id'li not güncellendi.");
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Not güncellendi"),
                              duration: Duration(seconds: 2),
                            ));
                            Navigator.pop(context);
                          }
                        });
                      }
                    }
                  },
                  child: Text("Kaydet"))
            ],
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> kategoriMenu() {
    return kategoriListe!
        .map((kategoriItem) => DropdownMenuItem<int>(
              value: kategoriItem.kategoriId,
              child: Text(kategoriItem.kategoriBaslik!),
            ))
        .toList();
  }

  List<DropdownMenuItem<int>> oncelikMenu() {
    return oncelikListe
        .map((oncelikItem) => DropdownMenuItem<int>(
              value: (oncelikListe.indexOf(oncelikItem)) + 1,
              child: Text(oncelikItem),
            ))
        .toList();
  }
}
