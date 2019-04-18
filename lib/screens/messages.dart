import 'package:flutter/material.dart';
import '../models/message.dart';

class Messages extends StatefulWidget{
  final List<dynamic> _allMessages;

  Messages(this._allMessages);
  
  @override
  State<StatefulWidget> createState() => _MessagesState(_allMessages);
}

class _MessagesState extends State<Messages> {

  final List<dynamic> _allMessagesState;
  _MessagesState(this._allMessagesState);
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nomes"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },),
      ),
      body: screenChat(),
    );
  }
 
  void newMessage(String message) {
    if(message.isNotEmpty) {
      setState(() {
        debugPrint("setstate");
        // _allMessagesState.insert(0, {
        //   "fromDialog": "Carlos",
        //   "message": message,
        //   "date": DateTime.now().toString(),
        // });
        _allMessagesState.insert(0,
         Message(_allMessagesState[0].chat, _allMessagesState[0].to,
         _allMessagesState[0].from, message,DateTime.now().toString()));

        _messageController.text = "";
      });
    }
  } 

  Widget messageList() {
    return ListView.builder(
        reverse: true,
        itemCount: countMessages(_allMessagesState),
        itemBuilder: (BuildContext context, int position) {
          return Column( 
            children: [ 
              timeStamp(_allMessagesState, position),
              Card(
              child: ListTile(
                title: Text("${_allMessagesState[position].from.username}"),
                subtitle: Text("${_allMessagesState[position].message}"),
                ),
              )
            ]
          );
        },
      );
  }

  int countMessages(List<dynamic> _allMessages) {
    if(_allMessages == null) {
      return 0;
    }
    return _allMessages.length;
  }

  Widget screenChat() {
    return Column(
      children: <Widget>[
        Flexible(
          child: messageList(),
        ),
        Divider(
          height: 1.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: TextFormField(
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            controller: _messageController,
            decoration: InputDecoration(
                hintText: 'Digite...',
                suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      newMessage(_messageController.text);
                    }
                )
            ),
          ),
        )
      ],
    );
  }

  Widget timeStamp(List _allMessagesState, int position) {
    var date = DateTime.now();
    debugPrint("Position: $position, ${_allMessagesState.length}");
    if(_allMessagesState.length == position+1) {
      return ListTile(title: Text( '$date'),);
    }
    else if(position > 0){
      int newMessageDay =  int.parse(_allMessagesState[position].date.substring(5,7));
      int oldMessageDay = int.parse(_allMessagesState[position-1].date.substring(5,7));

      if(newMessageDay != oldMessageDay) {
        return ListTile(title: Text( '$date'),);
      }
    }
    return Container();
  }
  
}

// bottomNavigationBar: Container(
//         margin: EdgeInsets.only(left: 16.0),
//         child: TextFormField(
//           maxLines: null,
//         controller: _messageController,
//           decoration: InputDecoration(
//               hintText: 'Digite...',
//               suffixIcon: IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     newMessage(_messageController.text);
//                   }
//               )
//           ),
//         ),
//       ),