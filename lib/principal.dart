import 'package:dam_galeria_fotos_eventos/login.dart';
import 'package:dam_galeria_fotos_eventos/serviciosremotos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

  TextEditingController dueno = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("SISTEMA EVENTOS"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(

        child: 
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Mis Eventos (anfitron)
                  Container(
                    color: Colors.purple,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("MIS EVENTOS",style: TextStyle(
                          color: Colors.white
                        ),),
                        IconButton(onPressed: (){
                          Navigator.pushNamed(context, '/propietario',arguments:uid);
                        }, icon: Icon(Icons.account_box),iconSize: 120.0,)
                      ],
                    ),
                  ),
                  SizedBox(width: 40,),
                  //Nuevo Evento (anfitron)
                  Container(
                    color: Colors.purple,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("HACER EVENTO",style: TextStyle(
                            color: Colors.white
                        ),),
                        IconButton(onPressed: (){
                          Navigator.pushNamed(context, '/newEvent',arguments:uid);
                        }, icon: Icon(Icons.calendar_month),iconSize: 120.0,)
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Eventos Invitado (invitado)
                  Container(
                    color: Colors.purple,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("INVITADO",style: TextStyle(
                            color: Colors.white
                        ),),
                        IconButton(onPressed: (){
                          Navigator.pushNamed(context, '/invitado',arguments:uid);
                        }, icon: Icon(Icons.account_balance_wallet_outlined),iconSize: 120.0,)
                      ],
                    ),
                  ),
                  SizedBox(width: 40,),
                  //Agregar invitado a evento (invitado)
                  Container(
                    color: Colors.purple,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("INGRESAR EVENTO",style: TextStyle(
                            color: Colors.white
                        ),),
                        IconButton(onPressed: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ingresarEvento(uid);
                            },
                          );

                        }, icon: Icon(Icons.account_balance_wallet_outlined),iconSize: 120.0,)
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 40,),
              Container(
                width: 240.0,
                child: FilledButton(onPressed: (){
                  FirebaseAuth.instance.signOut().then((value){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                  });

                }, child: Text("LOGOUT")),
              )
            ],
          ),
        ),
      )
    );
  }
  //pantalla para agregar el codigo e ingresar invitados a los eventos
  TextEditingController codigoController = TextEditingController();
  Widget ingresarEvento(String usuario){
    return
      AlertDialog(
      title: Text("REGISTRAR AL EVENTO"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: codigoController,
            decoration: InputDecoration(labelText: "Código del Evento"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: (){Navigator.pop(context);}, child: Text("CANCELAR")),
        TextButton(onPressed: (){
          DB.aceptarEvento(codigoController.text, usuario);
          Navigator.of(context).pop();
        }, child: Text(" AGREGAR "))
      ],
    );
  }
}

