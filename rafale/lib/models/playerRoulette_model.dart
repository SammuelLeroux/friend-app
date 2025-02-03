class PlayerRoulette {
  String name;
  int health;
  List<String> abilities;

  PlayerRoulette({
    required this.name,
    this.health = 5,
    List<String>? abilities,
  }) : abilities = abilities ?? [];

  // Ajouter un pouvoir
  void addAbility(String ability) {
    if (abilities.isEmpty) { // Limité à un seul pouvoir à la fois
      abilities.add(ability);
    }
  }

  // Utiliser un pouvoir (et le supprimer)
  void useAbility(String ability) {
    abilities.remove(ability);
  }

  // Vérifier si le joueur est encore en vie
  bool isAlive() => health > 0;
}
