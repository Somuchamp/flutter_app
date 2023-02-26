import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/Data/search_models.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_application_1/Data/data_models.dart';
import 'package:http/http.dart' as http;

import '../Data/search_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.cityName});
  final String cityName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      debugPrint("Timer ends");
      _getData();
    });
  }

  late DataModel dataFromAPI;
  late SearchModel dataFromAPI2;

  _getData() async {
    String url =
        "https://geocoding-api.open-meteo.com/v1/search?name=${widget.cityName}";
    http.Response res = await http.get(Uri.parse(url));
    dataFromAPI2 = SearchModel.fromJson(json.decode(res.body));
    double latitude = dataFromAPI2.results![0].latitude!;
    double longitude = dataFromAPI2.results![0].longitude!;

    url =
        "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=temperature_2m";
    res = await http.get(Uri.parse(url));
    dataFromAPI = DataModel.fromJson(json.decode(res.body));

    debugPrint(dataFromAPI.hourlyUnits!.temperature2m);
    _isloading = false;
    setState(() {});
  }

  // final List _newlist = ["Ashmit", "Kanjari", "Piyush", "Gargi", "Aritra"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cityName),
      ),
      // body: Center(
      //   child: _isloading
      //       ? CircularProgressIndicator()
      //       : Image.network(
      //           "https://tech.pelmorex.com/wp-content/uploads/2020/10/flutter.png"),
      // ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DateTime temp =
                    DateTime.parse(dataFromAPI.hourly!.time![index]);

                return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(DateFormat('dd-mm-yyyy HH-mm a').format(temp)),
                        const Spacer(),
                        Text(
                          dataFromAPI.hourly!.temperature2m![index].toString(),
                        )
                      ],
                    ));
              },
              itemCount: dataFromAPI.hourly!.time!.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("Button is pressed");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
