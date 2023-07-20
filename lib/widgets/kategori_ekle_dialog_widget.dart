import 'package:bolum28_notsepeti_app/const/sett.dart';
import 'package:bolum28_notsepeti_app/models/kategori.dart';
import 'package:bolum28_notsepeti_app/utils/data_helper.dart';
import 'package:flutter/material.dart';

class KategoriEkleDialog extends StatefulWidget {
  Kategori? kategoriGuncelleOge;
  KategoriEkleDialog({this.kategoriGuncelleOge, Key? key}) : super(key: key);

  @override
  _KategoriEkleDialogState createState() => _KategoriEkleDialogState();
}

class _KategoriEkleDialogState extends State<KategoriEkleDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DataHelper _dataObject = DataHelper();
  String? _title, _kategoriBaslik;

  @override
  void initState() {
    super.initState();
    if (widget.kategoriGuncelleOge == null) {
      _title = "Yeni Kategori";
    } else {
      _title = "Kategori Düzenle";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(8),
      children: [
        Form(
          key: _formKey,
          child: TextFormField(
            initialValue: widget.kategoriGuncelleOge != null
                ? widget.kategoriGuncelleOge!.kategoriBaslik
                : "",
            validator: (text) {
              if (text!.length < 3) {
                return "En az 3 karakter giriniz";
              }
            },
            onSaved: (text) {
              _kategoriBaslik = text!;
            },
            decoration: Setts.kategoriEkleDeco,
          ),
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
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (widget.kategoriGuncelleOge == null) {
                    _dataObject
                        .kategoriEkle(Kategori(_kategoriBaslik))
                        .then((value) {
                      if (value > 0) {
                        print("Kategori Eklendi : id # $value");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(
                              seconds: 2,
                            ),
                            content:
                                Text("$_kategoriBaslik kategorisi eklendi"),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    });
                  } else if (widget.kategoriGuncelleOge != null) {
                    _dataObject
                        .kategoriGuncelle(Kategori.withID(
                            widget.kategoriGuncelleOge!.kategoriId,
                            _kategoriBaslik))
                        .then((kategoriID) {
                      if (kategoriID != 0) {
                        print("$kategoriID id'li not güncellendi.");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Kategori güncellendi"),
                          duration: Duration(seconds: 2),
                        ));
                        Navigator.pop(context);
                      }
                    });
                  }
                }
              },
              child: Text("Kaydet"),
            ),
          ],
        )
      ],
      title: Column(
        children: [
          Text(
            _title!,
            textAlign: TextAlign.center,
            style: Setts.headTitle2,
          ),
          Divider(),
        ],
      ),
      shape: Setts.dialogShape,
    );
  }
}
