//OPIS: ABS funkcija
//RETURN: 5

int abs(int i) {
  int res;
  if(i < 0)
    res = 0 - i;
  else 
    res = i; 

}

int main() {
  return abs(-5);
}
