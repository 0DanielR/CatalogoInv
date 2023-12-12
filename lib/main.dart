import 'package:dam_galeria_fotos_eventos/fotosAnfitron.dart';
import 'package:dam_galeria_fotos_eventos/fotosInvitado.dart';
import 'package:dam_galeria_fotos_eventos/invitado.dart';
import 'package:dam_galeria_fotos_eventos/login.dart';
import 'package:dam_galeria_fotos_eventos/nuevoEvento.dart';
import 'package:dam_galeria_fotos_eventos/principal.dart';
import 'package:dam_galeria_fotos_eventos/propietario.dart';
import 'package:dam_galeria_fotos_eventos/singup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/':(context)=> Login(),
        '/singup':(context)=>SingUp(),
        '/main':(context)=>Principal(),
        '/newEvent':(context)=>NuevoEvento(),
        '/invitado':(context)=>Invitado(),
        '/propietario':(context)=>Propietario(),
        '/fotosinvitado':(context)=>FotosInvitado(),
        '/fotosanfitron':(context)=> FotosAnfitron()
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),

    );
  }
}
