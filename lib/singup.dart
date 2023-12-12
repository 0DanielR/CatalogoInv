import 'package:dam_galeria_fotos_eventos/principal.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingUp extends StatefulWidget {
  const SingUp({Key? key}) : super(key: key);

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  TextEditingController usuario = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  bool ocultar = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Nuevo Usuario"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Nuevo Usuario"),
              SizedBox(height: 30,),
              TextField(
                decoration: InputDecoration(labelText: "nombre"),
                controller: usuario,
              ),
              SizedBox(height: 30,),
              TextField(
                decoration: InputDecoration(labelText: "correo"),
                controller: email,
              ),
              SizedBox(height: 30,),
              TextField(
                decoration: InputDecoration(
                    labelText: "contraseña",
                    suffix: IconButton(onPressed: (){
                      setState(() {
                        ocultar = !ocultar;
                      });
                    }, icon: Icon(Icons.remove_red_eye))
                ),
                controller: password,
                obscureText: ocultar,
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(onPressed: (){
                    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text).then((value){
                      Navigator.pushReplacementNamed(context, '/');
                    }).onError((error, stackTrace){
                      print("Error ${error.toString()}");
                    });
                  }, child: Text("REGISTRAR")),
                  SizedBox(width: 30,),
                  FilledButton(onPressed: (){Navigator.pop(context);}, child: Text("CANCELAR"))
                ],
              )

            ],
          ),
        ),
      ),

    );
  }
}
