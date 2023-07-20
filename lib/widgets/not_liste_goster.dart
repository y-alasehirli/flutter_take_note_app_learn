import 'package:bolum28_notsepeti_app/const/sett.dart';
import 'package:bolum28_notsepeti_app/models/not.dart';
import 'package:bolum28_notsepeti_app/utils/data_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'not_ekle_dialog_widget.dart';

class NotListeWidget extends StatefulWidget {
  NotListeWidget({Key? key}) : super(key: key);

  @override
  _NotListeWidgetState createState() => _NotListeWidgetState();
}

class _NotListeWidgetState extends State<NotListeWidget> {
  List<Notlar>? notListe;
  DataHelper? _dataHelper;

  @override
  void initState() {
    super.initState();
    notListe = [];
    _dataHelper = DataHelper();
    /*   _dataHelper!.notlariCagir().then((dbMapListesi) {
      for (Map<String, dynamic> mapItem in dbMapListesi) {
        setState(() {
          notListe?.add(Notlar.fromMap(mapItem));
        });
      }
    }); */
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _dataHelper!.notListesiniOlustur(),
        builder: (BuildContext context, AsyncSnapshot<List<Notlar>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            notListe = snapshot.data;
            return ListView.builder(
                itemCount: notListe!.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        side: BorderSide(
                            color: _renkBelirle(notListe![index]), width: 2)),
                    child: ListTile(
                      onLongPress: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => NotEkleDialog(
                                  notDialogBaslik: "Notu Düzenle",
                                  notGuncelleOge: notListe![index],
                                )).then((value) {
                          setState(() {});
                        });
                      },
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${notListe![index].notBaslik}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: ElevatedButton(
                                            style: Setts.emergeButtonStyle,
                                            onPressed: () => _notSilButton(
                                                notListe![index].notId),
                                            child: Text("Sil")),
                                      ));
                            },
                            child: Icon(Icons.highlight_off),
                          )
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(notListe![index].notIcerik as String),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${notListe![index].kategoriBaslik}  -  ",
                                style: Setts.subTitle1.copyWith(fontSize: 14),
                              ),
                              Text(
                                _dataHelper!.gecenZaman(DateTime.parse(
                                    /* "<String>" gelen değeri "<DateTime>" veri tipine çeviripte oluşturduğumuz metoda yolluyoruz. */
                                    "${notListe![index].notTarih}")),
                                style: Setts.headTitle2.copyWith(fontSize: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Setts.ignoreColor,
                  size: 35,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Hazırlanıyor',
                  style: Setts.ignoreTextS,
                ),
              ],
            ));
          }
        });
  }

// FutureBuilder kullanmadan Liste ile çalışmak. Aslında en performanslı bu aslında. FutureBuilder her gidip gelmeden yeniden oluşturulduğu için buyuk DB lerde tekrar tekrar yüklemek uzun sürüyor ve yeniden yükleme widgetı dönüyor.
  Widget kabaDuzenOlusturma() {
    return notListe?.length == null
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                color: Setts.ignoreColor,
                size: 35,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Kaydedilen bir not bulunmuyor',
                style: Setts.ignoreTextS,
              ),
            ],
          ))
        : ListView.builder(
            itemCount: notListe!.length,
            itemBuilder: (context, index) {
              return Card(
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    side: BorderSide(
                        color: _renkBelirle(notListe![index]), width: 2)),
                child: ListTile(
                  title: Text("${notListe![index].notBaslik}"),
                  subtitle: Text(notListe![index].notIcerik as String),
                ),
              );
            });
  }

  _renkBelirle(Notlar notlar) {
    if (notlar.notOncelik == 1) {
      return Colors.blue;
    } else if (notlar.notOncelik == 2) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  void _notSilButton(int? notId) {
    _dataHelper?.notSil(notId!).then((silinenID) {
      if (silinenID != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Setts.emergeColor,
            content: (Text("Not Silindi")),
          ),
        );
        setState(() {
          Navigator.pop(context);
        });
      }
    });
  }
}
