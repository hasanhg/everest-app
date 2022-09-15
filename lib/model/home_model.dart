class HomeModel {
  int get integer => _integer;
  int _integer = 0;

  int incrementCounter() => ++_integer;

  String sayHello() => 'Hello There!';
}
