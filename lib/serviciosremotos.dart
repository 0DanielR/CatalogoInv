import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
var carpetaRemota = FirebaseStorage.instance;
var baseRemota = FirebaseFirestore.instance;

class CR{
  static Future subirArchivo (String path, String nombreImagen) async{
    var file = File(path);
    return await carpetaRemota.ref("imagenes/$nombreImagen").putFile(file);
  }

  static Future<ListResult> mostrarTodos({String? eventid}) async {
    // Si eventid está presente, realiza la consulta filtrada
    if (eventid != null) {
      // Asegúrate de tener una referencia a la carpeta específica
      var carpetaEventid = carpetaRemota.ref("imagenes").child(eventid);

      return await carpetaEventid.listAll();
    } else {
      // Si eventid no está presente, muestra todas las imágenes
      return await carpetaRemota.ref("imagenes").listAll();
    }
  }


  static Future <String> obtenerURLimagen (String nombre) async{
    return await carpetaRemota.ref("imagenes/$nombre").getDownloadURL();
  }
}

class DB {
  static Future crearEvento(Map<String, dynamic> EVENTO, String usuario) async {
    try {
      // Agregar el evento a la colección 'evento'
      DocumentReference eventoRef = await baseRemota.collection("evento").add(EVENTO);

      // Obtener el ID del documento recién agregado
      String eventoId = eventoRef.id;

      // Agregar el evento a la colección 'usuario-evento'
      await baseRemota.collection("usuario-evento").add({
        'usuario': usuario,
        'rol':"admin",
        'eventoId': eventoId,
        'nombre': EVENTO['nombre'],
        'fechaEvento': EVENTO['fechaVencimiento'],
        'estado':EVENTO['estado']
      });

      return eventoId; // Devolver el ID del evento agregado
    } catch (error) {
      print("Error al crear el evento: $error");
      return null; // Manejar el error según tus necesidades
    }
  }

  static Future<Map<String, dynamic>?> aceptarEvento(String codigo, String usuario) async {
    try {
      // Verificar si el código ya existe
      var query = await baseRemota.collection("evento").where("codigoEvento", isEqualTo: codigo).get();

      if (query.docs.isNotEmpty) {
        // Si el código ya existe en la colección 'evento', obtener los datos del evento
        var eventoExistente = query.docs.first;
        String eventoIdExistente = eventoExistente.id;
        Map<String, dynamic> datosEvento = eventoExistente.data() as Map<String, dynamic>;

        // Agregar el evento a la colección 'usuario-evento'
        await baseRemota.collection("usuario-evento").add({
          'usuario': usuario,
          'eventoId': eventoIdExistente,
          'nombre': datosEvento['nombre'],
          'fechaEvento': datosEvento['fechaVencimiento'],
          'rol':"invitado",
          'estado':datosEvento['estado']
          // Agrega otros campos necesarios de acuerdo a tus necesidades
        });

        // Devolver los datos del evento existente
        return datosEvento;
      } else {
        // Si el código no existe en la colección 'evento', devolver null
        return null;
      }
    } catch (error) {
      print("Error al crear el evento: $error");
      return null; // Manejar el error según tus necesidades
    }
  }

  static Future<List> mostrarInvitados(String uid) async{
    List tempora=[];
    var query = await baseRemota.collection("usuario-evento").where('usuario', isEqualTo: uid).where('rol', isEqualTo:'invitado').
        where('estado', isEqualTo: true).get();
    query.docs.forEach((element) {
      Map<String,dynamic> data =element.data();
      data.addAll({'id':element.id});
      tempora.add(data);
    });
    return tempora;
  }

  static Future eliminar(String id ) async{
    return await baseRemota.collection("usuario-evento").doc(id).delete();
  }

  static Future Visible(String idEvento)async{
    try {
      // Cambiar el estado a false en la colección usuario-evento
      var queryUsuarioEvento = await baseRemota.collection("usuario-evento").where('eventoId', isEqualTo: idEvento).get();

      for (var docUsuarioEvento in queryUsuarioEvento.docs) {
        await baseRemota.collection("usuario-evento").doc(docUsuarioEvento.id).update({'estado': false});
      }

      // Cambiar el estado a false en la colección evento
      await baseRemota.collection("evento").doc(idEvento).update({'estado': false});

      print("Estados cambiados a inactivo correctamente");
    } catch (error) {
      print("Error al cambiar estados a inactivo: $error");
    }
  }

  static Future<List> mostrarPropietario(String uid) async{
    List tempora=[];
    var query = await baseRemota.collection("usuario-evento").where('usuario', isEqualTo: uid).where('rol', isEqualTo:'admin').get();
    query.docs.forEach((element) {
      Map<String,dynamic> data =element.data();
      data.addAll({'id':element.id});
      tempora.add(data);
    });
    return tempora;
  }

  static Future<void> eliminarURL(String url) async {
    try {
      // Realizar una consulta para obtener el documento que coincide con la URL
      QuerySnapshot querySnapshot = await baseRemota.collection('evento-fotos').where('urlfoto', isEqualTo: url).get();

      // Iterar sobre los documentos encontrados (puede haber varios si hay duplicados)
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        // Obtener la referencia del documento y eliminarlo
        await documentSnapshot.reference.delete();
      }
    } catch (e) {
      print('Error al eliminar URL de la base de datos: $e');
    }
  }

  static Future<void> cambiarEstadoUsuarioEvento(String eventoId, bool nuevoEstado) async {
    try {
      // Obtén los documentos en usuario-evento relacionados con el eventoId
      var querySnapshot = await baseRemota.collection('usuario-evento').where('eventoId', isEqualTo: eventoId).get();

      // Actualiza el estado en usuario-evento para cada documento
      for (var document in querySnapshot.docs) {
        await baseRemota.collection('usuario-evento').doc(document.id).update({
          'estado': nuevoEstado,
        });
      }

      // También actualiza el estado en el documento evento correspondiente
      await baseRemota.collection('evento').doc(eventoId).update({
        'estado': nuevoEstado,
      });
    } catch (e) {
      print('Error al cambiar el estado en usuario-evento: $e');
      throw e;
    }
  }


}