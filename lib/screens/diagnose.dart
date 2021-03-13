import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_prescription/blocs/patient.dart';
import 'package:voice_prescription/modals/disease.dart';

class DiagnoseScreen extends StatefulWidget {
  final DiseaseModal disease;
  DiagnoseScreen({this.disease, Key key}) : super(key: key);
  @override
  _DiagnoseScreenState createState() => _DiagnoseScreenState();
}

class _DiagnoseScreenState extends State<DiagnoseScreen> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  int resultListened = 0;
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    super.initState();
    if (!_hasSpeech) {
      initSpeechState();
    }
  }

  Future<void> initSpeechState() async {
    var hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener, debugLogging: true);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    var enabled = true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Prescription'),
      ),
      body: Container(
        child: Column(children: [
          // Center(
          //   child: Text(
          //     'Speech recognition available',
          //     style: TextStyle(fontSize: 22.0),
          //   ),
          // ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // TextButton(
                    //   child: Text('Start'),
                    //   onPressed: null
                    // ),
                    TextButton(
                      child: Text('Stop'),
                      onPressed: speech.isListening ? stopListening : null,
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: speech.isListening ? cancelListening : null,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    DropdownButton(
                      onChanged: (selectedVal) => _switchLang(selectedVal),
                      value: _currentLocaleId,
                      items: _localeNames
                          .map(
                            (localeName) => DropdownMenuItem(
                              value: localeName.localeId,
                              child: Text(localeName.name),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                // Text(
                //   'Prescription made',
                //   style: TextStyle(fontSize: 22.0),
                // ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).selectedRowColor,
                        child: Center(
                          child: Text(
                            lastWords,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 80,
                            height: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: .26,
                                    spreadRadius: level * 1.5,
                                    color: Colors.black.withOpacity(.05))
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80)),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.mic),
                              iconSize: 40.0,
                              onPressed: !_hasSpeech || speech.isListening
                                  ? null
                                  : startListening,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                // Center(
                //   child: Text(
                //     'Error Status',
                //     style: TextStyle(fontSize: 22.0),
                //   ),
                // ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          textStyle: TextStyle(
                            color: Colors.white,
                          )),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: enabled
                                      ? () async {
                                          setState(() {
                                            enabled = false;
                                          });
                                          widget.disease.prescription =
                                              lastWords;
                                          await Provider.of<PatientBase>(
                                                  context,
                                                  listen: false)
                                              .makePrescription(widget.disease);
                                          print("Prescription Made");
                                          setState(() {
                                            enabled = true;
                                          });
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      : null,
                                  child: Text("OK"))
                            ],
                            content: Form(
                              child: TextFormField(
                                initialValue: lastWords,
                                maxLines: 10,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter prescription';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  lastWords = value;
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text("Make Prescription"),
                    ),
                  ),
                ),
                Center(
                  child: Text(lastError),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Theme.of(context).backgroundColor,
            child: Center(
              child: speech.isListening
                  ? Text(
                      "I'm listening...",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(
                      'Not listening',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ]),
      ),
    );
  }

  void startListening() {
    lastWords = '';
    lastError = '';
    speech.listen(
        onResult: resultListener,
        listenFor: Duration(minutes: 3),
        pauseFor: Duration(minutes: 3),
        partialResults: false,
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    ++resultListened;
    print('Result listener $resultListened');
    setState(() {
      // lastWords = '${result.recognizedWords} - ${result.finalResult}';
      lastWords = result.recognizedWords;
      lastWords = lastWords.replaceAll(" and ", " \n\n");
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    // print(
    // 'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = '$status';
    });
  }

  void _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }
}
