import 'package:dam_galeria_fotos_eventos/login.dart';
import 'package:dam_galeria_fotos_eventos/serviciosremotos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FotosInvitado extends StatefulWidget {
  const FotosInvitado({Key? key}) : super(key: key);

  @override
  State<FotosInvitado> createState() => _FotosInvitadoState();
}

class _FotosInvitadoState extends State<FotosInvitado> {
  List<String> listaURLs = [];
  bool seEncontraronURLs = false;
  String nombrex = "";//ya tiene valor
  String eventoIdx = "";//ya tiene valor
  String uidx = "";//ya tiene valor
  String titulo = "Imagenes";
  String archivoRemoto = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      // Accede al contexto aquí después de que initState haya completado
      final Map<String, dynamic>? args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        String eventoId = args['eventoId'];
        String nombre = args['nombre'];
        String uid = args['uid'];

        setState(() {
          nombrex = nombre;
          eventoIdx = eventoId;
          uidx = uid;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("EVENTO: $nombrex"),
      ),
      body:dinamico()

    );}

  Widget dinamico() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Text("INVITADO"),
            // Eliminado el botón "Buscar"
            SizedBox(height: 40,),
            ElevatedButton(
              onPressed: (){
                _mostrarDialogo();
              },
              child: Text("Agregar Foto"),
            ),
            // Mostrar las fotos sin necesidad de presionar el botón "Buscar"
            Container(
              height: 600,
              child: FutureBuilder<List<String>>(
                // Llama a obtenerURLsPorEvento en initState
                future: obtenerURLsPorEvento(eventoIdx),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Muestra un indicador de carga mientras se obtienen las fotos
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Manejar errores si ocurren
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Mostrar un mensaje si no hay fotos
                    return Text('No hay fotos disponibles.');
                  } else {
                    // Muestra las fotos obtenidas
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            // Lógica para eliminar la imagen al hacer "hold"
                            DB.eliminarURL(snapshot.data![index]);
                          },
                          child: Image.network(snapshot.data![index]),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> obtenerURLsPorEvento(String idevento) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('evento-fotos')
          .where('idevento', isEqualTo: idevento)
          .get();

      List<String> urls = [];
      querySnapshot.docs.forEach((DocumentSnapshot document) {
        if (document.exists) {
          // Asegurarse de que el documento existe antes de intentar acceder a sus datos
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          String url = data['urlfoto'];
          urls.add(url);
        }
      });

      return urls;
    } catch (e) {
      print('Error al obtener URLs: $e');
      return [];
    }
  }

  void _mostrarDialogo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nuevo Evento"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ElevatedButton(
                onPressed: () async {
                  // Abre el FilePicker cuando se presiona el botón
                  final archivoAEnviar = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg', 'jpeg'],
                  );

                  // Aquí puedes manejar la lógica para subir el archivo y guardar en la base de datos
                  if (archivoAEnviar != null) {
                    var path = archivoAEnviar.files.single.path!;
                    var nombre = archivoAEnviar.files.single.name;
                    String eventId = eventoIdx;

                    // Subir la foto y obtener la URL de Firebase Storage
                    await CR.subirArchivo(path, nombre);
                    String url = await CR.obtenerURLimagen(nombre);

                    // Guardar la información en Firebase Database
                    await guardarEnDatabase(eventId, url);

                    setState(() {
                      titulo = "SE SUBIÓ IMG";
                      //archivoRemoto = nombre; // Actualiza el archivo remoto para mostrar la nueva imagen
                    });

                    Navigator.pop(context); // Cierra el cuadro de diálogo después de subir el archivo
                  }
                },
                child: Text("Seleccionar Archivo"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el cuadro de diálogo
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> guardarEnDatabase(String idevento, String fotoURL) async {
    await FirebaseFirestore.instance.collection('evento-fotos').add({
      'idevento': idevento,
      'urlfoto': fotoURL,
    });
  }
}

/*
SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Text(nombrex),
                SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: () {

                  },
                  child: Text("Agregar foto"),
                )
              ],
            ),
          ),
        ),
      ),
*/