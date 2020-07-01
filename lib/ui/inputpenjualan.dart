import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import './home.dart';
import 'dart:async';

class InputPenjualan extends StatelessWidget {
  //membuat variabel untuk menampung list data penjualan
  //membuat variabel index dari list data
  final list;
  final index;
  //class constructor
  InputPenjualan({this.list, this.index});
  @override
  Widget build(BuildContext context) {
    //membuat material app
    return MaterialApp(
      //menampilkan judul transaksi baru jika index null
      title: index == null ? "Transaksi Baru" : "Update Transaksi",
      home: Scaffold(
        appBar: AppBar(
          title:
              index == null ? Text("Transaksi Baru") : Text("Update Transaksi"),
        ),
        //membuat body dalamsebuah class dengan parameter list dan index
        body: MyCustomForm(
          list: list,
          index: index,
        ),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  final list;
  final index;
  MyCustomForm({this.list, this.index});
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  //membuat variabel untuk menampung validasi
  final _formKey = GlobalKey<FormState>();
  //membaca inputan dari textfield
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController jumlahController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  TextEditingController jeniskucingController = TextEditingController();
  //format datepicker
  final format = DateFormat('yyyy-MM-dd');
  //class future untuk membuat fungsi adddata sekaligus update data
  Future<http.Response> adddata(index) async {
    //jika index yang diterima bernilai null
    //dianggap data baru
    if (index == null) {
      //mengirim data ke web services
      //karena menggunakan class future, maka wajib mengembalikan nilai
      final http.Response response = await http
          .post("http://192.168.43.65/apiflutter/api/Penjualankucing/save", body: {
        //isian data dikirim dalam body
        //key disesuaiakn dengan parameter $_POST dalam web services
        //value diambil dari text dalam controller
        'nama': namaController.text,
        'alamat': alamatController.text,
        'jumlah': jumlahController.text,
        'tanggal': tanggalController.text,
        'jeniskucing': jeniskucingController.text,
      });
      return response;
    } else {
      final http.Response response = await http.post(
          "http://192.168.43.65/apiflutter/api/Penjualankucing/save_update",
          body: {
            'id': widget.list['id'],
            'nama': namaController.text,
            'alamat': alamatController.text,
            'jumlah': jumlahController.text,
            'tanggal': tanggalController.text,
            'jeniskucing': jeniskucingController.text,
          });
      return response;
    }
  }

  @override
//untuk load pertama kali form dijalankan
  void initState() {
//jika index null makan controller diisi dengan nilai kosong
    if (widget.index == null) {
      namaController = TextEditingController();
      alamatController = TextEditingController();
      jumlahController = TextEditingController();
      tanggalController = TextEditingController();
      jeniskucingController = TextEditingController();
    } else {
//jika index tidak null
//maka controller diisi dengan nilai dari variabel list sesuai dengan index dan name variabel
      namaController = TextEditingController(text: widget.list['nama']);
      alamatController = TextEditingController(text: widget.list['alamat']);
      jumlahController = TextEditingController(text: widget.list['jumlah']);
      tanggalController = TextEditingController(text: widget.list['tanggal']);
      jeniskucingController = TextEditingController(text: widget.list['jeniskucing']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                //menggunakan validator, jika nilai kosong
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Mohon isi Nama Anda!!';
                  }
                  return null;
                },
                //menampilkan controller dalam textfield
                controller: namaController,
                decoration: InputDecoration(
                  hintText: "masukkan nama anda",
                  labelText: "Nama",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                )),
          ),
           Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: alamatController,
              //textfield type number
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "masukkan alamat",
                labelText: "Alamat",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Mohon isi alamat anda!!';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: jumlahController,
              //textfield type number
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "masukkan jumlah pesanan anda",
                labelText: "Jumlah",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Mohon isi dengan angka';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                DateTimeField(
                  controller: tanggalController,
                  format: format,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        //setting datepicker
                        context: context,
                        firstDate: DateTime(2020),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2045));
                  },
                  decoration: InputDecoration(
                    labelText: "Tanggal",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  validator: (DateTime dateTime) {
                    if (dateTime == null) {
                      return "Mohon diisi tanggal";
                    }
                    return null;
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: jeniskucingController,
              //textfield type number
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "masukkan jenis kucing yang anda",
                labelText: "jenis Kucing",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Mohon isi dengan jenis kucing yang anda sukai!';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  //tombol penyimpanan
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      "Simpan",
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //jika lolos validator maka data dikirim ke fungsi adddata
                        adddata(widget.index);
                        //keluar form, kembali ke halaman home
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new Home()));
                      }
                    },
                  ),
                ),
                Container(
                  width: 5.0,
                ),
                Expanded(
                  //untuk batal
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      "Batal",
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      //batal, kembali ke halaman home
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => new Home()));
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
