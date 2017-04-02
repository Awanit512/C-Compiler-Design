/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    HEADER = 258,
    BRACKET = 259,
    CBRACKET = 260,
    COLON = 261,
    PLUS = 262,
    RETURN = 263,
    COMMA = 264,
    PRINTF = 265,
    SCANF = 266,
    EQUALS = 267,
    STRING = 268,
    AMPERSAND = 269,
    SINGLECOMMENT = 270,
    MULTICOMMENT = 271,
    IF = 272,
    ELSE = 273,
    FOR = 274,
    INCR = 275,
    SHORTOP = 276,
    DATATYPE = 277,
    IDENT = 278,
    FUNCT = 279,
    DIGIT = 280,
    CONOP = 281
  };
#endif
/* Tokens.  */
#define HEADER 258
#define BRACKET 259
#define CBRACKET 260
#define COLON 261
#define PLUS 262
#define RETURN 263
#define COMMA 264
#define PRINTF 265
#define SCANF 266
#define EQUALS 267
#define STRING 268
#define AMPERSAND 269
#define SINGLECOMMENT 270
#define MULTICOMMENT 271
#define IF 272
#define ELSE 273
#define FOR 274
#define INCR 275
#define SHORTOP 276
#define DATATYPE 277
#define IDENT 278
#define FUNCT 279
#define DIGIT 280
#define CONOP 281

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 13 "icodegen.y" /* yacc.c:1909  */

	int dval;
	char string[10];

	struct block {
		int val;
		char name[10];
	}both;

#line 116 "y.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
