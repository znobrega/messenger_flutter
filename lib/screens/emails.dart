import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './new_email.dart';
import './messages.dart';
import '../models/user.dart';

import 'dart:async';
import 'dart:io';
import 'package:http/io_client.dart';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;



class Emails extends StatefulWidget {

  final User _currentUser;
  Emails(this._currentUser);
  @override
  State<StatefulWidget> createState() => _EmailsState(_currentUser);
}

class _EmailsState extends State<Emails> {
  //String date = DateFormat.Hm().format(DateTime.now());
  final User _currentUserState;
  _EmailsState(this._currentUserState);
  int listCount;

  Map<String, dynamic> allData = {
    "username": "Carlos",
    "emails": [],
  };

  getEmails() async {
          HttpClient httpClient = new HttpClient()
        ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) {
          print("CERTIFICADO HTTP");
          // tests that cert is self signed, correct subject and correct date(s)
          return true;
        });

      IOClient ioClient = new IOClient(httpClient);
      var urlGetList = 'https://192.168.0.39:8443/chat/getlist';

      var getList = Map<String, dynamic>();
    
      getList['nickname'] = widget._currentUser.nickname;

      print("clicked");
      ioClient
          .get(
            urlGetList,
            headers: {"Accept": "application/json"},)
            // PROBLEM
            //body: getList)
          .then((response) {
            print("Signup:");
            print('Response: ${response.statusCode}  Body:${response.body} ');

            Map result = JSON.jsonDecode(response.body);
            print("Map:   $result");
        })
          .catchError((err) {
        print(err.toString());
        print('deu ruim');
            ioClient.close();

      });
  }
    
  @override
  Widget build(BuildContext context) {
    debugPrint("USUARIO");
    debugPrint(_currentUserState.nickname);
    return Scaffold(
      appBar: AppBar(
        title: Text("Email list"),
      ),
      body:listEmailUser(),
      drawer: Drawer(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: CircleAvatar(
                  radius: 40.0,
                  child: Text("C"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Text("Hello"),
              )
            ],
          ),
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToNewEmail();
        },
        tooltip: "Enviar novo email",
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToNewEmail() async {
    bool result = await Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => NewEmail(allData, _currentUserState),),);
    
    if(result == true) {
      debugPrint("Pagina de novos emails");
    }
  }
 
  //Very usefull function
  // ListView.builder 
  Widget listEmail() {
    int listSize = listEmailsCount(allData["emails"]);

    if(listSize == 0) {
      return Center(child: Text("Você não possui emails"),);
    }
    return  ListView.builder(
      itemCount: listSize,
      itemBuilder: (BuildContext context, int position) {
        
        String to = allData['emails'][position]["to"];
        
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: Text(to.substring(0,1)),
            title: Text("$to ${allData['emails'][position]["dateEmail"]} ", 
              style: TextStyle(
                fontWeight: FontWeight.w500,
                ),
              ),
            subtitle: Text("${allData['emails'][position]["subject"]}"),
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Messages(allData["emails"][position]["messages"])),
              );
            },
          ),
        );
      },
    );
  }

  int listEmailsCount(List emails) {
    if(emails == null) {
      return 0;
    }
    return emails.length;
  }

  Widget listEmailUser() {
    int listSize = listEmailsCount(_currentUserState.chats);

    if(listSize == 0) {
      return Center(child: Text("Você não possui emails"),);
    }
    return  ListView.builder(
      itemCount: listSize,
      itemBuilder: (BuildContext context, int position) {
        
        String to = _currentUserState.chats[position].to.username;
        debugPrint(to);
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: Text(to.substring(0,1)),
            title: Text("$to ${_currentUserState.chats[position].date} ", 
              style: TextStyle(
                fontWeight: FontWeight.w500,
                ),
              ),
            subtitle: Text("${_currentUserState.chats[position].subject}"),
            onTap: () {
              Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => Messages(_currentUserState.chats[position].messages)),
              );
            },
          ),
        );
      },
    );
  }
}
