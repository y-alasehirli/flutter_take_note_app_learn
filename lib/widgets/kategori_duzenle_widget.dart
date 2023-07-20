import 'dart:io';

import 'package:bolum28_notsepeti_app/const/sett.dart';
import 'package:bolum28_notsepeti_app/models/kategori.dart';
import 'package:bolum28_notsepeti_app/utils/data_helper.dart';
import 'package:bolum28_notsepeti_app/widgets/kategori_ekle_dialog_widget.dart';
import 'package:flutter/material.dart';

class KategoriDuzenle extends StatefulWidget {
  KategoriDuzenle({Key? key}) : super(key: key);

  @override
  _KategoriDuzenleState createState() => _KategoriDuzenleState();
}

class _KategoriDuzenleState extends State<KategoriDuzenle> {
  List<Kategori>? _kategoriListe;
  DataHelper? _dataHelper;
  @override
  void initState() {
    super.initState();
    _dataHelper = DataHelper();
    _kategoriListe = [];
    _dataHelper!.kategoriListesiniOlustur().then((gelenListe) {
      setState(() {
        _kategoriListe = gelenListe;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text("Kategori Düzenle"),
      children: _kategoriListe!.map((kategoriItem) {
        return ListTile(
            title: Text(kategoriItem.kategoriBaslik!),
            trailing: kategoriItem.kategoriId == 1
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => KategoriEkleDialog(
                                    kategoriGuncelleOge: kategoriItem,
                                  )).then((value) {
                            Navigator.pop(context);
                            setState(() {});
                          });
                        },
                        icon: Icon(Icons.mode_edit),
                      ),
                      IconButton(
                        onPressed: () {
                          _silButtonMain(context, kategoriItem).then((value) {
                            Navigator.pop(context);
                            setState(() {});
                          });
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: Setts.emergeColor,
                        ),
                      ),
                    ],
                  ));
      }).toList(),
    );
  }

  Future<dynamic> _silButtonMain(BuildContext context, Kategori kategoriItem) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                ElevatedButton(
                    style: Setts.emergeButtonStyle,
                    onPressed: () =>
                        _kategoriSilButton(kategoriItem.kategoriId),
                    child: Text("Sil"))
              ],
              shape: Setts.dialogShape,
              content: Text(
                "Kategoriye ait tüm notlar silinecek!",
                textAlign: TextAlign.center,
              ),
            ));
  }

  _kategoriSilButton(int? kategoriId) {
    _dataHelper!.kategoriSil(kategoriId!).then((silinenID) {
      if (silinenID != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Setts.emergeColor,
            content: (Text("Kategori Silindi")),
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
        setState(() {});
      }
    });
  }
}
