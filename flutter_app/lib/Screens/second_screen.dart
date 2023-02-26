import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class SecondScreen extends StatelessWidget {
  SecondScreen({super.key});
  final TextEditingController _cityNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: Center(
          child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: "Enter the city name"),
            controller: _cityNameController,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(
                  () => HomeScreen(
                    cityName: _cityNameController.text,
                  ),
                );
              },
              child: const Text("Check the Weather")),
        ],
      )),
    );
  }
}
