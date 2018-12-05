import 'dart:io';
import 'dart:convert';

import '../lib/server/client.dart';

// List of Clients connected with the server.
List<Client> clients = new List<Client>();
List<String> channels = ['default', 'test', 'test1'];

main() async{
  // Creates a Listening Socket for the Server.
  // Using InternetAddress.anyIPv4 we accept connection from any device in the network.
  ServerSocket.bind(InternetAddress.anyIPv4, 4040)
    .then((serverSocket){
      print("Server is up on port 4040");
      serverSocket.listen(onData, 
        onDone: handleDone,
        onError: handleError,
        cancelOnError: false,
      );
    });
}

void onData(Socket socket){
  print("Connection from ${socket.address.address}:${socket.remotePort.toString()}");
  socket.write("Welcome to our chat :)\n");
  if(clients.length == 0)
    socket.write("You are alone in our chat :(\n");
  else
    socket.write("There are ${clients.length} users online :)\n");
  // New Socket Connection
  // Create a new Client
  // And initialize it with the default channel.
  Client client = new Client(socket, channels[0]);
  // Add the Client to the Client's List
  clients.add(client);
  // Make the Client Listen to the Socket
  socket.listen((List<int> data){
      String message = utf8.decode(data).toString().trimLeft();
      // Non Empty message
      if(message.trim() != ""){
        // Test if it has the NICK command
        if(message.contains("NICK")){
          List<String> list = message.split("NICK");
          // Changing client's nickname
          String previousNick = client.getNickname();
          client.setNickname(list[1].trim());
          // Notifying Server and Another Users
          String response = "User ${previousNick} changed its Nickname to ${client.getNickname()}";
          print(response);
          distributeMessage(client, response + '\n');
        }
        // Test if it has the USUARIO command
        else if(message.contains("USUARIO")){
          List<String> list = message.split("USUARIO");
          String user = list[1].trim();
          // Iterating over the clients
          for(Client client in clients){
            if(client.getNickname() == user){
              socket.write("Usuário: ${client.getNickname()}");
              socket.write("Channel: ${client.getChannel()}");
              socket.write("IP Address: ${client.getSocket().address.toString()}");
            }
          }
        }
        // Test if it has the SAIRC command
        else if(message.contains("SAIRC")){
          List<String> list = message.split("SAIRC");
          if(list[1].trim() == "default" || list[1].trim() == ""){
            socket.close();
          }else{
            // Move Client to Default Channel
            client.setChannel(list[1]);
          }
        }
        // Test if it has the SAIR command
        else if(message.contains("SAIR")){
          socket.close();
        }
        // Test if it has the ENTRAR command
        else if(message.contains("ENTRAR")){
          List<String> list = message.split("ENTRAR");
          client.setChannel(list[1].trim());
          socket.write("Changing to the Channel: ${list[1]}");
          String response = "User ${client.getNickname()} moved to Channel ${list[1]}\n";
          print(response);
          distributeMessage(client, response);
        } 
        // Test if it has the LISTARC command
        else if(message.contains("LISTARC")){
          socket.write("List of availables channels:\n");
          for(String channel in channels)
            socket.write(". ${channel}\n");
        }
        // Ordinary message
        else
          distributeMessage(client, message);
      }
    }, 
    // Called when done Client Connection
    onDone: (){
      String message = "User ${client.getNickname()} disconnected from the server";
      print(message);
      distributeMessage(client, message + '\n');
      clients.remove(client);
      socket.close();
    }, 
    // Called when an Error occured with the Client Connection
    onError: (error, StackTrace trace){
      print("Client: Error");
      clients.remove(client);
      socket.close();
    },
    // Cancel the Subscription to the Stream if an error occured 
    cancelOnError: false); 
}

void distributeMessage(Client client, String message){
  String sentTime = formatDate(DateTime.now());
  for(Client c in clients){
    if(c != client && c.getChannel() == client.getChannel())
      c.getSocket().write("[${sentTime}] ${client.getNickname()}: ${message}");
  }
}

String formatDate(DateTime dateTime){
  if(dateTime.minute < 10)
    return "${dateTime.hour}:0${dateTime.minute}";
  else
    return "${dateTime.hour}:${dateTime.minute}";
}

void handleDone(){
  print("on Done");
}

void handleError(error, StackTrace trace){
  print("Error");
}