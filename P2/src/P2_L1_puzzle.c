#include<stdio.h>
int n, m;
int startx, starty, endx, endy;
int puzzle[7][7];
int ans = 0;
void printPuzzle();
void dfs(int i, int j);
int main()
{
    scanf("%d%d", &n, &m);
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            scanf("%d", &puzzle[i][j]);
        }
    }
    scanf("%d%d%d%d", &startx, &starty, &endx, &endy);

    dfs(startx - 1, starty - 1);

    printf("%d", ans);

    return 0;
}
void dfs(int i, int j)
{
    //printPuzzle();
    if (i == endx - 1 && j == endy - 1)
    {
        ans++;
        return;
    }
    if (i - 1 >= 0 && puzzle[i - 1][j] == 0)//如果能向上走
    {
        puzzle[i][j] = 2;//标记(i,j)已经走过
        dfs(i - 1, j);
        puzzle[i][j] = 0;
    }
    if (i + 1 <= n - 1 && puzzle[i + 1][j] == 0)//如果能向下走
    {
        puzzle[i][j] = 2;//标记(i,j)已经走过
        dfs(i + 1, j);
        puzzle[i][j] = 0;
    }
    if (j - 1 >= 0 && puzzle[i][j - 1] == 0)//如果能向左走
    {
        puzzle[i][j] = 2;//标记(i,j)已经走过
        dfs(i, j - 1);
        puzzle[i][j] = 0;
    }
    if (j + 1 <= m - 1 && puzzle[i][j + 1] == 0)//如果能向右走
    {
        puzzle[i][j] = 2;//标记(i,j)已经走过
        dfs(i, j + 1);
        puzzle[i][j] = 0;
    }
}
void printPuzzle()
{
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            printf("%d ", puzzle[i][j]);
        }
        printf("\n");
    }
    printf("\n");
}