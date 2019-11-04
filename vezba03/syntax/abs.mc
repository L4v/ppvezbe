int abs(int i) {
  int res;
  int asd;
  if(i < 0)
    res = 0 - i;
  else 
    res = i;
  return res;
}

int main() {
  int a;
  int b, c,  d;
  a = 5;

   do  
     a = 5;
   while(a < 5);

   do
    {
     a = 5;
    }while(a < 5);

    do{
     a = 5;
     a = 6;
     }while(a < 5);

  return abs(-5);
}
