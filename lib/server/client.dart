import 'dart:io';

class Client{

  Socket _socket;
  String _channel;
  String _nickname;

  Client(this._socket, this._channel){
    this._nickname = _socket.address.address + _socket.remotePort.toString();
  }

  /// Get Client's Channel.
  String getChannel() => _channel;
  
  /// Changes Client's Channel.
  void setChannel(String channel) => _channel = channel;

  /// Get Client's Nickname.
  String getNickname() => _nickname;

  /// Changes Client's Nickname
  void setNickname(nickname) => _nickname = nickname;

  /// Get Client's Socket.
  Socket getSocket() => _socket;
}

