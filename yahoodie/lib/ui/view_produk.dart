import 'dart:io';

import 'package:yahoodie/server/server.dart';
import 'package:yahoodie/ui/detail_produk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProdukView extends StatelessWidget {
  final String apiUrl = UrlServer + "produk/get";
  void showSnakbar(BuildContext context, Message, color) {
    final snackBar = SnackBar(content: Text(Message), backgroundColor: color);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    List<dynamic>? fecthDataProduk;
  }

  Future<List<dynamic>> getLists() async {
    var response = await http.get(Uri.parse(apiUrl));
    try {
      var decodedResponse = json.decode(response.body)['data'];
      print(decodedResponse);
      return decodedResponse;
    } on SocketException catch (_) {}
    return [];
  }

  void setDetail(BuildContext context, id, warna, deskripsi, merk, size) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('_id', id);
    await prefs.setString('warna', warna);
    await prefs.setString('deskripsi', deskripsi);
    await prefs.setString('merk', merk);
    await prefs.setString('size', size);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => detail_produk_view(
                id: id,
                warna: warna,
                deskripsi: deskripsi,
                merk: merk,
                size: size)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Anda'),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: getLists(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(5),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () => setDetail(
                        context,
                        snapshot.data[index]['_id'],
                        snapshot.data[index]['warna'],
                        snapshot.data[index]['deskripsi'],
                        snapshot.data[index]['merk'],
                        snapshot.data[index]['size'],
                      ),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.asset('assets/hoodie.png'),
                              // child: Image.network(
                              //     "http://localhost:5000/0.8538883697917976hagia.jpg" +
                              //         snapshot.data[index]['IMAGE']),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    10.0, 0.0, 2.0, 0.0),
                                child: ListTile(
                                  title: Text(
                                    snapshot.data[index]['merk'],
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  subtitle: Text("warna:" +
                                      snapshot.data[index]['warna'] +
                                      "" +
                                      "            " +
                                      "deskripsi:" +
                                      snapshot.data[index]['deskripsi'] +
                                      "" +
                                      "            " +
                                      "size:" +
                                      snapshot.data[index]['size']),

                                  // Text(),

                                  // author: author,
                                  // publishDate: publishDate,
                                  // readDuration: readDuration,
                                ),
                              ),
                            ),
                            // child:Card(),

                            // child:Text('Detail'),
                            // Expanded(child: Text)
                            // widget(child:)
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}