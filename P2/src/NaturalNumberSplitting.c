# include<stdio.h>
int a[100], n;

void print(int t) {
	int i;
	for (i = 1; i < t; i++) {
		printf("%d+", a[i]);
	}
	printf("%d\n", a[t]);
}

void js(int s, int t) {
	int i;
	if (s == 0) {
		print(t - 1);
	}
	for (i = 1; i <= s; i++) {
		if (a[t - 1] <= i && i < n) {
			a[t] = i;
			s = s - i;
			js(s, t + 1);
			s = s + i;
		}
	}
}
int main() {
	scanf("%d", &n);
	js(n, 1);
}
