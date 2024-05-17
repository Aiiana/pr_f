import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:f_pr/bloc/bloc/counter_bloc.dart';
import 'package:f_pr/bloc/bloc/counter_event.dart';
import 'package:f_pr/bloc/bloc/counter_state.dart';
import 'package:f_pr/models/weather_model.dart';
import 'package:f_pr/theme_prov.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Builder(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => CounterBloc()),
            ],
            child: const MaterialApp(
              home: MyHomePage(title: 'Weather counter'),
            ),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WeatherModel? _weather;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<ThemeProvider>().theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.watch<ThemeProvider>().theme.appBarTheme.backgroundColor,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const Text("Поменять цвет:",
          style: TextStyle(

            fontSize: 20
          ),
          ),
          IconButton( onPressed: () {
              context.read<ThemeProvider>().changeTheme();
            },
            icon: context.watch<ThemeProvider>().isDarkTheme
                ? const Icon(Icons.wb_cloudy)
                : const Icon(Icons.wb_sunny),),
                const SizedBox(height: 20),
                 const Text("Погода:",
                 style: TextStyle(

            fontSize: 20
          ),),
          IconButton(
            onPressed: () {
             
              fetchWeatherData();
            },
            icon: const Icon(Icons.cloud_download), 
          ),
          _isLoading
              ? const CircularProgressIndicator()
              : (_weather != null
                  ? Column(
                      children: [
                        Text(
                          'Погода в ${_weather!.name}: ${_weather!.weather![0].description}',
                        ),
                        Text(
                          'Температура: ${_weather!.main!.temp}°C',
                        ),
                        Text(
                          'Влажность: ${_weather!.main!.humidity}%',
                        ),
                      ],
                    )
                  : Container()), 
          BlocBuilder<CounterBloc, CounterState>(
            builder: (context, state) {
              return Text(
                'счет: ${state.count}',
                style: Theme.of(context).textTheme.headline4,
              );
            },
          ),
          const SizedBox(height: 20,),
           
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  context.read<CounterBloc>().add(CounterDecrement());
                },
                icon: const Icon(Icons.remove),
              ),
              IconButton(
                onPressed: () {
                  context.read<CounterBloc>().add(CounterIncrement());
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> fetchWeatherData() async {
    setState(() {
      _isLoading = true;
    });
    const lat = 42.882004;
    const lon = 74.582748;
    const apiKey = '4caa7e51924b24c01b28bbaf27f7d995';
    const url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final weatherModel = WeatherModel.fromJson(json);
        setState(() {
          _weather = weatherModel;
          _isLoading = false;
        });
      } else {
        throw Exception('Не удалось загрузить данные о погоде.');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
}
