part of e3kit;

final _uuid = Uuid();
final _eThrees = Map<String, EThree>();

class EThree {
  final MethodChannel _channel =
      const MethodChannel('plugins.virgilsecurity.com/e3kit')
        ..setMethodCallHandler(EThree._handleMethodCall);

  final String _id = _uuid.v4();

  RenewJwtCallback tokenCallback;

  Future<String> get identity async {
    final String version = await _invokeMethod('getIdentity', {});
    return version;
  }

  EThree._(this.tokenCallback) {
    _eThrees[_id] = this;
  }

  static Future<EThree> init(String identity, RenewJwtCallback tokenCallback) async {
    final eThree = EThree._(tokenCallback);
    await eThree._invokeMethod('init', {'identity': identity});
    return eThree;
  }

  Future<bool> hasLocalPrivateKey() {
    return _invokeMethod('hasLocalPrivateKey', {});
  }

  Future<void> register() {
    return _invokeMethod('register', {});
  }

  Future<void> cleanUp() {
    return _invokeMethod('cleanUp', {});
  }

  Future<void> rotatePrivateKey() {
    return _invokeMethod('rotatePrivateKey', {});
  }

  Future<Map<String, String>> findUsers(List<String> identities) {
    Map<String, dynamic> args = {'identities': identities};
    return _invokeMethod('findUsers', args)
      .then((res) => Map<String, String>.from(res));
  }

  Future<String> encrypt(String text, [Map<String, String> users]) {
    return _invokeMethod('encrypt', {'text': text, 'users': users});
  }

  Future<String> decrypt(String text, [String user]) {
    return _invokeMethod('decrypt', {'text': text, 'user': user});
  }

  Future<void> backupPrivateKey(String password) {
    return _invokeMethod('backupPrivateKey', {'password': password});
  }

  Future<void> resetPrivateKeyBackup() {
    return _invokeMethod('resetPrivateKeyBackup', {});
  }

  Future<void> changePassword(String oldPassword, String newPassword) {
    return _invokeMethod('changePassword', {'oldPassword': oldPassword, 'newPassword': newPassword});
  }

  Future<void> restorePrivateKey(String password) {
    return _invokeMethod('restorePrivateKey', {'password': password});
  }

  Future<void> unregister() {
    return _invokeMethod('unregister', {});
  }

  Future<void> createRatchetChannel(String identity) async {
    await _invokeMethod('createRatchetChannel', {"identity": identity});
  }

  Future<void> joinRatchetChannel(String identity) async {
    await _invokeMethod('joinRatchetChannel', {"identity": identity});
  }

  Future<bool> hasRatchetChannel(String identity) async {
    return await _invokeMethod('hasRatchetChannel', {"identity": identity});
  }

  Future<bool> getRatchetChannel(String identity) async {
    return await _invokeMethod('getRatchetChannel', {"identity": identity});
  }

  Future<void> deleteRatchetChannel(String identity) async {
    await _invokeMethod('deleteRatchetChannel', {"identity": identity});
  }

  Future<String> ratchetEncrypt(String identity, String message) async {
    return await _invokeMethod('ratchetEncrypt', {"identity": identity, "message": message});
  }

  Future<String> ratchetDecrypt(String identity, String message) async {
    return await _invokeMethod('ratchetDecrypt', {"identity": identity, "message": message});
  }

  Future<T> _invokeMethod<T>(String method, [dynamic arguments]) {
    final args = (arguments ?? {});
    args['_id'] = _id;
    return _channel.invokeMethod(method, args);
  }

  static Future<dynamic> _handleMethodCall(MethodCall call) {
    final String _id = call.arguments['_id'];

    switch(call.method) {
      case 'tokenCallback':
        return _eThrees[_id].tokenCallback();
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EThree && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}