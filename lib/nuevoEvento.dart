import 'package:dam_galeria_fotos_eventos/login.dart';
import 'package:dam_galeria_fotos_eventos/serviciosremotos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NuevoEvento extends StatefulWidget {
  const NuevoEvento({Key? key}) : super(key: key);

  @override
  State<NuevoEvento> createState() => _NuevoEventoState();

}

class _NuevoEventoState extends State<NuevoEvento> {
  TextEditingController eventoname = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String fechaevento="";
  String tipo ="ACADEMICO";
  String direccion="";
  TextEditingController codigo = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("EVENTO NUEVO"),
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: eventoname,
                decoration: InputDecoration(labelText: "NOMBRE EVENTO: "),
              ),
              SizedBox(height: 15,),
              Row(children: [
                Text("${selectedDate.year}-${selectedDate.month}-${selectedDate.day}"),
                IconButton(onPressed: ()async{
                  final DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000));
                  if(dateTime != null){
                    setState(() {
                      selectedDate =dateTime;
                      fechaevento = "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                    });
                  }
                }, icon: Icon(Icons.calendar_month))
              ],),
              SizedBox(height: 15,),
              DropdownButton(
                value: tipo,
                items: [
                  DropdownMenuItem(value: "ACADEMICO", child: Text("ACADEMICO")),
                  DropdownMenuItem(value: "BODA", child: Text("BODA")),
                  DropdownMenuItem(value: "CUMPLEAÑOS", child: Text("CUMPLEAÑOS")),
                  DropdownMenuItem(value: "DEPORTIVOS", child: Text("DEPORTIVOS")),
                  DropdownMenuItem(value: "CULTURALES", child: Text("CULTURALES")),
                  DropdownMenuItem(value: "CORPORATIVOS", child: Text("CORPORATIVOS")),
                ], onChanged: (value){
                setState(() {
                  tipo=value.toString();
                });
              },

              ),
              SizedBox(height: 30,),
              TextField(
                controller: codigo,
                decoration: InputDecoration(labelText: "CODIGO EVENTO: "),
              ),
              SizedBox(height: 30,),

              ElevatedButton(onPressed: (){
                var JSonTemporal={
                  'dueno':uid,
                  'fechaVencimiento': fechaevento,
                  'nombre': eventoname.text,
                  'tipo': tipo,
                  'codigoEvento':codigo.text,
                  'estado':true
                };
                DB.crearEvento(JSonTemporal, uid).then((value){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SE INSERTÓ CON EXITO")));
                  Navigator.pop(context);
                });
              }, child: Text("GENERAR"))
            ],

          ),
        ),
      ),
    );
  }
}
