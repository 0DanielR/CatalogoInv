import 'package:dam_galeria_fotos_eventos/login.dart';
import 'package:dam_galeria_fotos_eventos/serviciosremotos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Propietario extends StatefulWidget {
  const Propietario({Key? key}) : super(key: key);

  @override
  State<Propietario> createState() => _PropietarioState();
}

class _PropietarioState extends State<Propietario> {
  @override
  Widget build(BuildContext context) {
    String uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("EVENTOS ANFITRON"),
      ),
      body: FutureBuilder(
          future: DB.mostrarPropietario(uid),
          builder: (context, listaJSON){
            if(listaJSON.hasData){
              return ListView.builder(
                  itemCount: listaJSON.data?.length,
                  itemBuilder: (context,indice){
                    return ListTile(
                      title: Text("${listaJSON.data?[indice]['nombre']}"),
                      subtitle: Text("${listaJSON.data?[indice]['fechaEvento']}"),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirmar"),
                                content: Text("¿Estás seguro de que deseas quitar la visibilidad del evento para los invitados?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Cierra el AlertDialog
                                    },
                                    child: Text("Cancelar"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      DB.cambiarEstadoUsuarioEvento(listaJSON.data?[indice]['eventoId'], !listaJSON.data?[indice]['estado']);
                                      Navigator.of(context).pop(); // Cierra el AlertDialog después de realizar la acción
                                    },
                                    child: Text("Aceptar"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.remove_red_eye),
                      ),

                      onTap: (){
                          Navigator.pushNamed(context, '/fotosanfitron',arguments: {
                          'eventoId': listaJSON.data?[indice]['eventoId'],
                          'nombre': listaJSON.data?[indice]['nombre'],
                          'uid': uid,});
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
