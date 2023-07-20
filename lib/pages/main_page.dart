import 'package:bolum28_notsepeti_app/const/sett.dart';
import 'package:bolum28_notsepeti_app/widgets/kategori_duzenle_widget.dart';
import 'package:bolum28_notsepeti_app/widgets/kategori_ekle_dialog_widget.dart';
import 'package:bolum28_notsepeti_app/widgets/not_ekle_dialog_widget.dart';
import 'package:bolum28_notsepeti_app/widgets/not_liste_goster.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 25),
            KategoriDuzenle(),
          ],
        ),
      ),
      appBar: AppBar(
       // iconTheme: IconThemeData(color: Setts.secondColor),
        title: Text(
          'Not Tutuyorum - v 0.1.1',
          style: Setts.headTitle1,
        ),
      ),
      body: NotListeWidget(),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            tooltip: "Kategori Ekle",
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => KategoriEkleDialog());
            },
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            backgroundColor: Setts.primaryColor,
            tooltip: "Not Ekle",
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => NotEkleDialog(
                        notDialogBaslik: "Yeni Not",
                      )).then((value) {
                setState(() {});
              });
            },
            child: Icon(Icons.add_task),
          ),
        ],
      ),
    );
  }
}
