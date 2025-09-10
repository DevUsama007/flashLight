
import 'package:flashlight/colorScreen.dart';
import 'package:flashlight/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_light/torch_light.dart';
import 'package:sound_library/sound_library.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    // Change this to your desired color
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isFlashlightOn = false;

  void toggleFlashlight() {
    setState(() {
      isFlashlightOn = !isFlashlightOn;
    });
  }

  Future<void> _enableTorch(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      SoundPlayer.isAudioEnabled;
      SoundPlayer.playFromAssetPath(volume: 10, "flashLightSound.mp3");
      setState(() {
        isFlashlightOn = true;
      });

      await TorchLight.enableTorch();
    } on Exception catch (_) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Could not enable torch'),
        ),
      );
    }
  }

  Future<void> _disableTorch(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      SoundPlayer.isAudioEnabled;
      SoundPlayer.playFromAssetPath(volume: 10, "flashLightSound.mp3");

      setState(() {
        isFlashlightOn = false;
      });

      await TorchLight.disableTorch();
    } on Exception catch (_) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Could not disable torch'),
        ),
      );
    }
  }

  start() async {
    setState(() {
      isFlashlightOn = true;
    });

    await TorchLight.enableTorch();
  }

  DateTime? _lastClicked;
  String? id;
  @override
  void initState() {
    // TODO: implement initState
    start();
    super.initState();
  }

  @override
  Future<void> dispose() async {
    // TODO: implement dispose

    await TorchLight.disableTorch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colr1 = Colors.orange.withOpacity(0.2);
    var colr2 = Colors.orange.withOpacity(0.5);
    var colr3 = Colors.orange;
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          bool allowPop = false;
          if (_lastClicked == null ||
              now.difference(_lastClicked!) > Duration(seconds: 1)) {
            _lastClicked = now;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Double tap back button to exit',
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                duration: Duration(seconds: 2),
                showCloseIcon: true,
                backgroundColor: isFlashlightOn ? Colors.orange : Colors.grey,
              ),
            );
          } else {
            allowPop = true;
          }
          return Future<bool>.value(allowPop);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: isFlashlightOn
                  ? [
                      Colors.orange.withOpacity(0.8),
                      Colors.orange.withOpacity(0.2),
                    ]
                  : [
                      Colors.grey.withOpacity(0.8),
                      Colors.grey.withOpacity(0.2),
                    ],
              center: Alignment.center,
              radius: 0.8,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wb_sunny,
                    color: isFlashlightOn ? Colors.orange : Colors.grey,
                    size: 48),
                SizedBox(height: 16),
                Text(
                  isFlashlightOn ? 'FLASHLIGHT: ON' : 'FLASHLIGHT: OFF',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),
                Stack(
                  children: [
                    Positioned(
                        child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                          color: isFlashlightOn
                              ? Colors.orange.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(120)),
                    )),
                    Positioned(
                        left: 15,
                        top: 17,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              color: isFlashlightOn
                                  ? Colors.orange.withOpacity(0.5)
                                  : Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(100)),
                        )),
                    Positioned(
                        left: 30,
                        top: 33,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(200),
                          onTap: () {
                            toggleFlashlight();
                            isFlashlightOn
                                ? _enableTorch(context)
                                : _disableTorch(context);
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: isFlashlightOn
                                    ? Colors.orange
                                    : Colors.grey.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.power_settings_new,
                              color: isFlashlightOn
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6),
                              size: 64,
                            ),
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 52,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Colorscreen(),
                        ));
                  },
                  child: Container(
                      width: 160,
                      height: 40,
                      decoration: BoxDecoration(
                          color: isFlashlightOn
                              ? Colors.orange.withOpacity(0.5)
                              : Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Icon(
                        Icons.color_lens,
                        size: 35,
                        color: Colors.white,
                      ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
