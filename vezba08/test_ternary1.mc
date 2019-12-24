// RETURN 8
int main()
{
	int a;
	int b;
	int c;
	a = 2;
	b = 3;
	c = (a > b) ? a : b;
	a = a + (a == b) ? a : b + 3;
	return a;
}
