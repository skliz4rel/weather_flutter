// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/AdditionItem.dart' show AdditionItem;
import 'package:weather/HourlyForecaseItem.dart';
import 'package:http/http.dart' as http;
import 'package:weather/secret.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>>? weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';
      final res = await http.get(
        Uri.parse(
          'http://api.openweathermap.org/data/2.5/forecast?q=$cityName,uk&APPID=$openWeatherApiKey',
        ),
      );

      debugPrint(res.body);
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw data['message'];
      }

      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print("refresh");
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          print(snapshot);
          print(snapshot.runtimeType);

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final currentWeather = data['list'][0];

          final currentSky = currentWeather['weather'][0]['main'];
          final weathers = currentWeather['weather'];

          final currentTemperature = currentWeather['main']['temp'];
          final currentPressure = currentWeather['main']['pressure'];
          final currentWinSpeed = currentWeather['wind']['speed'];
          final currentHumidity = currentWeather['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Main card
                SizedBox(
                  //sized box are used when you want to do someting just width expansion only
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                (currentSky == 'Clouds' || currentSky == 'Rain')
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(width: 16),
                              Text("Rain", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Hourly Forecast',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),

                const SizedBox(height: 8),

                //This is going to load the list synchronoously. Load every thing at once.
                //This can cause performance draw back
                /*SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 5; i++)
                        HourlyForecaseItem(
                          time: data['list'][i + 1]['dt'].toString(),
                          icon:
                              data['list'][i + 1]['weather'][0]['main'] ==
                                          'Clouds' ||
                                      data['list'][i +
                                              1]['weather'][0]['main'] ==
                                          'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                          temperature:
                              data['list'][i + 1]['main']['temp'].toString(),
                        ),
                    ],
                  ),
                ),*/

                //This would load the list in a lazy way. Loads while the user is scrolling. For better performance.
                //This builder would load the list asynchronously as the user scrolls. Gives super performance
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final hourlysky =
                          data['list'][index + 1]['weather'][0]['main'];
                      final hourlyTemp =
                          hourlyForecast['main']['temp'].toString();

                      final datetime = DateTime.parse(
                        hourlyForecast['dt_txt'].toString(),
                      );

                      return HourlyForecaseItem(
                        time: DateFormat.j().format(datetime),
                        temperature: hourlyTemp,
                        icon:
                            hourlysky == 'Clouds' || hourlysky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                //weather forecast cards
                const Text(
                  'Additional Information',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionItem(
                      icon: Icons.water_drop,
                      label: "Humilidity",
                      value: currentHumidity.toString(),
                    ),
                    AdditionItem(
                      icon: Icons.air,
                      label: "Wind Speed",
                      value: currentWinSpeed.toString(),
                    ),
                    AdditionItem(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
