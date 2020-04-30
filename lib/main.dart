


// turn on bluetooth and location
// allow app location in settings
// change android/app/build.gradle
//        minSdkVersion 19
//
// add to pubspec.yaml
//       flutter_ble_lib:
//
// troubleshooting: turn on/off bluetooth on phone/tablet
// use nordic nrfconnect to find out
//     1) device name
//     2) service
//     3) characteristic

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
void main() {runApp(MyApp());}

class MyApp extends StatelessWidget {
  final BleManager ble = BleManager();
  Peripheral peri;
  final List writeValue = [0x41,0x42,0x43,0x30,0x31,0x32]; // ABC123

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter_ble_lib_eg', home: Home());}}

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeState createState() => _HomeState();}

class _HomeState extends State {

  BleManager ble;
  Peripheral peri;
  List writeValue = [0x66]; // f

  connectToBle() {
    ble.startPeripheralScan(
    ).listen((scanResult) async {
      if (scanResult.peripheral.name == "Loom Assist") { // device name
        peri = scanResult.peripheral;
        ble.stopPeripheralScan();
        debugPrintStack(label: 'b4connect',maxFrames: 2);
        bool c = await peri.isConnected();
        debugPrintStack(label: 'connecting',maxFrames: 2);
        if (!c) { await peri.connect(); await peri.isConnected();}  //test if connected otherwise getting error connected already
        debugPrintStack(label: 'connecting2',maxFrames: 2);
        await peri.discoverAllServicesAndCharacteristics();
        debugPrintStack(label: 'connected',maxFrames: 2);
        peri.writeCharacteristic(
            "6E400001-B5A3-F393-E0A9-E50E24DCCA9E", // service
            "6E400002-B5A3-F393-E0A9-E50E24DCCA9E", // tx characteristic
            Uint8List.fromList(writeValue),
            false);}});}

  @override
  void initState() {
    super.initState();
    ble = BleManager();
    ble.createClient();
    connectToBle();}

  @override
  Widget build(BuildContext context) {return Scaffold(body: Center(child:Text('Loom Assist message sent')),);}}

  



    