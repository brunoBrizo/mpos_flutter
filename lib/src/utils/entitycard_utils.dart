class EntityCard {
  String cardPathImage;
  double sizeOfImage;

  EntityCard() {
    cardPathImage = "";
    sizeOfImage = 0;
  }

  getCardPathImage() {
    return cardPathImage;
  }

  getSizeOfImage() {
    return sizeOfImage;
  }

  setCardPathImage(String _cardPathImage) {
    cardPathImage = _cardPathImage;
  }

  setSizeOfImage(double _sizeOfImage) {
    sizeOfImage = _sizeOfImage;
  }
}
