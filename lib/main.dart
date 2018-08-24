import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async {
  Map _data = await getJson();
  List _features =_data['features'];


  runApp(MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('JSON Quaker'),
            centerTitle: true,
            backgroundColor: Colors.pinkAccent,
          ),
          body: Center(
              child:  ListView.builder(
                  itemCount: _features.length,
                  padding: const EdgeInsets.all(14.5),
                  itemBuilder: (BuildContext context, int position) {
                    var format = new DateFormat.yMMMMd("en_US").add_jm();
                    var date = format.format(
                        new DateTime.fromMicrosecondsSinceEpoch(
                            _features[position]['properties']['time'] * 1000,
                            isUtc: true));

                    if (position.isOdd) return Divider();

                    return Column(
                        children: <Widget>[
                          Divider(height: 5.5),

                          ListTile(
                            title: Text(
                              "$date",
                              style: TextStyle(fontSize: 18.5),),

                            subtitle: Text(
                                "${_features[position]['properties']['place']}",
                                style: TextStyle(
                                    fontSize: 18.9,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic)),

                            leading: CircleAvatar(
                              backgroundColor: Colors.purple,

                              child: Text("${_features[position]['properties']['mag']}",
                                  style: TextStyle(fontSize: 16.4,
                                      color: Colors.white)
                              ),
                            ),
                            onTap:(){_showonTapMessage(context, _features[position]['properties']['title']);},
                          ),
                        ]
                    );
                  }
              )
          )
      )
  )
  );
}

void _showonTapMessage(BuildContext context, String message) {
  var alert = AlertDialog(
    title: Text ("Earthquake:"),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );
  showDialog(context: context, builder: (context) => alert);
}


Future<Map> getJson() async {
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}
