class CardModel {
  //attribut
  final int id;
  final String content;
  bool isMatched;
  bool isSelected;
  int? owner;

  //constructeur
  CardModel({required this.id, required this.content, this.isMatched = false, this.isSelected = false, this.owner});

  get getId => id;

  get getContent => content;

  get getIsMatched => isMatched;

 set setIsMatched(isMatched) => this.isMatched = isMatched;

  get getIsSelected => isSelected;

 set setIsSelected( isSelected) => this.isSelected = isSelected;

  get getOwner => owner;

 set setOwner( owner) => this.owner = owner;
}
