NUM			[0-9]
ALPHA		[a-zA-Z]
COND_OP		"<="|">="|"=="|"!="|"<"|">"
SHORT_OP	"+="|"*="|"-="|"/="
INC			"++"|"--"

%{
	#include <stdio.h>
	#include "y.tab.h"
	int lineno = 1;
	int k;
	int ch;
	struct node{
		int type;
		char name[50];
		int dataType;
		struct node *next;
	}*list[100];
	int typecheck;
	
%}

%%

[\n]			lineno++;
[\t]			;
" "				;
;				{printf("Comma : %s\n",yytext); return COLON;}
#.*				{printf("Header : %s\n",yytext); return HEADER;}	
,				{printf("Comma : %s\n",yytext); return COMMA;}
int				{printf("Data Type : %s\n",yytext); typecheck=1; strcpy(yylval.string,"int"); return DATATYPE;}
float			{printf("Data Type : %s\n",yytext); typecheck=2; strcpy(yylval.string,"float"); return DATATYPE; }
return			{printf("Return : %s\n",yytext); return RETURN;}
if 				{printf("If statement : %s\n",yytext); return IF;}
else 			{printf("Else statement : %s\n",yytext); return ELSE;}
for 			{printf("For : %s\n",yytext); return FOR;}
printf\(\"(.)*\"(,|"&"|.)*\)	{
									printf("Printf : %s\n",yytext);
									addTable(yytext,3);
									return PRINTF;
								}
scanf\(\"(.*)\"(,|"&"|.)*\)	{
								printf("Scanf : %s\n",yytext); 
								addTable(yytext,4);
								return SCANF;
							}
\"(.*)\"		{printf("String : %s\n",yytext); return STRING;}
"(" 			{printf("Bracket : %s\n",yytext); return BRACKET;}
")"				{printf("Bracket : %s\n",yytext); return BRACKET;}
"{" 			{printf("Curly Bracket : %s\n",yytext); return CBRACKET;}
"}"				{printf("Curly Bracket : %s\n",yytext); return CBRACKET;}
"="				{printf("Equals : %s\n",yytext); return EQUALS;}
"+"				{printf("Plus : %s\n",yytext); return '+';}
"-"				{printf("Minus : %s\n",yytext); return '-';}
"/"				{printf("Divide : %s\n",yytext); return '/';}
"*"				{printf("Multiply : %s\n",yytext); return '*';}

{INC}			{printf("Increment Operator : %s\n",yytext); strcpy(yylval.string,yytext); return INCR;}
{SHORT_OP}		{printf("Shorthand Operator : %s\n",yytext); strcpy(yylval.string,yytext); return SHORTOP;}
{COND_OP}		{printf("Conditional Operator : %s\n",yytext);strcpy(yylval.string,yytext); return CONOP;}
"&"				{printf("Ampersand : %s\n",yytext); return AMPERSAND;}
({ALPHA}|_)({ALPHA}|{NUM}|_)*"()"	{	printf("Function : %s\n",yytext); 
									addTable(yytext,2);
									yylval.both.val = 0;
									strcpy(yylval.both.name, yytext) ; 
									return FUNCT;
								}

({ALPHA}|_)({ALPHA}|{NUM}|_)*	{	printf("Identifier : %s\n",yytext); 
									addTable(yytext,1);
									yylval.both.val = 0 ; 
									strcpy(yylval.both.name,yytext);	
									return IDENT;
								}	
\/\/(.*)						{printf("Single line comment : %s\n",yytext); return SINGLECOMMENT;}
\/\*(.|[\n])*\*\/				{printf("Multi line comment : %s\n",yytext); return MULTICOMMENT;}


{NUM}*			{printf("Digits : %s\n",yytext); yylval.dval = atoi(yytext);  return DIGIT;}

%%

void yyerror(char* str){
	printf("\n%s at line number %d\nTEXT : %s\n",str,lineno,yytext);
}

char gencode(char ch1,char first,char op,char second){
	printf("\n\t\t\t\tICG: _t%d = %d %c %d\n",ch,first,op,second);
	return ch++;
}

char * getType(int i){

	if(i == 1)
		return "Identifier";
	else if (i == 2)
		return "Function";
	else if (i == 3) //for printf
		return "Function";
	else if (i == 4) //for scanf	
		return "Function";		

}

char * getDataType(int i){

	if(i == 1)
		return "int";
	else if(i == 2)
		return "float";
	else if(i == -1)
		return "none";	
			
}

int addTable(char *text, int type){

	if(lookup(text) != -1)	return 0;

	struct node* new = (struct node*) malloc(sizeof(struct node));
	new->type = type;

	if(type == 1 | type == 2)
		strcpy(new->name, text);
	else if (type == 3)
		strcpy(new->name, "printf()");
	else if (type == 4)	
		strcpy(new->name, "scanf()");

	if(type == 1)
		new->dataType = typecheck;
	else
		new->dataType = -1;

	list[k++] = new;
	
	//printf("\t\t\t\t From this %s and %d\n",this->name, this->type);
	
	return 0;
}

int print_symbols(){
	int i;
	struct node* temp = (struct node*) malloc(sizeof(struct node));
	printf("The Entries in the symbol table are :\n\n");
	printf("Name\t\tType\t\t\tDataType\t\t\n");
	printf("_______________________________________________\n");
	for(i=0;i<k;i++){
		temp = (struct node*) list[i];
		if(strlen(temp->name)<=7)
			printf("%s\t\t%s\t\t%s\t\t\n",temp->name, getType(temp->type), getDataType(temp->dataType));
		else 
			printf("%s\t%s\t\t%s\t\t\n",temp->name, getType(temp->type), getDataType(temp->dataType));
	}
	printf("\n\n");

	return 0;
}

int lookup(char * str){
	int i;
	struct node* temp = (struct node*) malloc(sizeof(struct node));
	for(i=0;i<k;i++){
		temp = (struct node*) list[i];
		if(strcmp(temp->name,str) == 0){
			return temp->dataType;
		}
	}

	return -1;
}

int main(int argc, char *argv[]){

	if(argc == 2){
		yyin = fopen(argv[1],"r");
	}
	yyparse();

	print_symbols();

	return 0;
}

int yywrap(){
	return 1;
}
