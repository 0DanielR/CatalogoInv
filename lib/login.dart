import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController correo = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Planeador de Eventos"),
        automaticallyImplyLeading: false,
      ),
      body: Center(

        child:
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("LOGIN",style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.deepPurple),),
                SizedBox(height: 30,),
                TextField(
                  decoration: InputDecoration(labelText: "email"),
                  controller: correo,
                ),
                SizedBox(height: 30,),
                TextField(
                  decoration: InputDecoration(labelText: "password"),
                  controller: password,
                  obscureText: true,
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(onPressed: (){
                      FirebaseAuth.instance.signInWithEmailAndPassword(email: correo.text, password: password.text).then((value){
                        String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
                        Navigator.pushNamed(context, '/main',arguments:uid);
                      });

                    }, child: Text(" LOGIN ")),
                    SizedBox(width: 30,),
                    FilledButton(onPressed: (){
                      Navigator.pushNamed(context, '/singup');
                    }, child: Text("REGISTER")),
                  ],
                )


              ],
            ),
          )
      ),
    );
  }
}
