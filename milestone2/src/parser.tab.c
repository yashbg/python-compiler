/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "parser.y"

  #include <iostream>
  #include <string>
  #include <vector>
  #include <map>
  #include <utility>
  #include <cstring>
  #include <cstdlib>
  #include <fstream>
  #include "symtable.h"

  extern int yylex();
  extern int yylineno;
  extern char* yytext;
  extern std::ofstream outfile;
  extern std::ofstream parser_logfile;

  void yyerror(const char *);

  std::map<std::string, int> node_map;
  int comma_number = 1;
  std::string s1, s2;

  bool global_scope = true;
  global_symtable gsymtable;
  local_symtable *cur_symtable_ptr = nullptr;

  std::vector<std::vector<std::string>> ac3_code; // 3AC instructions
  long int temp_count = 0; // counter for temporary variables
  std::string new_temp(); // generate new temporary variable

  int offset = 0; // TODO
  std::string var_type;
  std::string func_param_type;
  std::vector<std::pair<std::string, std::string>> func_params; // (name, type)
  std::string func_return_type;

  int is_digit(char c);

  void emit_dot_node(const char* node_name, const char* label);
  void emit_dot_edge(const char* from, const char* to);

  void gen(const char* op, const char* arg1, const char* arg2, const char* result); //gen function for 3AC

  std::string get_sem_val(char *c_str); // get semantic value from AST node
  int get_size(const std::string &type);

#line 118 "parser.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
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

#line 224 "parser.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */



#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_int16 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   425

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  69
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  102
/* YYNRULES -- Number of rules.  */
#define YYNRULES  196
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  281

#define YYUNDEFTOK  2
#define YYMAXUTOK   305


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,    65,    67,     2,
      55,    56,    63,    60,    51,    61,    52,    64,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    54,    53,
       2,    59,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    57,     2,    58,    66,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    68,     2,    62,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,    68,    68,    75,    80,    88,    93,   107,   106,   153,
     158,   172,   189,   194,   202,   237,   262,   267,   277,   282,
     293,   298,   343,   348,   361,   366,   374,   379,   387,   401,
     406,   423,   428,   433,   441,   449,   457,   472,   480,   485,
     499,   521,   535,   540,   548,   553,   571,   576,   581,   586,
     591,   596,   601,   606,   611,   616,   621,   626,   636,   641,
     646,   654,   666,   678,   692,   697,   705,   727,   732,   755,
     760,   765,   770,   775,   783,   815,   835,   863,   868,   884,
     889,   911,   916,   934,   939,   957,   972,   977,   988,   996,
    1013,  1018,  1033,  1049,  1054,  1069,  1078,  1086,  1112,  1117,
    1138,  1143,  1148,  1153,  1158,  1163,  1168,  1176,  1191,  1207,
    1212,  1230,  1247,  1252,  1270,  1287,  1292,  1310,  1324,  1329,
    1337,  1342,  1360,  1375,  1380,  1388,  1393,  1412,  1426,  1431,
    1436,  1441,  1449,  1454,  1472,  1485,  1493,  1498,  1503,  1511,
    1525,  1530,  1546,  1557,  1562,  1577,  1590,  1602,  1612,  1625,
    1644,  1652,  1660,  1671,  1676,  1701,  1706,  1714,  1731,  1736,
    1744,  1755,  1766,  1785,  1790,  1798,  1812,  1817,  1832,  1837,
    1855,  1860,  1868,  1882,  1887,  1903,  1908,  1916,  1930,  1935,
    1951,  1992,  1997,  2010,  2024,  2029,  2057,  2067,  2078,  2091,
    2096,  2104,  2109,  2117,  2139,  2155,  2160
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "PLUSEQUAL", "MINEQUAL", "STAREQUAL",
  "SLASHEQUAL", "PERCENTEQUAL", "AMPEREQUAL", "VBAREQUAL",
  "CIRCUMFLEXEQUAL", "LEFTSHIFTEQUAL", "RIGHTSHIFTEQUAL",
  "DOUBLESTAREQUAL", "DOUBLESLASHEQUAL", "DOUBLESLASH", "DOUBLESTAR",
  "NUMBER", "STRING", "NONE", "TRUE", "FALSE", "NEWLINE", "ARROW", "DEF",
  "NAME", "BREAK", "CONTINUE", "RETURN", "GLOBAL", "IF", "WHILE", "FOR",
  "ELSE", "ELIF", "INDENT", "DEDENT", "AND", "OR", "NOT", "LESSTHAN",
  "GREATERTHAN", "DOUBLEEQUAL", "GREATERTHANEQUAL", "LESSTHANEQUAL",
  "NOTEQUAL", "IN", "IS", "LEFTSHIFT", "RIGHTSHIFT", "CLASS", "','", "'.'",
  "';'", "':'", "'('", "')'", "'['", "']'", "'='", "'+'", "'-'", "'~'",
  "'*'", "'/'", "'%'", "'^'", "'&'", "'|'", "$accept", "file_input",
  "newline_or_stmt", "newline_or_stmt_list", "funcdef", "$@1",
  "arrow_test_opt", "parameters", "typedargslist_opt", "typedargslist",
  "tfpdef", "comma_opt", "equal_test_opt",
  "comma_tfpdef_equal_test_opt_list", "colon_test_opt", "stmt",
  "semicolon_opt", "simple_stmt", "semicolon_small_stmt_list",
  "small_stmt", "expr_stmt", "expr_stmt_suffix_choices",
  "equal_testlist_star_expr_list", "annassign", "testlist_star_expr",
  "test_or_star_expr", "comma_test_or_star_expr_list", "augassign",
  "flow_stmt", "break_stmt", "continue_stmt", "return_stmt",
  "testlist_opt", "global_stmt", "comma_name_list", "compound_stmt",
  "if_stmt", "while_stmt", "for_stmt", "else_colon_suite_opt",
  "elif_test_colon_suite_list", "suite", "stmt_list", "test",
  "if_or_test_else_test_opt", "test_nocond", "or_test", "or_and_test_list",
  "and_test", "and_not_test_list", "not_test", "comparison",
  "comp_op_expr_list", "comp_op", "star_expr", "expr", "or_xor_expr_list",
  "xor_expr", "xor_and_expr_list", "and_expr", "and_shift_expr_list",
  "shift_expr", "ltshift_or_rtshift", "shift_arith_expr_list",
  "arith_expr", "plus_or_minus", "plus_or_minus_term_list", "term",
  "star_or_slash_or_percent_or_doubleslash",
  "star_or_slash_or_percent_or_doubleslash_factor_list", "factor",
  "plus_or_minus_or_tilde", "power", "doublestar_factor_opt", "atom_expr",
  "trailer_list", "atom", "string_list", "testlist_comp_opt",
  "testlist_comp", "comp_for_OR_comma_test_or_star_expr_list_comma_opt",
  "trailer", "arglist_opt", "subscriptlist", "comma_subscript_list",
  "subscript", "test_opt", "exprlist", "comma_expr_or_star_expr_list",
  "expr_or_star_expr", "testlist", "comma_test_list", "classdef",
  "parenthesis_arglist_opt_opt", "arglist", "comma_argument_list",
  "argument", "comp_for_opt", "comp_iter", "comp_for", "comp_if",
  "comp_iter_opt", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,    44,    46,    59,    58,    40,    41,    91,    93,    61,
      43,    45,   126,    42,    47,    37,    94,    38,   124
};
# endif

#define YYPACT_NINF (-208)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-172)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -208,    47,   226,  -208,  -208,  -208,  -208,  -208,  -208,  -208,
      30,  -208,  -208,  -208,   363,    49,   363,   363,    44,   363,
      52,   307,   307,  -208,  -208,  -208,    18,  -208,  -208,  -208,
    -208,  -208,  -208,    17,  -208,  -208,  -208,  -208,  -208,  -208,
    -208,  -208,  -208,  -208,  -208,    38,  -208,  -208,  -208,  -208,
    -208,  -208,  -208,  -208,  -208,  -208,  -208,    18,  -208,    71,
    -208,  -208,    79,    48,  -208,  -208,  -208,  -208,    54,    56,
    -208,  -208,    66,  -208,  -208,    60,    70,    64,  -208,    63,
    -208,    69,  -208,  -208,  -208,  -208,  -208,  -208,  -208,  -208,
    -208,  -208,  -208,  -208,   363,  -208,    65,  -208,   363,    72,
     363,  -208,    87,    92,    99,    62,    68,    85,   -16,    29,
      19,  -208,    18,  -208,    43,  -208,   107,   113,    95,   112,
      31,    31,   363,   114,   316,   110,    44,    72,  -208,  -208,
    -208,  -208,   130,   144,   108,   307,  -208,   307,  -208,   137,
     363,   363,  -208,  -208,  -208,  -208,  -208,  -208,  -208,    18,
      18,    18,    18,  -208,  -208,    18,  -208,  -208,    18,  -208,
    -208,  -208,  -208,    18,  -208,   149,   316,   363,  -208,   126,
     125,  -208,   108,   363,   134,   363,  -208,   159,   154,  -208,
    -208,   161,   141,    44,  -208,   363,   -15,   140,  -208,  -208,
      31,   152,  -208,  -208,  -208,   363,  -208,  -208,  -208,   363,
    -208,  -208,  -208,  -208,  -208,  -208,  -208,  -208,  -208,  -208,
     143,   146,   145,  -208,   147,   363,  -208,  -208,  -208,  -208,
    -208,  -208,  -208,   290,    12,   150,  -208,    31,  -208,  -208,
     363,  -208,  -208,  -208,   155,  -208,   363,  -208,  -208,  -208,
    -208,   156,   363,  -208,   157,    31,  -208,   363,  -208,    31,
     161,  -208,   316,  -208,    10,   158,  -208,  -208,  -208,   107,
    -208,   243,   151,  -208,  -208,  -208,   363,  -208,  -208,  -208,
    -208,  -208,   108,  -208,  -208,    31,    10,  -208,  -208,  -208,
    -208
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       5,     0,     2,     1,   148,   153,   150,   151,   152,     3,
       0,   147,    61,    62,    64,     0,     0,     0,     0,     0,
       0,   155,   155,   136,   137,   138,     0,     6,    72,     4,
      24,    29,    31,    38,    44,    32,    58,    59,    60,    33,
      25,    69,    70,    71,    42,    86,    90,    93,    96,    43,
      98,   109,   112,   115,   120,   125,   132,     0,   135,   140,
     143,    73,   149,     0,    63,   178,    65,    67,     0,     0,
     176,   175,     0,   173,    95,   181,    44,     0,   156,     0,
     107,    26,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    55,    56,    57,     0,    36,    37,    34,     0,    16,
       0,    85,    89,    92,    97,   108,   111,   114,   117,   122,
     127,   134,     0,   139,   142,   154,    12,     9,    16,    66,
       0,     0,     0,    16,   163,     0,     0,    16,   157,   158,
     145,   146,    27,     0,    18,     0,    35,    17,    41,     0,
       0,     0,   100,   101,   102,   103,   104,   105,   106,     0,
       0,     0,     0,   118,   119,     0,   123,   124,     0,   131,
     128,   129,   130,     0,   141,     0,   163,   170,   144,    22,
       0,    13,    18,     0,     0,    17,   177,     0,     0,    81,
      79,    77,     0,    17,   172,     0,   189,     0,   164,   184,
       0,     0,   159,    30,    28,     0,    40,    39,    45,     0,
      91,    94,    99,   110,   113,   116,   121,   126,   133,   162,
       0,   168,     0,   166,     0,     0,    15,    11,    20,    10,
       7,   179,    68,     0,    77,     0,    75,     0,   174,   188,
       0,   186,   190,   182,    16,   180,     0,    19,    87,   160,
     161,    16,   170,    23,    14,     0,    83,     0,    74,     0,
      77,   187,    17,   183,   195,    17,   165,   171,   169,     0,
       8,     0,     0,    78,    76,   185,     0,   196,   191,   192,
     193,   167,    18,    82,    84,     0,   195,    88,    21,    80,
     194
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -208,  -208,  -208,  -208,  -208,  -208,  -208,  -208,  -208,  -208,
     -50,  -108,  -154,  -208,  -208,  -207,  -208,    -2,  -208,    78,
    -208,  -208,  -208,  -208,    76,    -9,   138,  -208,  -208,  -208,
    -208,  -208,  -208,  -208,  -208,  -208,  -208,  -208,  -208,  -183,
    -208,  -114,  -208,   -13,  -208,  -208,   -98,  -208,    82,  -208,
     -14,  -208,  -208,  -208,   -10,   -12,  -208,    73,  -208,    74,
    -208,    75,  -208,  -208,    61,  -208,  -208,    77,  -208,  -208,
     -46,  -208,  -208,  -208,  -208,  -208,  -208,  -208,   202,  -208,
    -208,  -208,    67,  -208,  -208,   -29,   -11,   102,  -208,    53,
     -26,  -208,  -208,  -208,  -208,  -208,   -22,  -208,  -208,   -67,
    -208,   -44
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,    27,     2,    28,   245,   174,   117,   170,   171,
     172,   138,   196,   244,   216,    29,   133,   179,    81,    31,
      32,    95,    96,    97,    33,    34,    99,    98,    35,    36,
      37,    38,    64,    39,   119,    40,    41,    42,    43,   226,
     224,   180,   261,    44,   101,   276,    45,   102,    46,   103,
      47,    48,   104,   149,    49,    50,   105,    51,   106,    52,
     107,    53,   155,   108,    54,   158,   109,    55,   163,   110,
      56,    57,    58,   113,    59,   114,    60,    62,    77,    78,
     128,   168,   187,   212,   241,   213,   214,    72,   123,    73,
      66,   118,    61,   125,   188,   234,   189,   231,   267,   268,
     269,   270
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      30,    65,   139,    68,    69,    74,    71,   181,    70,   129,
     176,   111,    76,    76,    80,   184,   246,   126,   218,   192,
      82,    83,    84,    85,    86,    87,    88,    89,    90,    91,
      92,    93,   153,   154,   159,     4,     5,     6,     7,     8,
     266,   248,   126,    11,   230,   225,   247,     3,     4,     5,
       6,     7,     8,   178,   274,    63,    11,    12,    13,    14,
      15,     4,     5,     6,     7,     8,   164,   264,   100,    11,
      19,    94,   136,    21,    67,    22,   235,    75,    23,    24,
      25,   134,   160,   161,   162,    65,    21,   112,    22,   156,
     157,    23,    24,    25,    26,   165,   182,   115,   166,    21,
     167,    22,   126,   116,    23,    24,    25,    26,   120,    65,
     121,   186,   122,   250,    71,   124,    70,   208,   278,   232,
     130,   131,   132,   137,   135,   140,   253,   201,   198,   141,
     150,   260,   169,   256,   151,   263,   173,   202,   254,   142,
     143,   144,   145,   146,   147,   148,   175,     4,     5,     6,
       7,     8,   152,   186,   211,    11,    12,    13,    14,    15,
     219,   279,   221,   177,   190,   183,   194,   195,   277,    19,
     199,    71,   229,    70,   209,     4,     5,     6,     7,     8,
     215,   217,   237,    11,   222,    21,   238,    22,   220,   223,
      23,    24,    25,    26,   225,   227,   233,    19,   236,   239,
    -171,   242,   243,   240,   249,   275,   252,   255,   259,   272,
     193,   197,  -170,    21,   127,    22,   206,   251,    23,    24,
      25,    30,   200,   203,    79,   204,   271,   205,   191,   257,
     265,   258,   280,   210,   262,   207,   228,     0,     0,   186,
       0,     0,   211,     4,     5,     6,     7,     8,     9,     0,
      10,    11,    12,    13,    14,    15,    16,    17,    18,    30,
       4,     5,     6,     7,     8,    19,     0,    10,    11,    12,
      13,    14,    15,    16,    17,    18,    20,     0,     0,   273,
       0,    21,    19,    22,     0,     0,    23,    24,    25,    26,
       0,     0,     0,    20,     0,     0,     0,     0,    21,     0,
      22,     0,     0,    23,    24,    25,    26,     4,     5,     6,
       7,     8,     0,     0,    10,    11,    12,    13,    14,    15,
      16,    17,    18,     0,     4,     5,     6,     7,     8,    19,
       0,     0,    11,     4,     5,     6,     7,     8,     0,     0,
      20,    11,     0,     0,     0,    21,    19,    22,     0,     0,
      23,    24,    25,    26,     0,    19,     0,     0,     0,     0,
       0,     0,    21,     0,    22,     0,     0,    23,    24,    25,
      26,    21,     0,    22,     0,     0,    23,    24,    25,   185,
       4,     5,     6,     7,     8,     0,     0,     0,    11,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    19,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    21,     0,
      22,     0,     0,    23,    24,    25
};

static const yytype_int16 yycheck[] =
{
       2,    14,   100,    16,    17,    19,    18,   121,    18,    76,
     118,    57,    21,    22,    26,   123,   223,    32,   172,   127,
       3,     4,     5,     6,     7,     8,     9,    10,    11,    12,
      13,    14,    48,    49,    15,    17,    18,    19,    20,    21,
      30,   224,    32,    25,    59,    33,    34,     0,    17,    18,
      19,    20,    21,    22,   261,    25,    25,    26,    27,    28,
      29,    17,    18,    19,    20,    21,   112,   250,    30,    25,
      39,    54,    98,    55,    25,    57,   190,    25,    60,    61,
      62,    94,    63,    64,    65,    98,    55,    16,    57,    60,
      61,    60,    61,    62,    63,    52,   122,    18,    55,    55,
      57,    57,    32,    55,    60,    61,    62,    63,    54,   122,
      54,   124,    46,   227,   126,    55,   126,   163,   272,   186,
      56,    58,    53,    51,    59,    38,   234,   141,   137,    37,
      68,   245,    25,   241,    66,   249,    23,   149,   236,    40,
      41,    42,    43,    44,    45,    46,    51,    17,    18,    19,
      20,    21,    67,   166,   167,    25,    26,    27,    28,    29,
     173,   275,   175,    51,    54,    51,    22,    59,   266,    39,
      33,   183,   185,   183,    25,    17,    18,    19,    20,    21,
      54,    56,   195,    25,    25,    55,   199,    57,    54,    35,
      60,    61,    62,    63,    33,    54,    56,    39,    46,    56,
      54,    54,   215,    58,    54,    54,    51,    51,    51,   259,
     132,   135,    54,    55,    76,    57,   155,   230,    60,    61,
      62,   223,   140,   150,    22,   151,   255,   152,   126,   242,
     252,   242,   276,   166,   247,   158,   183,    -1,    -1,   252,
      -1,    -1,   255,    17,    18,    19,    20,    21,    22,    -1,
      24,    25,    26,    27,    28,    29,    30,    31,    32,   261,
      17,    18,    19,    20,    21,    39,    -1,    24,    25,    26,
      27,    28,    29,    30,    31,    32,    50,    -1,    -1,    36,
      -1,    55,    39,    57,    -1,    -1,    60,    61,    62,    63,
      -1,    -1,    -1,    50,    -1,    -1,    -1,    -1,    55,    -1,
      57,    -1,    -1,    60,    61,    62,    63,    17,    18,    19,
      20,    21,    -1,    -1,    24,    25,    26,    27,    28,    29,
      30,    31,    32,    -1,    17,    18,    19,    20,    21,    39,
      -1,    -1,    25,    17,    18,    19,    20,    21,    -1,    -1,
      50,    25,    -1,    -1,    -1,    55,    39,    57,    -1,    -1,
      60,    61,    62,    63,    -1,    39,    -1,    -1,    -1,    -1,
      -1,    -1,    55,    -1,    57,    -1,    -1,    60,    61,    62,
      63,    55,    -1,    57,    -1,    -1,    60,    61,    62,    63,
      17,    18,    19,    20,    21,    -1,    -1,    -1,    25,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    39,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    55,    -1,
      57,    -1,    -1,    60,    61,    62
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    70,    72,     0,    17,    18,    19,    20,    21,    22,
      24,    25,    26,    27,    28,    29,    30,    31,    32,    39,
      50,    55,    57,    60,    61,    62,    63,    71,    73,    84,
      86,    88,    89,    93,    94,    97,    98,    99,   100,   102,
     104,   105,   106,   107,   112,   115,   117,   119,   120,   123,
     124,   126,   128,   130,   133,   136,   139,   140,   141,   143,
     145,   161,   146,    25,   101,   112,   159,    25,   112,   112,
     123,   124,   156,   158,   119,    25,    94,   147,   148,   147,
     124,    87,     3,     4,     5,     6,     7,     8,     9,    10,
      11,    12,    13,    14,    54,    90,    91,    92,    96,    95,
      30,   113,   116,   118,   121,   125,   127,   129,   132,   135,
     138,   139,    16,   142,   144,    18,    55,    76,   160,   103,
      54,    54,    46,   157,    55,   162,    32,    95,   149,   168,
      56,    58,    53,    85,   112,    59,   159,    51,    80,   115,
      38,    37,    40,    41,    42,    43,    44,    45,    46,   122,
      68,    66,    67,    48,    49,   131,    60,    61,   134,    15,
      63,    64,    65,   137,   139,    52,    55,    57,   150,    25,
      77,    78,    79,    23,    75,    51,    80,    51,    22,    86,
     110,   110,   159,    51,    80,    63,   112,   151,   163,   165,
      54,   156,    80,    88,    22,    59,    81,    93,    94,    33,
     117,   119,   124,   126,   128,   130,   133,   136,   139,    25,
     151,   112,   152,   154,   155,    54,    83,    56,    81,   112,
      54,   112,    25,    35,   109,    33,   108,    54,   158,   112,
      59,   166,   168,    56,   164,   110,    46,   112,   112,    56,
      58,   153,    54,   112,    82,    74,    84,    34,   108,    54,
     110,   112,    51,    80,   115,    51,    80,   112,   155,    51,
     110,   111,   112,   110,   108,   165,    30,   167,   168,   169,
     170,   154,    79,    36,    84,    54,   114,   115,    81,   110,
     170
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    69,    70,    71,    71,    72,    72,    74,    73,    75,
      75,    76,    77,    77,    78,    79,    80,    80,    81,    81,
      82,    82,    83,    83,    84,    84,    85,    85,    86,    87,
      87,    88,    88,    88,    89,    89,    89,    90,    91,    91,
      92,    93,    94,    94,    95,    95,    96,    96,    96,    96,
      96,    96,    96,    96,    96,    96,    96,    96,    97,    97,
      97,    98,    99,   100,   101,   101,   102,   103,   103,   104,
     104,   104,   104,   104,   105,   106,   107,   108,   108,   109,
     109,   110,   110,   111,   111,   112,   113,   113,   114,   115,
     116,   116,   117,   118,   118,   119,   119,   120,   121,   121,
     122,   122,   122,   122,   122,   122,   122,   123,   124,   125,
     125,   126,   127,   127,   128,   129,   129,   130,   131,   131,
     132,   132,   133,   134,   134,   135,   135,   136,   137,   137,
     137,   137,   138,   138,   139,   139,   140,   140,   140,   141,
     142,   142,   143,   144,   144,   145,   145,   145,   145,   145,
     145,   145,   145,   146,   146,   147,   147,   148,   149,   149,
     150,   150,   150,   151,   151,   152,   153,   153,   154,   154,
     155,   155,   156,   157,   157,   158,   158,   159,   160,   160,
     161,   162,   162,   163,   164,   164,   165,   165,   165,   166,
     166,   167,   167,   168,   169,   170,   170
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     1,     1,     0,     2,     0,     7,     0,
       2,     3,     0,     1,     3,     2,     0,     1,     0,     2,
       0,     4,     0,     2,     1,     1,     0,     1,     4,     0,
       3,     1,     1,     1,     2,     3,     2,     1,     0,     3,
       3,     3,     1,     1,     0,     3,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     2,     0,     1,     3,     0,     3,     1,
       1,     1,     1,     1,     6,     5,     7,     0,     3,     0,
       5,     1,     5,     0,     2,     2,     0,     4,     1,     2,
       0,     3,     2,     0,     3,     2,     1,     2,     0,     3,
       1,     1,     1,     1,     1,     1,     1,     2,     2,     0,
       3,     2,     0,     3,     2,     0,     3,     2,     1,     1,
       0,     3,     2,     1,     1,     0,     3,     2,     1,     1,
       1,     1,     0,     3,     2,     1,     1,     1,     1,     2,
       0,     2,     2,     0,     2,     3,     3,     1,     1,     2,
       1,     1,     1,     0,     2,     0,     1,     2,     1,     2,
       3,     3,     2,     0,     1,     3,     0,     3,     1,     3,
       0,     1,     3,     0,     3,     1,     1,     3,     0,     3,
       5,     0,     3,     3,     0,     3,     2,     3,     2,     0,
       1,     1,     1,     5,     3,     0,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2:
#line 69 "parser.y"
  {
    parser_logfile << "newline_or_stmt_list" << std::endl;
  }
#line 1682 "parser.tab.c"
    break;

  case 3:
#line 76 "parser.y"
  {
    parser_logfile << "NEWLINE" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 1691 "parser.tab.c"
    break;

  case 4:
#line 81 "parser.y"
  {
    parser_logfile << "| stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 1700 "parser.tab.c"
    break;

  case 5:
#line 89 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 1709 "parser.tab.c"
    break;

  case 6:
#line 94 "parser.y"
  {
    parser_logfile << "| newline_or_stmt_list newline_or_stmt" << std::endl;
    char str[5] = "Root";
    emit_dot_edge(str, (yyvsp[0].tokenname));
  }
#line 1719 "parser.tab.c"
    break;

  case 7:
#line 107 "parser.y"
  {
    add_func((yyvsp[-3].tokenname), func_params, func_return_type);
    func_params.clear();

    global_scope = false;
    cur_symtable_ptr = gsymtable.func_symtable_ptrs[(yyvsp[-3].tokenname)];
  }
#line 1731 "parser.tab.c"
    break;

  case 8:
#line 115 "parser.y"
  {
    parser_logfile << "DEF NAME parameters arrow_test_opt ':' suite" << std::endl;
    strcpy((yyval.tokenname), "NAME(");
    strcat((yyval.tokenname), (yyvsp[-5].tokenname));
    strcat((yyval.tokenname), ")");
    node_map[(yyvsp[-5].tokenname)]++;
    node_map["DEF"]++;

    s1 = "DEF" + std::to_string(node_map["DEF"]);
    s2 = (yyval.tokenname) + std::to_string(node_map[(yyvsp[-5].tokenname)]);
    emit_dot_edge(s1.c_str(), s2.c_str());

    s1 = (yyval.tokenname) + std::to_string(node_map[(yyvsp[-5].tokenname)]);
    emit_dot_edge(s1.c_str(), (yyvsp[-4].tokenname));

    node_map[":"]++;
    s1 = (yyvsp[-2].tokenname)+std::to_string(node_map[":"]);
    if((yyvsp[-3].tokenname)[0] != '\0'){
      s2 = "DEF"+std::to_string(node_map["DEF"]);
      emit_dot_edge((yyvsp[-3].tokenname), s2.c_str());
      emit_dot_edge(s1.c_str(), (yyvsp[-3].tokenname));
    }
    else {
      s2 = "DEF" + std::to_string(node_map["DEF"]);
      emit_dot_edge(s1.c_str(), s2.c_str());
    }

    emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));

    strcpy((yyval.tokenname), (yyvsp[-2].tokenname));
    std::string temp = std::to_string(node_map[":"]);
    strcat((yyval.tokenname), temp.c_str());

    global_scope = true;
  }
#line 1771 "parser.tab.c"
    break;

  case 9:
#line 154 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 1780 "parser.tab.c"
    break;

  case 10:
#line 159 "parser.y"
  {
    node_map["->"]++;
    parser_logfile << "| ARROW test" << std::endl;
    s1 = "->"+std::to_string(node_map["->"]);
    s2 = (yyvsp[0].tokenname);
    emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname),s1.c_str());

    func_return_type = get_sem_val((yyvsp[0].tokenname));
  }
#line 1795 "parser.tab.c"
    break;

  case 11:
#line 173 "parser.y"
  {
    parser_logfile << "'(' typedargslist_opt ')'" << std::endl;
    node_map["()"]++;

    if((yyvsp[-1].tokenname)[0] != '\0'){
      s1 = "()"+std::to_string(node_map["()"]);
      emit_dot_edge(s1.c_str(), (yyvsp[-1].tokenname));
    }

    strcpy((yyval.tokenname), "()");
    std::string temp = std::to_string(node_map["()"]);
    strcat((yyval.tokenname), temp.c_str());
  }
#line 1813 "parser.tab.c"
    break;

  case 12:
#line 190 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 1822 "parser.tab.c"
    break;

  case 13:
#line 195 "parser.y"
  {
    parser_logfile << "| typedargslist" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 1831 "parser.tab.c"
    break;

  case 14:
#line 203 "parser.y"
  {
    parser_logfile << "tfpdef equal_test_opt comma_tfpdef_equal_test_opt_list" << std::endl;
    if((yyvsp[-1].tokenname)[0] != '\0') {
      s1 = (yyvsp[-1].tokenname);
      s2 = (yyvsp[-2].tokenname);
      emit_dot_edge(s1.c_str(), s2.c_str());
    }

    if((yyvsp[0].tokenname)[0]!='\0')
    {
      if((yyvsp[-1].tokenname)[0] != '\0'){
        s1 = (yyvsp[0].tokenname);
        s2 =(yyvsp[-1].tokenname);
        emit_dot_edge((yyvsp[0].tokenname), s2.c_str());
        strcpy((yyval.tokenname), (yyvsp[0].tokenname));
      }
      else{
        emit_dot_edge((yyvsp[0].tokenname), (yyvsp[-2].tokenname));
        strcpy((yyval.tokenname), (yyvsp[0].tokenname));
      }
    }
    else
    {
      if((yyvsp[-1].tokenname)[0] != '\0'){
        strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
      }
      else{
        strcpy((yyval.tokenname), (yyvsp[-2].tokenname));
      }
    }
  }
#line 1867 "parser.tab.c"
    break;

  case 15:
#line 238 "parser.y"
  {
    node_map[(yyvsp[-1].tokenname)]++;
    s2 = "NAME(";
    s2 += (yyvsp[-1].tokenname);
    s2 += ")";
    s2 += std::to_string(node_map[(yyvsp[-1].tokenname)]);

    if((yyvsp[0].tokenname)[0] != '\0'){
      parser_logfile << "NAME colon_test_opt" << std::endl;
      strcpy((yyval.tokenname), ":");
      std::string temp = std::to_string(node_map[":"]);
      strcat((yyval.tokenname), temp.c_str());

      emit_dot_edge((yyvsp[0].tokenname), s2.c_str());
    }
    else {
      strcpy((yyval.tokenname), s2.c_str());
    }

    func_params.push_back({(yyvsp[-1].tokenname), func_param_type});
  }
#line 1893 "parser.tab.c"
    break;

  case 16:
#line 263 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 1902 "parser.tab.c"
    break;

  case 17:
#line 268 "parser.y"
  {
    parser_logfile << "| ','" << std::endl;
    node_map[","]++;
    s1 = "," + std::to_string(node_map[","]);
    strcpy((yyval.tokenname), s1.c_str());
  }
#line 1913 "parser.tab.c"
    break;

  case 18:
#line 278 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 1922 "parser.tab.c"
    break;

  case 19:
#line 283 "parser.y"
  {
    parser_logfile << "| '=' test" << std::endl;
    node_map["="]++;
    s1 = "="+std::to_string(node_map["="]);
    emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname), s1.c_str());
  }
#line 1934 "parser.tab.c"
    break;

  case 20:
#line 294 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 1943 "parser.tab.c"
    break;

  case 21:
#line 299 "parser.y"
  {
    parser_logfile << "| comma_tfpdef_equal_test_opt_list ',' tfpdef equal_test_opt" << std::endl;
    if((yyvsp[0].tokenname)[0] != '\0'){
      s1 = (yyvsp[0].tokenname);
      s2 = (yyvsp[-1].tokenname);
      emit_dot_edge(s1.c_str(), (yyvsp[-1].tokenname));
    }

    node_map[","]++;

    if((yyvsp[-3].tokenname)[0]!='\0')
    {
      if((yyvsp[0].tokenname)[0] != '\0'){
        s2 =(yyvsp[0].tokenname);
        emit_dot_edge((yyvsp[-3].tokenname), s2.c_str());
      }
      else{
        emit_dot_edge((yyvsp[-3].tokenname), (yyvsp[-1].tokenname));

      }
      s1 = ","+std::to_string(node_map[","]);
      emit_dot_edge(s1.c_str(), (yyvsp[-3].tokenname));
      strcpy((yyval.tokenname), ",");
      std::string temp = std::to_string(node_map[","]);
      strcat((yyval.tokenname), temp.c_str());
    }
    else{
      s1 = "," + std::to_string(node_map[","]);
      if((yyvsp[0].tokenname)[0] != '\0'){
        s2 = (yyvsp[0].tokenname);
      }
      else{
        s2 = (yyvsp[-1].tokenname);
      }
      emit_dot_edge(s1.c_str(), s2.c_str());

      strcpy((yyval.tokenname), ",");
      std::string temp = std::to_string(node_map[","]);
      strcat((yyval.tokenname), temp.c_str());
    }
  }
#line 1989 "parser.tab.c"
    break;

  case 22:
#line 344 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 1998 "parser.tab.c"
    break;

  case 23:
#line 349 "parser.y"
  {
    parser_logfile << "| ':' test" << std::endl;
    node_map[":"]++;
    s1 = ":"+std::to_string(node_map[":"]);
    emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname), s1.c_str());
    std::cout << (yyvsp[0].tokenname) << " " << std::endl;
    func_param_type = get_sem_val((yyvsp[0].tokenname));
  }
#line 2012 "parser.tab.c"
    break;

  case 24:
#line 362 "parser.y"
  {
    parser_logfile << "simple_stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2021 "parser.tab.c"
    break;

  case 25:
#line 367 "parser.y"
  {
    parser_logfile << "| compound_stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2030 "parser.tab.c"
    break;

  case 26:
#line 375 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2039 "parser.tab.c"
    break;

  case 27:
#line 380 "parser.y"
  {
    parser_logfile << "| ';'" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2048 "parser.tab.c"
    break;

  case 28:
#line 388 "parser.y"
  {
    parser_logfile << "small_stmt semicolon_small_stmt_list semicolon_opt NEWLINE" << std::endl;
    if((yyvsp[-2].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[-3].tokenname));
    }
    else{
        emit_dot_edge((yyvsp[-2].tokenname), (yyvsp[-3].tokenname));
        strcpy((yyval.tokenname), (yyvsp[-2].tokenname));
    }
  }
#line 2063 "parser.tab.c"
    break;

  case 29:
#line 402 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2072 "parser.tab.c"
    break;

  case 30:
#line 407 "parser.y"
  {
    parser_logfile << "| semicolon_small_stmt_list ';' small_stmt" << std::endl;
    if((yyvsp[-2].tokenname)[0] != '\0'){
      node_map[";"]++;
      s1 = ";"+std::to_string(node_map[";"]);
      emit_dot_edge(s1.c_str(), (yyvsp[-2].tokenname));
      emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));
      strcpy((yyval.tokenname), s1.c_str());
    }
    else{
      strcpy((yyval.tokenname), (yyvsp[0].tokenname));
    }
  }
#line 2090 "parser.tab.c"
    break;

  case 31:
#line 424 "parser.y"
  {
    parser_logfile << "expr_stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2099 "parser.tab.c"
    break;

  case 32:
#line 429 "parser.y"
  {
    parser_logfile << "| flow_stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2108 "parser.tab.c"
    break;

  case 33:
#line 434 "parser.y"
  {
    parser_logfile << "| global_stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2117 "parser.tab.c"
    break;

  case 34:
#line 442 "parser.y"
  {
    parser_logfile << "testlist_star_expr annassign" << std::endl;
    emit_dot_edge((yyvsp[0].tokenname), (yyvsp[-1].tokenname));
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));

    insert_var(get_sem_val((yyvsp[-1].tokenname)), {var_type, "", yylineno, get_size(var_type), offset}); // TODO
  }
#line 2129 "parser.tab.c"
    break;

  case 35:
#line 450 "parser.y"
  {
    parser_logfile << "| testlist_star_expr augassign testlist" << std::endl;
    s1 = (yyvsp[-1].tokenname);
    emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));
    emit_dot_edge(s1.c_str(), (yyvsp[-2].tokenname));
    strcpy((yyval.tokenname), s1.c_str());
  }
#line 2141 "parser.tab.c"
    break;

  case 36:
#line 458 "parser.y"
  {
    parser_logfile << "| testlist_star_expr expr_stmt_suffix_choices" << std::endl;
    if((yyvsp[0].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
    else{
      s1 = (yyvsp[0].tokenname);
      emit_dot_edge((yyvsp[0].tokenname), (yyvsp[-1].tokenname));
      strcpy((yyval.tokenname), (yyvsp[0].tokenname));
    }
  }
#line 2157 "parser.tab.c"
    break;

  case 37:
#line 473 "parser.y"
  {
    parser_logfile << "equal_testlist_star_expr_list" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2166 "parser.tab.c"
    break;

  case 38:
#line 481 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2175 "parser.tab.c"
    break;

  case 39:
#line 486 "parser.y"
  {
    parser_logfile << "| equal_testlist_star_expr_list '=' testlist_star_expr" << std::endl;
    node_map["="]++;
    s1 = "=" + std::to_string(node_map["="]);
    if((yyvsp[-2].tokenname)[0] != '\0'){
      emit_dot_edge(s1.c_str(), (yyvsp[-2].tokenname));
    }
    emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname), s1.c_str());
  }
#line 2190 "parser.tab.c"
    break;

  case 40:
#line 500 "parser.y"
  {
    parser_logfile << "':' test equal_test_opt" << std::endl;
    node_map[":"]++;
    s1 = ":" + std::to_string(node_map[":"]);
    emit_dot_edge(s1.c_str(), (yyvsp[-1].tokenname));

    s2 = ":" + std::to_string(node_map[":"]);

    if((yyvsp[0].tokenname)[0] != '\0'){
      emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));
      strcpy((yyval.tokenname), s1.c_str());
    }
    else{
      strcpy((yyval.tokenname), s2.c_str());
    }

    var_type = get_sem_val((yyvsp[-1].tokenname));
  }
#line 2213 "parser.tab.c"
    break;

  case 41:
#line 522 "parser.y"
  {
    parser_logfile << "test_or_star_expr comma_test_or_star_expr_list comma_opt" << std::endl;
    if((yyvsp[-1].tokenname)[0] != '\0'){
      emit_dot_edge((yyvsp[-1].tokenname), (yyvsp[-2].tokenname));
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
    else{
      strcpy((yyval.tokenname), (yyvsp[-2].tokenname));
    }
  }
#line 2228 "parser.tab.c"
    break;

  case 42:
#line 536 "parser.y"
  {
    parser_logfile << "test" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2237 "parser.tab.c"
    break;

  case 43:
#line 541 "parser.y"
  {
    parser_logfile << "| star_expr" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2246 "parser.tab.c"
    break;

  case 44:
#line 549 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2255 "parser.tab.c"
    break;

  case 45:
#line 554 "parser.y"
  {
    parser_logfile << "| comma_test_or_star_expr_list ',' test_or_star_expr" << std::endl;
    node_map[","]++;
    s1 = "," + std::to_string(node_map[","]);
    emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));
    if((yyvsp[-2].tokenname)[0] != '\0'){
      emit_dot_edge(s1.c_str(), (yyvsp[-2].tokenname));
      strcpy((yyval.tokenname), s1.c_str());
    }
    else{
      comma_number = node_map[","];
      strcpy((yyval.tokenname), s1.c_str());
    }
  }
#line 2274 "parser.tab.c"
    break;

  case 46:
#line 572 "parser.y"
  {
    parser_logfile << "PLUSEQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2283 "parser.tab.c"
    break;

  case 47:
#line 577 "parser.y"
  {
    parser_logfile << "| MINEQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2292 "parser.tab.c"
    break;

  case 48:
#line 582 "parser.y"
  {
    parser_logfile << "| STAREQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2301 "parser.tab.c"
    break;

  case 49:
#line 587 "parser.y"
  {
    parser_logfile << "| SLASHEQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2310 "parser.tab.c"
    break;

  case 50:
#line 592 "parser.y"
  {
    parser_logfile << "| PERCENTEQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2319 "parser.tab.c"
    break;

  case 51:
#line 597 "parser.y"
  {
    parser_logfile << "| AMPEREQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2328 "parser.tab.c"
    break;

  case 52:
#line 602 "parser.y"
  {
    parser_logfile << "| VBAREQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2337 "parser.tab.c"
    break;

  case 53:
#line 607 "parser.y"
  {
    parser_logfile << "| CIRCUMFLEXEQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2346 "parser.tab.c"
    break;

  case 54:
#line 612 "parser.y"
  {
    parser_logfile << "| LEFTSHIFTEQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2355 "parser.tab.c"
    break;

  case 55:
#line 617 "parser.y"
  {
    parser_logfile << "| RIGHTSHIFTEQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2364 "parser.tab.c"
    break;

  case 56:
#line 622 "parser.y"
  {
    parser_logfile << "| DOUBLESTAREQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2373 "parser.tab.c"
    break;

  case 57:
#line 627 "parser.y"
  {
    parser_logfile << "| DOUBLESLASHEQUAL" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2382 "parser.tab.c"
    break;

  case 58:
#line 637 "parser.y"
  {
    parser_logfile << "break_stmt " << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2391 "parser.tab.c"
    break;

  case 59:
#line 642 "parser.y"
  {
    parser_logfile << "| continue_stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2400 "parser.tab.c"
    break;

  case 60:
#line 647 "parser.y"
  {
    parser_logfile << "| return_stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2409 "parser.tab.c"
    break;

  case 61:
#line 655 "parser.y"
  {
    parser_logfile << "BREAK" << std::endl;
    node_map["BREAK"]++;
    std::string no=std::to_string(node_map["BREAK"]);
    std::string s="BREAK"+no;
    //emit_dot_node(s.c_str(), "BREAK");
    strcpy((yyval.tokenname), s.c_str());
  }
#line 2422 "parser.tab.c"
    break;

  case 62:
#line 667 "parser.y"
  {
    parser_logfile << "CONTINUE" << std::endl;
    node_map["CONTINUE"]++;
    std::string no=std::to_string(node_map["CONTINUE"]);
    std::string s="CONTINUE"+no;
    //emit_dot_node(s.c_str(), "CONTINUE");
    strcpy((yyval.tokenname), s.c_str());
  }
#line 2435 "parser.tab.c"
    break;

  case 63:
#line 679 "parser.y"
  {
    parser_logfile << "RETURN testlist_opt" << std::endl;
    node_map["RETURN"]++;
    std::string no=std::to_string(node_map["RETURN"]);
    std::string s="RETURN"+no;
    //emit_dot_node(s.c_str(), "RETURN");
    if((yyvsp[0].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));}
    strcpy((yyval.tokenname), s.c_str());
  }
#line 2450 "parser.tab.c"
    break;

  case 64:
#line 693 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2459 "parser.tab.c"
    break;

  case 65:
#line 698 "parser.y"
  {
    parser_logfile << "| testlist" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2468 "parser.tab.c"
    break;

  case 66:
#line 706 "parser.y"
  {
    parser_logfile << "GLOBAL NAME comma_name_list" << std::endl;
    node_map["GLOBAL"]++;
    std::string no=std::to_string(node_map["GLOBAL"]);
    std::string s="GLOBAL"+no;
    //emit_dot_node(s.c_str(), "GLOBAL");
    char* s2;
    node_map[(yyvsp[-1].tokenname)]++;
    strcpy(s2,"NAME(");
    strcat(s2,(yyvsp[-1].tokenname));
    strcat(s2,")");
    std::string temp = std::to_string(node_map[(yyvsp[-1].tokenname)]);
    strcat(s2, temp.c_str());
    emit_dot_edge(s.c_str(), s2);
    if((yyvsp[0].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));}
    strcpy((yyval.tokenname), s.c_str());
  }
#line 2491 "parser.tab.c"
    break;

  case 67:
#line 728 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2500 "parser.tab.c"
    break;

  case 68:
#line 733 "parser.y"
  {
    parser_logfile << "| comma_name_list ',' NAME" << std::endl;
    node_map[","]++;
    std::string no=std::to_string(node_map[","]);
    std::string s=","+no;
    //emit_dot_node(s.c_str(), ",");
    char* s2;
    node_map[(yyvsp[0].tokenname)]++;
    strcpy(s2,"NAME(");
    strcat(s2,(yyvsp[0].tokenname));
    strcat(s2,")");
    std::string temp = std::to_string(node_map[(yyvsp[0].tokenname)]);
    strcat(s2, temp.c_str());
    emit_dot_edge(s.c_str(), s2);
    if((yyvsp[-2].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-2].tokenname));
    }
    strcpy((yyval.tokenname), s.c_str());
  }
#line 2524 "parser.tab.c"
    break;

  case 69:
#line 756 "parser.y"
  {
    parser_logfile << "if_stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2533 "parser.tab.c"
    break;

  case 70:
#line 761 "parser.y"
  {
    parser_logfile << "| while_stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2542 "parser.tab.c"
    break;

  case 71:
#line 766 "parser.y"
  {
    parser_logfile << "| for_stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2551 "parser.tab.c"
    break;

  case 72:
#line 771 "parser.y"
  {
    parser_logfile << "| funcdef" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2560 "parser.tab.c"
    break;

  case 73:
#line 776 "parser.y"
  {
    parser_logfile << "| classdef" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2569 "parser.tab.c"
    break;

  case 74:
#line 784 "parser.y"
  {
    parser_logfile << "IF test ':' suite elif_test_colon_suite_list else_colon_suite_opt" << std::endl;
    node_map["IF"]++;
    std::string no=std::to_string(node_map["IF"]);
    std::string s="IF"+no;
    emit_dot_edge(s.c_str(), (yyvsp[-4].tokenname));
    node_map[":"]++;
    std::string no1=std::to_string(node_map[":"]);
    std::string s1=":"+no1;
    emit_dot_edge(s1.c_str(), s.c_str());
    emit_dot_edge(s1.c_str(), (yyvsp[-2].tokenname));
    strcpy((yyval.tokenname), (yyvsp[-3].tokenname));
    std::string temp = std::to_string(node_map[":"]);
    strcat((yyval.tokenname), temp.c_str());
    if(((yyvsp[-1].tokenname)[0] == '\0') && ((yyvsp[0].tokenname)[0] == '\0')){

    }
    else if((yyvsp[-1].tokenname)[0] == '\0'){
      emit_dot_edge((yyval.tokenname), (yyvsp[0].tokenname));
    }
    else if((yyvsp[0].tokenname)[0] == '\0'){
      emit_dot_edge((yyval.tokenname), (yyvsp[-1].tokenname));
    }
    else{
      emit_dot_edge((yyval.tokenname), (yyvsp[-1].tokenname));
      emit_dot_edge((yyvsp[-1].tokenname), (yyvsp[0].tokenname));
    }
  }
#line 2602 "parser.tab.c"
    break;

  case 75:
#line 816 "parser.y"
  {
    parser_logfile << "WHILE test ':' suite else_colon_suite_opt" << std::endl;
    node_map["WHILE"]++;
    std::string no=std::to_string(node_map["WHILE"]);
    std::string s="WHILE"+no;
    //emit_dot_node(s.c_str(), "WHILE");
    emit_dot_edge(s.c_str(), (yyvsp[-3].tokenname));
    if((yyvsp[-1].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));
    }
    node_map[":"]++;
    std::string no1=std::to_string(node_map[":"]);
    std::string s1=":"+no1;
    //emit_dot_node(s1.c_str(), ":");
    emit_dot_edge(s.c_str(), s1.c_str());
    strcpy((yyval.tokenname), s.c_str());
  }
#line 2624 "parser.tab.c"
    break;

  case 76:
#line 836 "parser.y"
  {
    parser_logfile << "FOR exprlist IN testlist ':' suite else_colon_suite_opt" << std::endl;
    node_map["FOR"]++;
    std::string no=std::to_string(node_map["FOR"]);
    std::string s="FOR"+no;
    //emit_dot_node(s.c_str(), "FOR");
    emit_dot_edge(s.c_str(), (yyvsp[-5].tokenname));

    node_map["IN"]++;
    std::string no1=std::to_string(node_map["IN"]);
    std::string s1="IN"+no1;
    //emit_dot_node(s1.c_str(), "IN");
    emit_dot_edge(s.c_str(), s1.c_str());

    node_map[":"]++;
    std::string no2=std::to_string(node_map[":"]);
    std::string s2=":"+no2;
    //emit_dot_node(s2.c_str(), ":");
    emit_dot_edge(s1.c_str(), s2.c_str());
    emit_dot_edge(s2.c_str(), (yyvsp[-3].tokenname));
    emit_dot_edge(s2.c_str(), (yyvsp[-1].tokenname));

    strcpy((yyval.tokenname), s.c_str());
  }
#line 2653 "parser.tab.c"
    break;

  case 77:
#line 864 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2662 "parser.tab.c"
    break;

  case 78:
#line 869 "parser.y"
  {
    parser_logfile << "| ELSE ':' suite" << std::endl;
    node_map["ELSE"]++;
    std::string no=std::to_string(node_map["ELSE"]);
    std::string s="ELSE"+no;
    node_map[":"]++;
    std::string no1=std::to_string(node_map[":"]);
    std::string s1=":"+no1;
    emit_dot_edge(s1.c_str(), s.c_str());
    emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname), s1.c_str());
  }
#line 2679 "parser.tab.c"
    break;

  case 79:
#line 885 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2688 "parser.tab.c"
    break;

  case 80:
#line 890 "parser.y"
  {
    parser_logfile << "| elif_test_colon_suite_list ELIF test ':' suite" << std::endl;
    node_map["ELIF"]++;
    std::string no=std::to_string(node_map["ELIF"]);
    std::string s="ELIF"+no;
    node_map[":"]++;
    std::string no1=std::to_string(node_map[":"]);
    std::string s1=":"+no1;
    emit_dot_edge(s.c_str(), s1.c_str());
    emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));
    emit_dot_edge(s1.c_str(), (yyvsp[-2].tokenname));
    strcpy((yyval.tokenname), s.c_str());
    if((yyvsp[-4].tokenname)[0] != '\0'){
      emit_dot_edge(s1.c_str(),(yyvsp[-4].tokenname));
    }
  }
#line 2709 "parser.tab.c"
    break;

  case 81:
#line 912 "parser.y"
  {
    parser_logfile << "simple_stmt" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2718 "parser.tab.c"
    break;

  case 82:
#line 917 "parser.y"
  {
    parser_logfile << "| NEWLINE INDENT stmt stmt_list DEDENT" << std::endl;
    if((yyvsp[-1].tokenname)[0]=='\0'){
      strcpy((yyval.tokenname), (yyvsp[-2].tokenname));
    }
    else
    {
      node_map["statements"]++;
      s1 = "statements" + std::to_string(node_map["statements"]);
      emit_dot_edge(s1.c_str(), (yyvsp[-2].tokenname));
      emit_dot_edge(s1.c_str(), (yyvsp[-1].tokenname));
      strcpy((yyval.tokenname), s1.c_str());
    }
  }
#line 2737 "parser.tab.c"
    break;

  case 83:
#line 935 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2746 "parser.tab.c"
    break;

  case 84:
#line 940 "parser.y"
  {
    parser_logfile << "| stmt_list stmt" << std::endl;
    if((yyvsp[-1].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[0].tokenname));
    }
    else
    {
      node_map["statements"]++;
      s1 = "statements" + std::to_string(node_map["statements"]);
      emit_dot_edge(s1.c_str(), (yyvsp[-1].tokenname));
      emit_dot_edge(s1.c_str(), (yyvsp[0].tokenname));
      strcpy((yyval.tokenname), s1.c_str());
    }
  }
#line 2765 "parser.tab.c"
    break;

  case 85:
#line 958 "parser.y"
  {
    parser_logfile << "or_test if_or_test_else_test_opt" << std::endl;
    if((yyvsp[0].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
    else
      {
        emit_dot_edge((yyvsp[-1].tokenname),(yyvsp[0].tokenname));
        strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
  }
#line 2781 "parser.tab.c"
    break;

  case 86:
#line 973 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2790 "parser.tab.c"
    break;

  case 87:
#line 978 "parser.y"
  {
    parser_logfile << "| IF or_test ELSE test" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[-3].tokenname));
    strcat((yyval.tokenname), (yyvsp[-2].tokenname));
    strcat((yyval.tokenname), (yyvsp[-1].tokenname));
    strcat((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2802 "parser.tab.c"
    break;

  case 88:
#line 989 "parser.y"
  {
    parser_logfile << "or_test" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2811 "parser.tab.c"
    break;

  case 89:
#line 997 "parser.y"
  {
    parser_logfile << "and_test or_and_test_list" << std::endl;
    if((yyvsp[0].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
    else
      {
        std::string no=std::to_string(node_map["OR"]);
        std::string s="OR"+no;
        emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));
        strcpy((yyval.tokenname), s.c_str());
    }
  }
#line 2829 "parser.tab.c"
    break;

  case 90:
#line 1014 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2838 "parser.tab.c"
    break;

  case 91:
#line 1019 "parser.y"
  {
    parser_logfile << "| or_and_test_list OR and_test" << std::endl;
    node_map["OR"]++;
    std::string no=std::to_string(node_map["OR"]);
    std::string s="OR"+no;
    emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
    if((yyvsp[-2].tokenname)[0] != '\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-2].tokenname));
    }
    strcpy((yyval.tokenname), s.c_str());
  }
#line 2854 "parser.tab.c"
    break;

  case 92:
#line 1034 "parser.y"
  {
    parser_logfile << "not_test and_not_test_list" << std::endl;
    if((yyvsp[0].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));}
    else
      {
        std::string no=std::to_string(node_map["AND"]);
        std::string s="AND"+no;
        emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));
        strcpy((yyval.tokenname), s.c_str());
    }
  }
#line 2871 "parser.tab.c"
    break;

  case 93:
#line 1050 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2880 "parser.tab.c"
    break;

  case 94:
#line 1055 "parser.y"
  {
    parser_logfile << "| and_not_test_list AND not_test" << std::endl;
    node_map["AND"]++;
    std::string no=std::to_string(node_map["AND"]);
    std::string s="AND"+no;
    emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
    if((yyvsp[-2].tokenname)[0] != '\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-2].tokenname));
    }
      strcpy((yyval.tokenname), s.c_str());
  }
#line 2896 "parser.tab.c"
    break;

  case 95:
#line 1070 "parser.y"
  {
    parser_logfile << "NOT not_test" << std::endl;
    node_map["NOT"]++;
    std::string no=std::to_string(node_map["NOT"]);
    std::string s="NOT"+no;
    emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname), s.c_str());
  }
#line 2909 "parser.tab.c"
    break;

  case 96:
#line 1079 "parser.y"
  {
    parser_logfile << "| comparison" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 2918 "parser.tab.c"
    break;

  case 97:
#line 1087 "parser.y"
  {
    parser_logfile << "expr comp_op_expr_list" << std::endl;
    if((yyvsp[0].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
    else
    {
      strcpy((yyval.tokenname), "COMP_OP(");
      int len = strlen((yyvsp[0].tokenname)), i = len - 1;
      while((i >= 0) && (is_digit((yyvsp[0].tokenname)[i]))){
        (yyvsp[0].tokenname)[i] = '\0';
        i--;
      }
      strcat((yyval.tokenname), (yyvsp[0].tokenname));
      strcat((yyval.tokenname), ")");
      node_map[(yyval.tokenname)]++;
      std::string no=std::to_string(node_map[(yyval.tokenname)]);
      std::string s=(yyval.tokenname)+no;
      emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));
      strcat((yyval.tokenname), no.c_str());
    }
  }
#line 2945 "parser.tab.c"
    break;

  case 98:
#line 1113 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 2954 "parser.tab.c"
    break;

  case 99:
#line 1118 "parser.y"
  {
    parser_logfile << "| comp_op_expr_list comp_op expr" << std::endl;
    node_map[(yyvsp[-1].tokenname)]++;
    std::string s3 = "COMP_OP(";
    std::string no=std::to_string(node_map[(yyvsp[-1].tokenname)]);
    std::string s2 = (yyvsp[-1].tokenname)+no;
    std::string s=s3 + (yyvsp[-1].tokenname) + ")" + no;

    emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
    if((yyvsp[-2].tokenname)[0] != '\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-2].tokenname));
    }
    strcpy((yyval.tokenname), s2.c_str());
  }
#line 2973 "parser.tab.c"
    break;

  case 100:
#line 1139 "parser.y"
  {
    parser_logfile << "LESSTHAN" << std::endl;
    strcpy((yyval.tokenname), "<");
  }
#line 2982 "parser.tab.c"
    break;

  case 101:
#line 1144 "parser.y"
  {
    parser_logfile << "| GREATERTHAN" << std::endl;
    strcpy((yyval.tokenname), ">");
  }
#line 2991 "parser.tab.c"
    break;

  case 102:
#line 1149 "parser.y"
  {
    parser_logfile << "| DOUBLEEQUAL" << std::endl;
    strcpy((yyval.tokenname), "==");
  }
#line 3000 "parser.tab.c"
    break;

  case 103:
#line 1154 "parser.y"
  {
    parser_logfile << "| GREATERTHANEQUAL" << std::endl;
    strcpy((yyval.tokenname), ">=");
  }
#line 3009 "parser.tab.c"
    break;

  case 104:
#line 1159 "parser.y"
  {
    parser_logfile << "| LESSTHANEQUAL" << std::endl;
    strcpy((yyval.tokenname), "<=");
  }
#line 3018 "parser.tab.c"
    break;

  case 105:
#line 1164 "parser.y"
  {
    parser_logfile << "| NOTEQUAL" << std::endl;
    strcpy((yyval.tokenname), "!=");
  }
#line 3027 "parser.tab.c"
    break;

  case 106:
#line 1169 "parser.y"
  {
    parser_logfile << "| IN" << std::endl;
    strcpy((yyval.tokenname), "IN");
  }
#line 3036 "parser.tab.c"
    break;

  case 107:
#line 1177 "parser.y"
  {
    parser_logfile << "'*' expr" << std::endl;
    // node_map["*"]++;
    // std::string no=std::to_string(node_map["*"]);
    // std::string s="*"+no;
    // emit_dot_edge(s.c_str(), $2);
    // strcpy($$, s.c_str());
    std::string t=new_temp();
    gen("*", (yyvsp[0].tokenname), "", t);
    strcpy((yyval.tokenname), t.c_str());
  }
#line 3052 "parser.tab.c"
    break;

  case 108:
#line 1192 "parser.y"
  {
    parser_logfile << "xor_expr or_xor_expr_list" << std::endl;
    if((yyvsp[0].tokenname)[0] == '\0')
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    else
      {
        std::string no=std::to_string(node_map["|"]);
        std::string s="|"+no;
        emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));
        strcpy((yyval.tokenname), s.c_str());
    }
  }
#line 3069 "parser.tab.c"
    break;

  case 109:
#line 1208 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3078 "parser.tab.c"
    break;

  case 110:
#line 1213 "parser.y"
  {
    parser_logfile << "| or_xor_expr_list '|' xor_expr" << std::endl;
    // node_map["|"]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    // strcpy($$, s.c_str());
    std::string t=new_temp();
    gen((yyvsp[-1].tokenname), (yyvsp[0].tokenname), (yyvsp[-2].tokenname), t);
    strcpy((yyval.tokenname), t.c_str());
  }
#line 3097 "parser.tab.c"
    break;

  case 111:
#line 1231 "parser.y"
  {
    parser_logfile << "and_expr xor_and_expr_list" << std::endl;
    if((yyvsp[0].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
    else
      {
        std::string no=std::to_string(node_map["^"]);
        std::string s="^"+no;
        emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));
        strcpy((yyval.tokenname), s.c_str());
    }
  }
#line 3115 "parser.tab.c"
    break;

  case 112:
#line 1248 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3124 "parser.tab.c"
    break;

  case 113:
#line 1253 "parser.y"
  {
    parser_logfile << "| xor_and_expr_list '^' and_expr" << std::endl;
    // node_map["^"]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    // strcpy($$, s.c_str());
    std::string t=new_temp();
    gen((yyvsp[-1].tokenname), (yyvsp[0].tokenname), (yyvsp[-2].tokenname), t);
    strcpy((yyval.tokenname), t.c_str());
  }
#line 3143 "parser.tab.c"
    break;

  case 114:
#line 1271 "parser.y"
  {
    parser_logfile << "shift_expr and_shift_expr_list" << std::endl;
    if((yyvsp[0].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
    else
      {
        std::string no=std::to_string(node_map["&"]);
        std::string s="&"+no;
        emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));
        strcpy((yyval.tokenname), s.c_str());
    }
  }
#line 3161 "parser.tab.c"
    break;

  case 115:
#line 1288 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3170 "parser.tab.c"
    break;

  case 116:
#line 1293 "parser.y"
  {
    parser_logfile << "| and_shift_expr_list '&' shift_expr" << std::endl;
    // node_map["&"]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    //   strcpy($$, s.c_str());
    std::string t=new_temp();
    gen((yyvsp[-1].tokenname), (yyvsp[0].tokenname), (yyvsp[-2].tokenname), t);
    strcpy((yyval.tokenname), t.c_str());
  }
#line 3189 "parser.tab.c"
    break;

  case 117:
#line 1311 "parser.y"
  {
    parser_logfile << "arith_expr shift_arith_expr_list" << std::endl;
    if((yyvsp[0].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));}
    else
      {
          emit_dot_edge((yyvsp[0].tokenname), (yyvsp[-1].tokenname));
          strcpy((yyval.tokenname), (yyvsp[0].tokenname));
      }
  }
#line 3204 "parser.tab.c"
    break;

  case 118:
#line 1325 "parser.y"
  {
    parser_logfile << "LEFTSHIFT" << std::endl;
    strcpy((yyval.tokenname), "<<");;
  }
#line 3213 "parser.tab.c"
    break;

  case 119:
#line 1330 "parser.y"
  {
    parser_logfile << "| RIGHTSHIFT" << std::endl;
    strcpy((yyval.tokenname), ">>");
  }
#line 3222 "parser.tab.c"
    break;

  case 120:
#line 1338 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3231 "parser.tab.c"
    break;

  case 121:
#line 1343 "parser.y"
  {
    parser_logfile << "| shift_arith_expr_list ltshift_or_rtshift arith_expr" << std::endl;
    // node_map[$2]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // emit_dot_edge($2, $3);
    // if($1[0] != '\0'){
    //   emit_dot_edge($2, $1);
    // }
    // strcpy($$, s.c_str());
    std::string t=new_temp();
    gen((yyvsp[-1].tokenname), (yyvsp[0].tokenname), (yyvsp[-2].tokenname), t);
    strcpy((yyval.tokenname), t.c_str());
  }
#line 3250 "parser.tab.c"
    break;

  case 122:
#line 1361 "parser.y"
  {
    parser_logfile << "term plus_or_minus_term_list" << std::endl;
    if((yyvsp[0].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
    else
    {
      emit_dot_edge((yyvsp[0].tokenname), (yyvsp[-1].tokenname));
      strcpy((yyval.tokenname), (yyvsp[0].tokenname));
    }
  }
#line 3266 "parser.tab.c"
    break;

  case 123:
#line 1376 "parser.y"
  {
    parser_logfile << "'+'" << std::endl;
    strcpy((yyval.tokenname), "+");
  }
#line 3275 "parser.tab.c"
    break;

  case 124:
#line 1381 "parser.y"
  {
    parser_logfile << "'-'" << std::endl;
    strcpy((yyval.tokenname), "-");
  }
#line 3284 "parser.tab.c"
    break;

  case 125:
#line 1389 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3293 "parser.tab.c"
    break;

  case 126:
#line 1394 "parser.y"
  {
    parser_logfile << "| plus_or_minus_term_list plus_or_minus term" << std::endl;
    // node_map[$2]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // //emit_dot_node(s.c_str(), $2);
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0]!='\0'){
    //   emit_dot_edge(s.c_str(), $1);
    // }
    // strcpy($$, s.c_str());
    std::string t=new_temp();
    gen((yyvsp[-1].tokenname), (yyvsp[0].tokenname), (yyvsp[-2].tokenname), t);
    strcpy((yyval.tokenname), t.c_str()); 
  }
#line 3313 "parser.tab.c"
    break;

  case 127:
#line 1413 "parser.y"
  {
    parser_logfile << "factor star_or_slash_or_percent_or_doubleslash_factor_list" << std::endl;
    if((yyvsp[0].tokenname)[0]=='\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
    else{
    emit_dot_edge((yyvsp[-1].tokenname), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
  }
#line 3328 "parser.tab.c"
    break;

  case 128:
#line 1427 "parser.y"
  {
    parser_logfile << "'*'" << std::endl;
    strcpy((yyval.tokenname), "*");
  }
#line 3337 "parser.tab.c"
    break;

  case 129:
#line 1432 "parser.y"
  {
    parser_logfile << "| '/'" << std::endl;
    strcpy((yyval.tokenname), "/");
  }
#line 3346 "parser.tab.c"
    break;

  case 130:
#line 1437 "parser.y"
  {
    parser_logfile << "| '%'" << std::endl;
    strcpy((yyval.tokenname), "%");
  }
#line 3355 "parser.tab.c"
    break;

  case 131:
#line 1442 "parser.y"
  {
    parser_logfile << "| DOUBLESLASH" << std::endl;
    strcpy((yyval.tokenname), "//");
  }
#line 3364 "parser.tab.c"
    break;

  case 132:
#line 1450 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3373 "parser.tab.c"
    break;

  case 133:
#line 1455 "parser.y"
  {
    parser_logfile << "| star_or_slash_or_percent_or_doubleslash_factor_list star_or_slash_or_percent_or_doubleslash factor" << std::endl;
    // node_map[$2]++;
    // std::string no=std::to_string(node_map[$2]);
    // std::string s=$2+no;
    // //emit_dot_node(s.c_str(), $2);
    // emit_dot_edge(s.c_str(), $3);
    // if($1[0]!='\0'){
    //   emit_dot_edge($1, s.c_str());}
    //   strcpy($$, s.c_str());
    std::string t=new_temp();
    gen((yyvsp[-1].tokenname), (yyvsp[0].tokenname), (yyvsp[-2].tokenname), t);
    strcpy((yyval.tokenname), t.c_str());
  }
#line 3392 "parser.tab.c"
    break;

  case 134:
#line 1473 "parser.y"
  {
    parser_logfile << "plus_or_minus_or_tilde factor" << std::endl;
    // node_map[$1]++;
    // std::string no=std::to_string(node_map[$1]);
    // std::string s=$1+no;
    // //emit_dot_node(s.c_str(), $1);
    // emit_dot_edge(s.c_str(), $2);
    // strcpy($$, s.c_str());
    std::string t=new_temp();
    gen((yyvsp[-1].tokenname), (yyvsp[0].tokenname), "", t);
    strcpy((yyval.tokenname), t.c_str());
  }
#line 3409 "parser.tab.c"
    break;

  case 135:
#line 1486 "parser.y"
  {
    parser_logfile << "| power" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 3418 "parser.tab.c"
    break;

  case 136:
#line 1494 "parser.y"
  {
    parser_logfile << "'+'" << std::endl;
    strcpy((yyval.tokenname), "+");
  }
#line 3427 "parser.tab.c"
    break;

  case 137:
#line 1499 "parser.y"
  {
    parser_logfile << "| '-'" << std::endl;
    strcpy((yyval.tokenname), "-");
  }
#line 3436 "parser.tab.c"
    break;

  case 138:
#line 1504 "parser.y"
  {
    parser_logfile << "| '~'" << std::endl;
    strcpy((yyval.tokenname), "~");
  }
#line 3445 "parser.tab.c"
    break;

  case 139:
#line 1512 "parser.y"
  {
    parser_logfile << "atom_expr doublestar_factor_opt" << std::endl;
    if((yyvsp[0].tokenname)[0]=='\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));}
    else
      {
    emit_dot_edge((yyvsp[-1].tokenname), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
  }
#line 3460 "parser.tab.c"
    break;

  case 140:
#line 1526 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3469 "parser.tab.c"
    break;

  case 141:
#line 1531 "parser.y"
  {
    parser_logfile << "| DOUBLESTAR factor" << std::endl;
    // node_map["**"]++;
    // std::string no=std::to_string(node_map["**"]);
    // std::string s="**"+no;
    // //emit_dot_node(s.c_str(), "**");
    // emit_dot_edge(s.c_str(), $2);
    // strcpy($$, s.c_str());
    std::string t=new_temp();
    gen("**", (yyvsp[0].tokenname), "", t);
    strcpy((yyval.tokenname), t.c_str());
  }
#line 3486 "parser.tab.c"
    break;

  case 142:
#line 1547 "parser.y"
  {
    parser_logfile << "atom trailer_list" << std::endl;
    if((yyvsp[0].tokenname)[0] != '\0'){
      emit_dot_edge((yyvsp[-1].tokenname), (yyvsp[0].tokenname));
    }
    strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
  }
#line 3498 "parser.tab.c"
    break;

  case 143:
#line 1558 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3507 "parser.tab.c"
    break;

  case 144:
#line 1563 "parser.y"
  {
    parser_logfile << "| trailer_list trailer" << std::endl;
    if((yyvsp[-1].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[0].tokenname));
    }
    else
      {
      emit_dot_edge((yyvsp[-1].tokenname), (yyvsp[0].tokenname));
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
      }
  }
#line 3523 "parser.tab.c"
    break;

  case 145:
#line 1578 "parser.y"
  {
    parser_logfile << "'(' testlist_comp_opt ')'" << std::endl;
    // node_map["()"]++;
    // std::string no=std::to_string(node_map["()"]);
    // std::string s="()"+no;
    // //emit_dot_node(s.c_str(), "()");
    // if($2[0]!='\0'){
    //   emit_dot_edge(s.c_str(), $2);
    // }
    // strcpy($$, s.c_str());
    strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
  }
#line 3540 "parser.tab.c"
    break;

  case 146:
#line 1591 "parser.y"
  {
    parser_logfile << "'[' testlist_comp_opt ']'" << std::endl;
    node_map["[]"]++;
    std::string no=std::to_string(node_map["[]"]);
    std::string s="[]"+no;
    //emit_dot_node(s.c_str(), "[]");
    if((yyvsp[-1].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));
    }
    strcpy((yyval.tokenname), s.c_str());
  }
#line 3556 "parser.tab.c"
    break;

  case 147:
#line 1603 "parser.y"
  {
    parser_logfile << "NAME" << std::endl;
    node_map[(yyvsp[0].tokenname)]++;
    strcpy((yyval.tokenname), "NAME(");
    strcat((yyval.tokenname), (yyvsp[0].tokenname));
    strcat((yyval.tokenname), ")");
    std::string temp = std::to_string(node_map[(yyvsp[0].tokenname)]);
    strcat((yyval.tokenname), temp.c_str());
  }
#line 3570 "parser.tab.c"
    break;

  case 148:
#line 1613 "parser.y"
  {
    parser_logfile << "NUMBER" << std::endl;
    // strcpy($$, "NUMBER(");
    // strcat($$, $1);
    // strcat($$, ")");
    // node_map[$$]++;
    // std::string temp = std::to_string(node_map[$$]);
    // strcat($$, temp.c_str());
    std::string t=new_temp();
    gen("", (yyvsp[0].tokenname), "", t);
    strcpy((yyval.tokenname), t.c_str());
  }
#line 3587 "parser.tab.c"
    break;

  case 149:
#line 1626 "parser.y"
  {
    parser_logfile << "STRING string_list" << std::endl;
    strcpy((yyval.tokenname), "STRING(");
    int len = strlen((yyvsp[-1].tokenname));
    //char* str = new char(len - 1);
    for(int i = 0; i < len - 1; i++){
      (yyvsp[-1].tokenname)[i] = (yyvsp[-1].tokenname)[i + 1];
    }
    (yyvsp[-1].tokenname)[len - 2] = '\0';
    strcat((yyval.tokenname), (yyvsp[-1].tokenname));
    strcat((yyval.tokenname), ")");
    node_map[(yyval.tokenname)]++;
    std::string temp = std::to_string(node_map[(yyval.tokenname)]);
    strcat((yyval.tokenname), temp.c_str());
    if((yyvsp[0].tokenname)[0] != '\0'){
      emit_dot_edge((yyval.tokenname), (yyvsp[0].tokenname));
    }
  }
#line 3610 "parser.tab.c"
    break;

  case 150:
#line 1645 "parser.y"
  {
    parser_logfile << "NONE" << std::endl;
    strcpy((yyval.tokenname), "NONE");
    node_map[(yyval.tokenname)]++;
    std::string temp = std::to_string(node_map[(yyval.tokenname)]);
    strcat((yyval.tokenname), temp.c_str());
  }
#line 3622 "parser.tab.c"
    break;

  case 151:
#line 1653 "parser.y"
  {
    parser_logfile << "TRUE" << std::endl;
    strcpy((yyval.tokenname), "TRUE");
    node_map[(yyval.tokenname)]++;
    std::string temp = std::to_string(node_map[(yyval.tokenname)]);
    strcat((yyval.tokenname), temp.c_str());
  }
#line 3634 "parser.tab.c"
    break;

  case 152:
#line 1661 "parser.y"
  {
    parser_logfile << "FALSE" << std::endl;
    strcpy((yyval.tokenname), "FALSE");
    node_map[(yyval.tokenname)]++;
    std::string temp = std::to_string(node_map[(yyval.tokenname)]);
    strcat((yyval.tokenname), temp.c_str());
  }
#line 3646 "parser.tab.c"
    break;

  case 153:
#line 1672 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3655 "parser.tab.c"
    break;

  case 154:
#line 1677 "parser.y"
  {
    parser_logfile << "| string_list STRING" << std::endl;
    if((yyvsp[-1].tokenname)[0]=='\0'){
      strcpy((yyval.tokenname),(yyvsp[0].tokenname));}
    else{
      strcpy((yyval.tokenname), "STRING(");
      int len = strlen((yyvsp[0].tokenname));
      //char* str = new char(len - 1);
      for(int i = 0; i < len - 1; i++){
          (yyvsp[0].tokenname)[i] = (yyvsp[0].tokenname)[i+1];
      }
      (yyvsp[0].tokenname)[len - 2] = '\0';
      strcat((yyval.tokenname), (yyvsp[0].tokenname));
      strcat((yyval.tokenname), ")");
      node_map[(yyval.tokenname)]++;
      std::string temp = std::to_string(node_map[(yyval.tokenname)]);
      strcat((yyval.tokenname), temp.c_str());
      emit_dot_edge((yyval.tokenname), (yyvsp[0].tokenname));
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
  }
#line 3681 "parser.tab.c"
    break;

  case 155:
#line 1702 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3690 "parser.tab.c"
    break;

  case 156:
#line 1707 "parser.y"
  {
    parser_logfile << "| testlist_comp" << std::endl;
    strcpy((yyval.tokenname),(yyvsp[0].tokenname));
  }
#line 3699 "parser.tab.c"
    break;

  case 157:
#line 1715 "parser.y"
  {
    parser_logfile << "test_or_star_expr comp_for_OR_comma_test_or_star_expr_list_comma_opt" << std::endl;
    if((yyvsp[0].tokenname)[0] == '\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
    else{
      //emit_dot_edge($1, $2);
      //strcpy($$, $1);
      s1 = "," + std::to_string(comma_number);
      emit_dot_edge(s1.c_str(), (yyvsp[-1].tokenname));
      strcpy((yyval.tokenname), (yyvsp[0].tokenname));
    }
  }
#line 3717 "parser.tab.c"
    break;

  case 158:
#line 1732 "parser.y"
  {
    parser_logfile << "comp_for" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 3726 "parser.tab.c"
    break;

  case 159:
#line 1737 "parser.y"
  {
    parser_logfile << "| comma_test_or_star_expr_list comma_opt" << std::endl;
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
  }
#line 3735 "parser.tab.c"
    break;

  case 160:
#line 1745 "parser.y"
  {
    parser_logfile << "'(' arglist_opt ')'" << std::endl;
    node_map["()"]++;
    std::string no=std::to_string(node_map["()"]);
    std::string s="()"+no;
    //emit_dot_node(s.c_str(), "()");
    if((yyvsp[-1].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));}
    strcpy((yyval.tokenname), s.c_str());
  }
#line 3750 "parser.tab.c"
    break;

  case 161:
#line 1756 "parser.y"
  {
    parser_logfile << "'[' subscriptlist ']'" << std::endl;
    node_map["[]"]++;
    std::string no=std::to_string(node_map["[]"]);
    std::string s="[]"+no;
    //emit_dot_node(s.c_str(), "[]");
    if((yyvsp[-1].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));}
    strcpy((yyval.tokenname), s.c_str());
  }
#line 3765 "parser.tab.c"
    break;

  case 162:
#line 1767 "parser.y"
  {
    parser_logfile << "'. NAME'" << std::endl;
    node_map["."]++;
    std::string no=std::to_string(node_map["."]);
    std::string s="."+no;
    //emit_dot_node(s.c_str(), ".");
    strcpy((yyval.tokenname), "NAME(");
    strcat((yyval.tokenname), (yyvsp[0].tokenname));
    strcat((yyval.tokenname), ")");
    node_map[(yyvsp[0].tokenname)]++;
    std::string temp = std::to_string(node_map[(yyvsp[0].tokenname)]);
    strcat((yyval.tokenname), temp.c_str());
    emit_dot_edge(s.c_str(),(yyval.tokenname));
    strcpy((yyval.tokenname), s.c_str());
  }
#line 3785 "parser.tab.c"
    break;

  case 163:
#line 1786 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3794 "parser.tab.c"
    break;

  case 164:
#line 1791 "parser.y"
  {
    parser_logfile << "| arglist" << std::endl;
    strcpy((yyval.tokenname),(yyvsp[0].tokenname));
  }
#line 3803 "parser.tab.c"
    break;

  case 165:
#line 1799 "parser.y"
  {
    parser_logfile << "subscript comma_subscript_list comma_opt" << std::endl;
    if((yyvsp[-1].tokenname)[0]=='\0'){
      strcpy((yyval.tokenname), (yyvsp[-2].tokenname));
    }
    else {
      emit_dot_edge((yyvsp[-1].tokenname), (yyvsp[-2].tokenname));
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
  }
#line 3818 "parser.tab.c"
    break;

  case 166:
#line 1813 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3827 "parser.tab.c"
    break;

  case 167:
#line 1818 "parser.y"
  {
    parser_logfile << "| comma_subscript_list ',' subscript" << std::endl;
    node_map[","]++;
    std::string no=std::to_string(node_map[","]);
    std::string s=","+no;
    //emit_dot_node(s.c_str(), ",");
    if((yyvsp[-2].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-2].tokenname));}
    emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname), s.c_str());
  }
#line 3843 "parser.tab.c"
    break;

  case 168:
#line 1833 "parser.y"
  {
    parser_logfile << "test" << std::endl;
    strcpy((yyval.tokenname),(yyvsp[0].tokenname));
  }
#line 3852 "parser.tab.c"
    break;

  case 169:
#line 1838 "parser.y"
  {
    parser_logfile << "| test_opt ':' test_opt" << std::endl;
    node_map[":"]++;
    std::string no=std::to_string(node_map[":"]);
    std::string s=":"+no;
    //emit_dot_node(s.c_str(), ":");
    if((yyvsp[-2].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-2].tokenname));
    }
    if((yyvsp[0].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
    }
    strcpy((yyval.tokenname), s.c_str());
  }
#line 3871 "parser.tab.c"
    break;

  case 170:
#line 1856 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3880 "parser.tab.c"
    break;

  case 171:
#line 1861 "parser.y"
  {
    parser_logfile << "| test" << std::endl;
    strcpy((yyval.tokenname),(yyvsp[0].tokenname));
  }
#line 3889 "parser.tab.c"
    break;

  case 172:
#line 1869 "parser.y"
  {
    parser_logfile << "expr_or_star_expr comma_expr_or_star_expr_list comma_opt" << std::endl;
    if((yyvsp[-1].tokenname)[0]=='\0'){
      strcpy((yyval.tokenname), (yyvsp[-2].tokenname));
    }
    else{
      emit_dot_edge((yyvsp[-1].tokenname), (yyvsp[-2].tokenname));
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
  }
#line 3904 "parser.tab.c"
    break;

  case 173:
#line 1883 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3913 "parser.tab.c"
    break;

  case 174:
#line 1888 "parser.y"
  {
    parser_logfile << "| comma_expr_or_star_expr_list ',' expr_or_star_expr" << std::endl;
    node_map[","]++;
    std::string no=std::to_string(node_map[","]);
    std::string s=","+no;
    //emit_dot_node(s.c_str(), ",");
    if((yyvsp[-2].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-2].tokenname));
    }
    emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));
    strcpy((yyval.tokenname), s.c_str());
  }
#line 3930 "parser.tab.c"
    break;

  case 175:
#line 1904 "parser.y"
  {
    parser_logfile << "expr" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 3939 "parser.tab.c"
    break;

  case 176:
#line 1909 "parser.y"
  {
    parser_logfile << "star_expr" << std::endl;
    strcpy((yyval.tokenname), (yyvsp[0].tokenname));
  }
#line 3948 "parser.tab.c"
    break;

  case 177:
#line 1917 "parser.y"
  {
    parser_logfile << "test comma_test_list comma_opt" << std::endl;
    if((yyvsp[-1].tokenname)[0]=='\0'){
      strcpy((yyval.tokenname), (yyvsp[-2].tokenname));
    }
    else if((yyvsp[-1].tokenname)[0]!='\0'){
      emit_dot_edge((yyvsp[-1].tokenname), (yyvsp[-2].tokenname));
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    }
  }
#line 3963 "parser.tab.c"
    break;

  case 178:
#line 1931 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 3972 "parser.tab.c"
    break;

  case 179:
#line 1936 "parser.y"
  {
    parser_logfile << "| comma_test_list ',' test" << std::endl;
    node_map[","]++;
    std::string no=std::to_string(node_map[","]);
    std::string s=","+no;
    //emit_dot_node(s.c_str(), ",");
    if((yyvsp[-2].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[-2].tokenname));
    }
    emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname), s.c_str());
  }
#line 3989 "parser.tab.c"
    break;

  case 180:
#line 1952 "parser.y"
  {
    parser_logfile << "CLASS NAME parenthesis_arglist_opt_opt ':' suite" << std::endl;
    strcpy((yyval.tokenname), "NAME(");
    strcat((yyval.tokenname), (yyvsp[-3].tokenname));
    strcat((yyval.tokenname), ")");
    node_map[(yyvsp[-3].tokenname)]++;
    node_map["CLASS"]++;

    s1 = "CLASS"+std::to_string(node_map["CLASS"]);
    s2 = (yyval.tokenname)+std::to_string(node_map[(yyval.tokenname)]);
    emit_dot_edge(s1.c_str(), s2.c_str());

    node_map["()"]++;

    s1 = (yyval.tokenname)+std::to_string(node_map[(yyval.tokenname)]);
    s2 = "()"+std::to_string(node_map["()"]);
    emit_dot_edge(s1.c_str(), s2.c_str());

    if((yyvsp[-2].tokenname)[0] != '\0'){
      s1 = s2;
      s2 = (yyvsp[-2].tokenname);
      emit_dot_edge(s1.c_str(), s2.c_str());
    }

    node_map[":"]++;

    s1 = (yyvsp[-1].tokenname)+std::to_string(node_map[":"]);
    s2 = "CLASS"+std::to_string(node_map["CLASS"]);
    emit_dot_edge(s1.c_str(), s2.c_str());

    s2 = (yyvsp[0].tokenname);
    emit_dot_edge(s1.c_str(), s2.c_str());

    strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
    std::string temp = std::to_string(node_map[":"]);
    strcat((yyval.tokenname), temp.c_str());
  }
#line 4031 "parser.tab.c"
    break;

  case 181:
#line 1993 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 4040 "parser.tab.c"
    break;

  case 182:
#line 1998 "parser.y"
  {
    parser_logfile << "'(' arglist_opt ')'" << std::endl;
    node_map["()"]++;
    std::string no=std::to_string(node_map["()"]);
    std::string s="()"+no;
    //emit_dot_node(s.c_str(), "()");
    emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));
    strcpy((yyval.tokenname), s.c_str());
  }
#line 4054 "parser.tab.c"
    break;

  case 183:
#line 2011 "parser.y"
  {
    parser_logfile << "argument comma_argument_list  comma_opt" << std::endl;
    if((yyvsp[-1].tokenname)[0]=='\0'){
      strcpy((yyval.tokenname), (yyvsp[-2].tokenname));}
    else
      {
        emit_dot_edge((yyvsp[-1].tokenname), (yyvsp[-2].tokenname));
        strcpy((yyval.tokenname), (yyvsp[-1].tokenname));
      }
  }
#line 4069 "parser.tab.c"
    break;

  case 184:
#line 2025 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 4078 "parser.tab.c"
    break;

  case 185:
#line 2030 "parser.y"
  {
    parser_logfile << "| comma_argument_list ',' argument" << std::endl;
    if((yyvsp[0].tokenname)[0]=='\0'){
      strcpy((yyval.tokenname), (yyvsp[-2].tokenname));}
    else{
      node_map[","]++;
      std::string no=std::to_string(node_map[","]);
      std::string s=","+no;
      //emit_dot_node(s.c_str(), ",");
      emit_dot_edge(s.c_str(), (yyvsp[-2].tokenname));
      emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
      strcpy((yyval.tokenname), s.c_str());
    }
  }
#line 4097 "parser.tab.c"
    break;

  case 186:
#line 2058 "parser.y"
  {
    parser_logfile << "test comp_for_opt" << std::endl;
    if((yyvsp[0].tokenname)[0]=='\0'){
      strcpy((yyval.tokenname), (yyvsp[-1].tokenname));}
    else{
      emit_dot_edge((yyvsp[0].tokenname), (yyvsp[-1].tokenname));
      strcpy((yyval.tokenname), (yyvsp[0].tokenname));
    }
  }
#line 4111 "parser.tab.c"
    break;

  case 187:
#line 2068 "parser.y"
  {
    parser_logfile << "test '=' test" << std::endl;
    node_map["="]++;
    std::string no=std::to_string(node_map["="]);
    std::string s=(yyvsp[-1].tokenname)+no;
    //emit_dot_node(s.c_str(), "=");
    emit_dot_edge(s.c_str(), (yyvsp[-2].tokenname));
    emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname), s.c_str());
  }
#line 4126 "parser.tab.c"
    break;

  case 188:
#line 2079 "parser.y"
  {
    parser_logfile << "'*' test" << std::endl;
    node_map["*"]++;
    std::string no=std::to_string(node_map["*"]);
    std::string s="*"+no;
    //emit_dot_node(s.c_str(), "*");
    emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
    strcpy((yyval.tokenname), s.c_str());
  }
#line 4140 "parser.tab.c"
    break;

  case 189:
#line 2092 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 4149 "parser.tab.c"
    break;

  case 190:
#line 2097 "parser.y"
  {
    parser_logfile << "| comp_for" << std::endl;
    strcpy((yyval.tokenname),(yyvsp[0].tokenname));
  }
#line 4158 "parser.tab.c"
    break;

  case 191:
#line 2105 "parser.y"
  {
    parser_logfile << "comp_for" << std::endl;
    strcpy((yyval.tokenname),(yyvsp[0].tokenname));
  }
#line 4167 "parser.tab.c"
    break;

  case 192:
#line 2110 "parser.y"
  {
    parser_logfile << "| comp_if" << std::endl;
    strcpy((yyval.tokenname),(yyvsp[0].tokenname));
  }
#line 4176 "parser.tab.c"
    break;

  case 193:
#line 2118 "parser.y"
  {
    parser_logfile << "FOR exprlist IN or_test comp_iter_opt" << std::endl;
    node_map["FOR"]++;
    std::string no=std::to_string(node_map["FOR"]);
    std::string s="FOR"+no;
    //emit_dot_node(s.c_str(), "FOR");
    emit_dot_edge(s.c_str(), (yyvsp[-3].tokenname));
    node_map["IN"]++;
    std::string no1=std::to_string(node_map["IN"]);
    std::string s1="IN"+no1;
    //emit_dot_node(s1.c_str(), "IN");
    emit_dot_edge(s.c_str(), s1.c_str());
    if((yyvsp[0].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
    }
    emit_dot_edge(s1.c_str(), (yyvsp[-1].tokenname));
    strcpy((yyval.tokenname), s.c_str());
  }
#line 4199 "parser.tab.c"
    break;

  case 194:
#line 2140 "parser.y"
  {
    parser_logfile << "IF test_nocond comp_iter_opt" << std::endl;
    node_map["IF"]++;
    std::string no=std::to_string(node_map["IF"]);
    std::string s="IF"+no;
    //emit_dot_node(s.c_str(), "IF");
    emit_dot_edge(s.c_str(), (yyvsp[-1].tokenname));
    if((yyvsp[0].tokenname)[0]!='\0'){
      emit_dot_edge(s.c_str(), (yyvsp[0].tokenname));
    }
    strcpy((yyval.tokenname), s.c_str());
  }
#line 4216 "parser.tab.c"
    break;

  case 195:
#line 2156 "parser.y"
  {
    parser_logfile << "%empty" << std::endl;
    (yyval.tokenname)[0]='\0';
  }
#line 4225 "parser.tab.c"
    break;

  case 196:
#line 2161 "parser.y"
  {
    parser_logfile << "| comp_iter" << std::endl;
    strcpy((yyval.tokenname),(yyvsp[0].tokenname));
  }
#line 4234 "parser.tab.c"
    break;


#line 4238 "parser.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 2172 "parser.y"


void yyerror(const char *s) {
  std::cerr << "Error on line " << yylineno << ", token(" << yytext << "): " << s << std::endl;
  exit(1);
}

int is_digit(char c) {
  return ((c >= '0') && (c <= '9'));
}

void emit_dot_node(const char* node_name, const char* label) {
  outfile << "\"" << node_name << "\" [label=\"" << label << "\"];" << std::endl;
}

void emit_dot_edge(const char* from, const char* to) {
  if((from[0] == '\0')) return;
  if(to[0] == '\0') return;
  char* fromlabel = (char*)malloc(strlen(from) + 1);  // Allocate memory for fromlabel
  char* tolabel = (char*)malloc(strlen(to) + 1);
  int i = 0;
  while(from[i] != '\0'){
    fromlabel[i] = from[i];
    i++;
  }
  int j = 0;
  while(to[j] != '\0'){
    tolabel[j] = to[j];
    j++;
  }
  i--;j--;
  while(i>=0 && is_digit(from[i])){
    i--;
  }
  while(j>=0 && is_digit(to[j])){
    j--;
  }
  fromlabel[i+1] = '\0';
  tolabel[j+1] = '\0';
  emit_dot_node(from, fromlabel);
  emit_dot_node(to, tolabel);
  outfile << "\"" << from << "\" -> \"" << to << "\";" << std::endl;
  free(fromlabel);  // Free allocated memory
  free(tolabel);    // Free allocated memory
}

std::string get_sem_val(char *c_str) {
  std::string str = c_str;
  if (str.substr(0, 4) == "NONE") {
    return "None";
  }

  int start = str.find('(');
  if (start == std::string::npos) {
    return str;
  }

  int end = str.find(')');
  return str.substr(start + 1, end - start - 1);
}

int get_size(const std::string &type) {
  if (type == "bool") {
    return 2;
  }

  if (type == "str") {
    // TODO
    return 0;
  }

  // TODO: list

  return 4;
}

void gen(const char* op, const char* arg1, const char* arg2, const char* result) {

  std::vector<std::string> line_code;
  line_code.push_back(op);
  line_code.push_back(arg1);
  if(arg2[0] != '\0') {
    line_code.push_back(arg2);
  }
  line_code.push_back(result);
  ac3_code.push_back(line_code);
  return;
}

std::string new_temp() {
  std::string temp = "t" + std::to_string(temp_count);
  temp_count++;
  return temp;
}
