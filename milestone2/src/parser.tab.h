/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
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
    PLUSEQUAL = 258,
    MINEQUAL = 259,
    STAREQUAL = 260,
    SLASHEQUAL = 261,
    PERCENTEQUAL = 262,
    AMPEREQUAL = 263,
    VBAREQUAL = 264,
    CIRCUMFLEXEQUAL = 265,
    LEFTSHIFTEQUAL = 266,
    RIGHTSHIFTEQUAL = 267,
    DOUBLESTAREQUAL = 268,
    DOUBLESLASHEQUAL = 269,
    DOUBLESLASH = 270,
    DOUBLESTAR = 271,
    NUMBER = 272,
    STRING = 273,
    NONE = 274,
    TRUE = 275,
    FALSE = 276,
    NEWLINE = 277,
    ARROW = 278,
    DEF = 279,
    NAME = 280,
    BREAK = 281,
    CONTINUE = 282,
    RETURN = 283,
    GLOBAL = 284,
    IF = 285,
    WHILE = 286,
    FOR = 287,
    ELSE = 288,
    ELIF = 289,
    INDENT = 290,
    DEDENT = 291,
    AND = 292,
    OR = 293,
    NOT = 294,
    LESSTHAN = 295,
    GREATERTHAN = 296,
    DOUBLEEQUAL = 297,
    GREATERTHANEQUAL = 298,
    LESSTHANEQUAL = 299,
    NOTEQUAL = 300,
    IN = 301,
    IS = 302,
    LEFTSHIFT = 303,
    RIGHTSHIFT = 304,
    CLASS = 305
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 49 "parser.y"
 char tokenname[1024]; 

#line 111 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
