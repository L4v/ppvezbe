//OPIS: switch iskaz
//RETURN: 5

int main() {
  int state;
  int x;
  state = 2;

  switch(state) {
    case 69: x = 1; break;
    case 70: { x = 5;} break;
    default: x = 10;
  }

  for (int i = 0; i < 5; i++)
   for (int j = 0; j < 5; j++)
    i = 5;
    
  return x;
}
