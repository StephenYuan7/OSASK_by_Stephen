#include <stdio.h>
#include <string.h>
int main(int argc,char* argv[])
{
    char source[20],des[20];
    char srcline[60]={'\0'},desline[60]={'\0'};
    char hex[17]="0123456789ABCDEF";
    FILE *in,*out;
    int i;
    //long long int addr;
    if (argc!=3){printf("use:map2sym sourcefilename destfilename\n");return 0;}
    ++argv;
    strcpy(source,*argv);
    ++argv;
    strcpy(des,*argv);
    if((in=fopen(source,"r"))==NULL)     // �������ļ�
    {printf("�޷���Դ�ļ��ļ�\n");
    return 0;
    }
    if((out=fopen(des,"w"))==NULL)   // ������ļ�
    {printf("�޷��򿪽���ļ�\n");
    return 0;
    }
    for (i=0;i<4;i++)
    {
        fgets(srcline,59,in);
    }
    while (fgets(srcline,59,in)!=NULL)
    {
        //�ı�srcline0x00000000 + 0x00280000��д�뵽desline��
        strncpy(desline,&srcline[2],8);
        desline[3]=hex[desline[3]-'0'+8];
        desline[2]=hex[desline[2]-'0'+2];
        desline[8]=' ';
        strcpy(&desline[9],&srcline[13]);
        fputs(desline,out);
        desline[0]='\0';

    }
    fclose(in);                         // �ر������ļ�
    fclose(out);
    return 0;
}

