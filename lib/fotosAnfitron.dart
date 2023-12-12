import 'package:dam_galeria_fotos_eventos/login.dart';
import 'package:dam_galeria_fotos_eventos/serviciosremotos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FotosAnfitron extends StatefulWidget {
  const FotosAnfitron({Key? key}) : super(key: key);

  @override
  State<FotosAnfitron> createState() => _FotosAnfitronState();
}

class _FotosAnfitronState extends State<FotosAnfitron> {
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
      body: dinamico(),
    );
  }

  Widget dinamico() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Text("ANFITRON"),
            SizedBox(height: 40,),
            ElevatedButton(
              onPressed: (){
                _mostrarDialogo();
              },
              child: Text("Agregar Foto"),
            ),
            Container(
              height: 600,
              child: FutureBuilder<List<String>>(
                future: obtenerURLsPorEvento(eventoIdx),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No hay fotos disponibles.');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onLongPress: () {
                            // Mostrar un AlertDialog antes de eliminar la foto
                            _mostrarConfirmacionEliminar(context, snapshot.data![index]);
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

// Método para mostrar el AlertDialog de confirmación antes de eliminar
  void _mostrarConfirmacionEliminar(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Foto"),
          content: Text("¿Estás seguro de que deseas eliminar esta foto?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                // Lógica para eliminar la foto
                await DB.eliminarURL(url);

                // Obtener las URLs actualizadas después de la eliminación
                List<String> urls = await obtenerURLsPorEvento(eventoIdx);
                bool encontradas = urls.isNotEmpty;

                // Actualizar el estado
                setState(() {
                  listaURLs = urls;
                  seEncontraronURLs = encontradas;
                });

                Navigator.of(context).pop(); // Cerrar el AlertDialog
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
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
