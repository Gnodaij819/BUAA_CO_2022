#include<stdio.h>
#define MAXSIZE 10000

void func(int n);

int main()
{
    int n;
    scanf("%d",&n);
    func(n);
    return 0;
}

void func(int n)
{
    int i,j;
    int tmp;
    int digit;//位数
    int carry;//进位
    int s[MAXSIZE];

    digit=0;
    carry=0;
    s[0]=1;

    for(i=2;i<=n;i++)//从1乘到n,由于已经初始化，i从2开始取
    {
        for(j=0;j<=digit;j++)//逐位计算
        {
            tmp=s[j]*i+carry;
            s[j]=tmp%10;
            carry=tmp/10;
        }
        while(carry)
        {
            s[j]=carry%10;
            carry/=10;
            j++;
        }
        digit=j-1;
    }
    for(i=digit;i>=0;i--) 
        printf("%d",s[i]);
    printf("\n");
    return;
}
