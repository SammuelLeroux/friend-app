class Player {
  //attribut
  String name;
  int nbrPoints;

  //constructeur
  Player({
    required this.name,
    required this.nbrPoints,
  });

  @override
  String toString() {
    return 'Player{name: $name}';
  }

  String get getName => name;

  set setName(String name) => this.name = name;

  get getNbrPoints => nbrPoints;

  set setNbrPoints( nbrPoints) => this.nbrPoints = nbrPoints;
}