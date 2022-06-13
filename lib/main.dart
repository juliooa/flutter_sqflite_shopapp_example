import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomeScreen(),
    );
  }
}

const String _prefCounter = 'counter';
const String _prefNotificationsEnabled = 'notifications_enabled';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Preferences Example"),
      ),
      body: Center(
        child:
            _selectedIndex == 0 ? const CounterScreen() : const ConfigScreen(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
      ),
    );
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  _incrementCounter() async {
    setState(() {
      _counter++;
    });
    SharedPreferences.getInstance()
        .then((value) => value.setInt(_prefCounter, _counter));
  }

  Future<int> getCounterValue() async {
    return SharedPreferences.getInstance()
        .then((prefs) => prefs.getInt(_prefCounter) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCounterValue(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        _counter = snapshot.data!;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () {
                _incrementCounter();
              },
              child: const Text("Aumentar"),
            ),
          ],
        );
      },
    );
  }
}

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

Future<bool> getNotificationsSetting() async {
  return SharedPreferences.getInstance()
      .then((prefs) => prefs.getBool(_prefNotificationsEnabled) ?? false);
}

class _ConfigScreenState extends State<ConfigScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getNotificationsSetting(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          _isChecked = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Activar notificaciones",
                      style: TextStyle(fontSize: 18),
                    ),
                    Checkbox(
                      checkColor: Colors.white,
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                        saveNotificationsSetting(_isChecked);
                      },
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                    "La app te notificará de nuevos mensajes de tus amigos."),
              )
            ],
          );
        });
  }

  void saveNotificationsSetting(bool isChecked) async {
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool(_prefNotificationsEnabled, isChecked));
  }
}
