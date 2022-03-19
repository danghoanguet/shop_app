class HttpExepciotn implements Exception {
  final String message;

  HttpExepciotn(this.message);

  @override
  String toString() {
    return this.message;
  }
}
