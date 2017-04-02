%{
	#include<stdio.h>
	int val;
	extern int ch;
	int place = 2;
	int iter = 0;
	int stackvar = 0;
	int hash[149];
	int scopestack[20];
	int funcval[200];
%}

%union{
	int dval;
	char string[10];

	struct block {
		int val;
		char name[10];
	}both;
}

%token HEADER BRACKET CBRACKET COLON PLUS RETURN COMMA PRINTF SCANF EQUALS
%token STRING AMPERSAND SINGLECOMMENT MULTICOMMENT IF ELSE FOR INCR SHORTOP 
%token <string> DATATYPE 
%token <both> IDENT
%token <both> FUNCT
%token <dval> DIGIT
%token <string> CONOP
%left '+' '-' '*' '/'
//%type <dval> assigndigit
%type <dval> assign
%type <dval> E
%type <dval> simplestmt
%type <dval> increment
%type <dval> func
%type <dval> compstmt
%type <dval> lines
%type <dval> declr


%start open

%%
open : head func open {printf("\n\nCompilation Successful!!\n\n");}
	| func
	;

head : HEADER
	{
		scopestack[stackvar++] = 1;
	}
	;

func: DATATYPE FUNCT compstmt func
	{
		funcval[$2.name[0]] = $3;
		$$ = $3;
	}
	| lines
	;

compstmt: CBRACKET lines CBRACKET
	{
		$$ = $2;
	}
	; 

elsecompstmt: CBRACKET lines CBRACKET; 

lines: /*epsilon*/ 
	| declr COLON lines 							// int a; int a = 1; int a=a+b;
	{
		$$ = $1;
	}
	| IDENT BRACKET string BRACKET COLON lines		// function call : printf(); scanf();
	| SINGLECOMMENT lines							// comment
	| FUNCT COLON lines								// main();
	{
		$$ = $1.val;
	}
	| PRINTF COLON lines							// printf();
	| SCANF COLON lines								// scanf();
	| MULTICOMMENT lines							// multicomment
	| conditional lines								// if else for
	| RETURN E COLON 								// return 0;
	{
		printf("\t\t\t\tICG: RETURN VALUE : %d\n",$2);
		$$ = $2;
	}
	;

conditional : IF BRACKET expr BRACKET compstmt ELSE elsecompstmt 	//if(..){} else{}
	{
		printf("\t\t\t\tICG: RETURN TO %d\n",scopestack[--stackvar-1]);
	}
	| IF BRACKET expr BRACKET compstmt 							//if(..){}
	{
		printf("\t\t\t\tICG: RETURN TO %d\n",scopestack[--stackvar-1]);
	}
	| FOR forstmt compstmt
	{
		printf("\t\t\t\tICG: RETURN TO %d\n",scopestack[--stackvar-1]);
	}

	;

forstmt: BRACKET assign COLON forexpr COLON increment BRACKET 
	
forexpr : simplestmt CONOP simplestmt 
	{
		printf("\t\t\t\tICG: IF %d %s %d : GOTO %d \n",$1,$2,$3,place++);
	}
	;


increment : IDENT INCR 	{printf("\t\t\t\tICG: %s = %s + 1: \n",$1.name,$1.name);
						$$ = hash[$1.name[0]];}
	| INCR IDENT		{printf("\t\t\t\tICG: %s = %s + 1: \n",$2.name,$2.name);
						$$ = hash[$2.name[0]];}
	;

expr : simplestmt CONOP simplestmt			// n<0;	a+b<=c+d;
	{
		scopestack[stackvar++] = place;
		printf("\t\t\t\tICG: IF %d %s %d : GOTO %d \n",$1,$2,$3,place++);
	}
	;

simplestmt : IDENT {$$ = hash[$1.name[0]];}	// a
	| E 			{$$ = $1;}
	| DIGIT			{$$ = $1;}  // 5
	;

string : /*epsilon*/;
	| COMMA multipleDeclr
	;

declr: DATATYPE multipleDeclr	//int a, ~
	| DATATYPE assign			//int a = a + b
	| assign 
	{
		$$ = $1;
	}
	;	

multipleDeclr: IDENT 				//a
	| IDENT COMMA multipleDeclr		//a, ~
	;

assign:	IDENT EQUALS E 	// a = 3; a = a + b;
	{	$1.val = $3;
		$$ = $3;
		hash[$1.name[0]] = $3; 
		printf("\t\t\t\tICG: %s = %d\n",$1.name, $3);
	}
	| IDENT EQUALS FUNCT
	{
		$$ = funcval[$3.name[0]];
		printf("\t\t\t\tICG:FUNC RET VAL %s = %d\n",$1.name, funcval[$3.name[0]]);
		$1.val = funcval[$3.name[0]];
	}
	;

E : E '+' E {$$ = $1 + $3; gencode($$,$1,'+',$3);}
  | E '-' E {$$ = $1 - $3; gencode($$,$1,'-',$3);}
  | E '*' E {$$ = $1 * $3; gencode($$,$1,'*',$3);}
  | E '/' E {$$ = $1 / $3; gencode($$,$1,'/',$3);}
  | BRACKET E BRACKET {$$=$2;}
  | IDENT {if(hash[$1.name[0]]!=0) $$=hash[$1.name[0]];}
  | DIGIT {$$=$1;}
  ;

%%
