import 'package:dam_galeria_fotos_eventos/login.dart';
import 'package:dam_galeria_fotos_eventos/serviciosremotos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Invitado extends StatefulWidget {
  const Invitado({Key? key}) : super(key: key);

  @override
  State<Invitado> createState() => _InvitadoState();
}

class _InvitadoState extends State<Invitado> {
  @override

  Widget build(BuildContext context) {
    String uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("EVENTOS INVITADO"),
      ),
      body: FutureBuilder(
          future: DB.mostrarInvitados(uid),
          builder: (context, listaJSON){
            if(listaJSON.hasData){
              return ListView.builder(
                  itemCount: listaJSON.data?.length,
                  itemBuilder: (context,indice){
                    return ListTile(
                      title: Text("${listaJSON.data?[indice]['nombre']}"),
                      subtitle: Text("Fecha del evento: ${listaJSON.data?[indice]['fechaEvento']}"),
                      trailing: IconButton(onPressed: (){
                        DB.eliminar(listaJSON.data?[indice]['id']).then((value){
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SE BORRO CON EXITO")));
                          });

                        });
                      }, icon: Icon(Icons.delete)),
                      onTap: (){
                        Navigator.pushNamed(context, '/fotosinvitado',arguments: {
                          'eventoId': listaJSON.data?[indice]['eventoId'],
                          'nombre': listaJSON.data?[indice]['nombre'],
                          'uid': uid,
                        },);
                      },
                    );
                  }
              );
            }
            return Center(child: CircularProgressIndicator(),);
          }),
    );
  }
}
