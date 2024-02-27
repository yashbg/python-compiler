%{
%}

%%

/*
PEG grammar for Python



========================= START OF THE GRAMMAR =========================

General grammatical elements and rules:

* Strings with double quotes (") denote SOFT KEYWORDS
* Strings with single quotes (') denote KEYWORDS
* Upper case names (NAME) denote tokens in the Grammar/Tokens file
* Rule names starting with "invalid_" are used for specialized syntax errors
    - These rules are NOT used in the first pass of the parser.
    - Only if the first pass fails to parse, a second pass including the invalid
      rules will be executed.
    - If the parser fails in the second phase with a generic syntax error, the
      location of the generic failure of the first pass will be used (this avoids
      reporting incorrect locations due to the invalid rules).
    - The order of the alternatives involving invalid rules matter
      (like any rule in PEG).

Grammar Syntax (see PEP 617 for more information):

rule_name: expression
  Optionally, a type can be included right after the rule name, which
  specifies the return type of the C or Python function corresponding to the
  rule:
rule_name[return_type]: expression
  If the return type is omitted, then a void * is returned in C and an Any in
  Python.
e1 e2
  Match e1, then match e2.
e1 | e2
  Match e1 or e2.
  The first alternative can also appear on the line after the rule name for
  formatting purposes. In that case, a | must be used before the first
  alternative, like so:
      rule_name[return_type]:
            | first_alt
            | second_alt
( e )
  Match e (allows also to use other operators in the group like '(e)*')
[ e ] or e?
  Optionally match e.
e*
  Match zero or more occurrences of e.
e+
  Match one or more occurrences of e.
s.e+
  Match one or more occurrences of e, separated by s. The generated parse tree
  does not include the separator. This is otherwise identical to (e (s e)*).
&e
  Succeed if e can be parsed, without consuming any input.
!e
  Fail if e can be parsed, without consuming any input.
~
  Commit to the current alternative, even if it fails to parse. 
*/


/* STARTING RULES */
/* ============== */

file:
  statements
;

/* GENERAL STATEMENTS */
/* ================== */

statements:
  %empty
| statements statement
;

statement:
  compound_stmt
| simple_stmts
;

simple_stmts:
  simple_stmt simple_stmt_list semicolon_opt NEWLINE
;

simple_stmt_list:
  %empty
| simple_stmt_list ';' simple_stmt
;

semicolon_opt:
  %empty
| ';'
;

/* NOTE: assignment MUST precede expression, else parsing a simple assignment */
/* will throw a SyntaxError. */
simple_stmt:
  assignment
| type_alias
| star_expressions
| return_stmt
| raise_stmt
| PASS
| del_stmt
| yield_stmt
| assert_stmt
| BREAK
| CONTINUE
| global_stmt
| nonlocal_stmt
;

compound_stmt:
  function_def
| if_stmt
| class_def
| with_stmt
| for_stmt
| try_stmt
| while_stmt
| match_stmt
;

/* SIMPLE STATEMENTS */
/* ================= */

/* NOTE: annotated_rhs may start with 'yield'; yield_expr must start with 'yield' */
assignment:
  NAME ':' expression annotated_rhs_opt
| '(' single_target ')' ':' expression annotated_rhs_opt
| single_subscript_attribute_target ':' expression annotated_rhs_opt
| star_targets '=' star_targets_list annotated_rhs type_comment_opt
| single_target augassign annotated_rhs   /*---- ~ used here -------*/
;

star_targets_list:
  %empty
| star_targets_list star_targets '='
;

annotated_rhs_opt:
  %empty
| '=' annotated_rhs
;

type_comment_opt:
  %empty
| TYPE_COMMENT
;

annotated_rhs:
  yield_expr
| star_expressions
;

augassign:
  PLUSEQUAL
| MINEQUAL
| STAREQUAL
| ATEQUAL
| SLASHEQUAL
| PERCENTEQUAL
| AMPEREQUAL
| VBAREQUAL
| CIRCUMFLEXEQUAL
| LEFTSHIFTEQUAL
| RIGHTSHIFTEQUAL
| DOUBLESTAREQUAL
| DOUBLESLASHEQUAL
;

return_stmt:
  RETURN star_expressions_opt
;

star_expressions_opt:
  %empty
| star_expressions
;

raise_stmt:
  RAISE
| RAISE expression from_expr_opt
;

from_expr_opt:
  %empty
| FROM expression
;

global_stmt:
  GLOBAL NAME name_list
;

nonlocal_stmt:
  NONLOCAL NAME name_list
;

name_list:
  %empty
| name_list ',' NAME
;

del_stmt:
  DEL del_targets
;

yield_stmt:
  yield_expr
;

assert_stmt:
  ASSERT expression comma_expr_opt
;

comma_expr_opt:
  %empty
| ',' expression
;

comma_opt:
  %empty
| ','
;

as_NAME_opt:
  %empty
| AS NAME
; 

/* COMPOUND STATEMENTS */
/* =================== */

/* Common elements */
/* --------------- */

block:
  NEWLINE INDENT statements DEDENT
| simple_stmts
;

decorators: 
  '@' named_expression NEWLINE AT_named_expression_newline_list
;

AT_named_expression_newline_list:
  %empty
| AT_named_expression_newline_list '@' named_expression NEWLINE 
;

/* Class definitions */
/* ----------------- */

class_def:
  decorators class_def_raw
| class_def_raw
;

class_def_raw:
  CLASS NAME type_params_opt parenthesis_arguments_opt ':' block
;

type_params_opt:
  %empty
| type_params 
;

parenthesis_arguments_opt:
  %empty 
| '(' arguments_opt ')'
;

arguments_opt:
  %empty
| arguments 
;


/* Function definitions */
/* -------------------- */

function_def:
  decorators function_def_raw
| function_def_raw
;

function_def_raw:
  DEF NAME type_params_opt '(' params_opt ')' arrow_expr_opt ':' func_type_comment_opt block
| ASYNC DEF NAME type_params_opt '(' params_opt ')' arrow_expr_opt ':' func_type_comment_opt block
;

/*
ARROW : '->'
*/

arrow_expr_opt:
  %empty
| ARROW expression 
;

func_type_comment_opt:
  %empty
| func_type_comment
;

params_opt:
  %empty
| params
;

/* Function parameters */
/* ------------------- */

params:
  parameters
;

parameters:
  slash_no_default param_no_default_list param_with_default_list star_etc_opt
| slash_with_default param_with_default_list star_etc_opt
| param_no_default param_no_default_list param_with_default_list star_etc_opt
| param_with_default param_with_default_list star_etc_opt
| star_etc
;

param_no_default_list: 
  %empty
| param_no_default_list param_no_default 
;

param_with_default_list: 
  %empty
| param_with_default_list param_with_default 
;

star_etc_opt:
  %empty
| star_etc
;

/* Some duplication here because we can't write (',' | &')'), */
/* which is because we don't support empty alternatives (yet). */

slash_no_default:
  param_no_default param_no_default_list '/' ','
| param_no_default param_no_default_list '/'
;

slash_with_default:
  param_no_default_list param_with_default param_with_default_list '/' ','
| param_no_default_list param_with_default param_with_default_list '/' 
;

star_etc:
  '*' param_no_default param_maybe_default_list kwds_opt
| '*' param_no_default_star_annotation param_maybe_default_list kwds_opt
| '*' ',' param_maybe_default param_maybe_default_list kwds_opt
| kwds
;

param_maybe_default_list:
  %empty
| param_maybe_default_list param_maybe_default
;

kwds_opt:
  %empty
| kwds
;

kwds:
  '**' param_no_default
;

/* One parameter.  This *includes* a following comma and type comment. */
/* */
/* There are three styles: */
/* - No default */
/* - With default */
/* - Maybe with default */
/* */
/* There are two alternative forms of each, to deal with type comments: */
/* - Ends in a comma followed by an optional type comment */
/* - No comma, optional type comment, must be followed by close paren */
/* The latter form is for a final parameter without trailing comma. */
/* */

param_no_default:
  param ',' TYPE_COMMENT_opt
| param TYPE_COMMENT_opt
;

TYPE_COMMENT_opt:
  %empty
| TYPE_COMMENT
;

param_no_default_star_annotation:
  param_star_annotation ',' TYPE_COMMENT_opt
| param_star_annotation TYPE_COMMENT_opt 
;

param_with_default:
  param default ',' TYPE_COMMENT_opt
| param default TYPE_COMMENT_opt
;

param_maybe_default:
  param default_opt ',' TYPE_COMMENT_opt
| param default_opt TYPE_COMMENT_opt 
;

param_default_opt:
  %empty
| param_default 
;

param:
  NAME annotation_opt
;

annotation_opt:
  %empty
| annotation
;

param_star_annotation:
  NAME star_annotation
;

annotation:
  ':' expression
;

star_annotation:
  ':' star_expression
;

default:
  '=' expression
| invalid_default
;

/* If statement */
/* ------------ */

if_stmt:
  IF named_expression ':' block elif_stmt
| IF named_expression ':' block else_block_opt
;

else_block_opt:
  %empty
| else_block 
;

elif_stmt:
  ELIF named_expression ':' block elif_stmt
| ELIF named_expression ':' block else_block_opt 
;

else_block:
  ELSE ':' block
;

/* While statement */
/* --------------- */

while_stmt:
  WHILE named_expression ':' block else_block_opt
;

/* For statement */
/* ------------- */

for_stmt:
  FOR star_targets IN star_expressions ':' TYPE_COMMENT_opt block else_block_opt /*---- ~ used here -------*/
| ASYNC FOR star_targets IN star_expressions ':' TYPE_COMMENT_opt block else_block_opt /*---- ~ used here -------*/

/* With statement */
/* -------------- */

with_stmt:
  WITH '(' with_item comma_with_item_list comma_opt ')' ':' block
| WITH with_item comma_with_item_list ':' TYPE_COMMENT_opt block
| ASYNC WITH '(' with_item comma_with_item_list comma_opt ')' ':' block
| ASYNC WITH with_item comma_with_item_list ':' TYPE_COMMENT_opt block
;

with_item:
  expression AS star_target 
| expression
;

/* Try statement */
/* ------------- */

/* Except statement */
/* ---------------- */

/* Match statement */
/* --------------- */

match_stmt:
  MATCH subject_expr ':' NEWLINE INDENT case_block case_block_list DEDENT
;

case_block_list:
  %empty
| case_block_list case_block
;

subject_expr:
  star_named_expression ',' star_named_expressions_opt
| named_expression
;

star_named_expressions_opt:
  %empty
| star_named_expressions
;

case_block:
  CASE patterns guard_opt ':' block
;

guard_opt:
  %empty
| guard
;

guard:
  IF named_expression
;

patterns:
  open_sequence_pattern
| pattern
;

pattern:
  as_pattern
| or_pattern
;

as_pattern:
  or_pattern AS pattern_capture_target
;

or_pattern:
  closed_pattern vertical_slash_closed_pattern_list
;

vertical_slash_closed_pattern_list:
  %empty
| vertical_slash_closed_pattern_list '|' closed_pattern
;

closed_pattern:
  literal_pattern
| capture_pattern
| wildcard_pattern
| value_pattern
| group_pattern
| sequence_pattern
| mapping_pattern
| class_pattern
;

/* Literal patterns are used for equality and identity constraints */
literal_pattern:
  signed_number 
| complex_number
| strings
| NONE
| TRUE
| FALSE
;

/* Literal expressions are used to restrict permitted mapping pattern keys */
literal_expr:
  signed_number 
| complex_number
| strings
| NONE
| TRUE
| FALSE
;

complex_number:
  signed_real_number '+' imaginary_number
| signed_real_number '-' imaginary_number
;

signed_number:
  NUMBER
| '-' NUMBER
;

signed_real_number:
  real_number
| '-' real_number
;

real_number:
  NUMBER
;

imaginary_number:
  NUMBER
;

capture_pattern:
  pattern_capture_target
;

pattern_capture_target:
  NAME 
;

wildcard_pattern:
  "_"
;

value_pattern:
  attr 
;

attr:
  name_or_attr '.' NAME
;

name_or_attr:
  attr
| NAME
;

group_pattern:
  '(' pattern ')'
;

sequence_pattern:
  '[' maybe_sequence_pattern_opt ']'
| '(' open_sequence_pattern_opt ')'
;

maybe_sequence_pattern_opt:
  %empty
| maybe_sequence_pattern
;

open_sequence_pattern_opt:
  %empty
| open_sequence_pattern
;

open_sequence_pattern:
  maybe_star_pattern ',' maybe_sequence_pattern_opt
;

maybe_sequence_pattern:
  maybe_star_pattern comma_maybe_star_pattern_list comma_opt
;
  
comma_maybe_star_pattern_list:
  %empty
| comma_maybe_star_pattern_list ',' maybe_star_pattern
;

maybe_star_pattern:
  star_pattern
| pattern
;

star_pattern:
  '*' pattern_capture_target
| '*' wildcard_pattern
;

mapping_pattern:
  '{' '}'
| '{' double_star_pattern comma_opt '}'
| '{' items_pattern ',' double_star_pattern comma_opt '}'
| '{' items_pattern comma_opt '}'
;

items_pattern:
  key_value_pattern comma_key_value_pattern_list
;

comma_key_value_pattern_list:
  %empty
| comma_key_value_pattern_list ',' key_value_pattern 
;

key_value_pattern:
  literal_expr_or_attr ':' pattern
;

literal_expr_or_attr:
  literal_expr
| attr
;

double_star_pattern:
  '**' pattern_capture_target
;

class_pattern:
  name_or_attr '(' ')'
| name_or_attr '(' positional_patterns comma_opt ')'
| name_or_attr '(' keyword_patterns comma_opt ')'
| name_or_attr '(' positional_patterns ',' keyword_patterns comma_opt ')'
;

positional_patterns:
  pattern comma_pattern_list
;

comma_pattern_list:
  %empty
| comma_pattern_list ',' pattern
;

keyword_patterns:
  keyword_pattern comma_keyword_pattern_list
;

comma_keyword_pattern_list:
  %empty 
| comma_keyword_pattern_list ',' keyword_pattern
;

keyword_pattern:
  NAME '=' pattern
;

/* Type statement */
/* --------------- */

type_alias:
  TYPE NAME type_params_opt '=' expression
;

/* Type parameter declaration */
/* -------------------------- */

type_params:
  '[' type_param_seq  ']'
;

type_param_seq:
  type_param comma_type_param_list
;

comma_type_param_list:
  %empty
| comma_type_param_list ',' type_param comma_opt
;

type_param:
  NAME type_param_bound_opt
| '*' NAME ':' expression
| '*' NAME
| '**' NAME ':' expression
| '**' NAME
;

type_param_bound_opt:
  %empty
| type_param_bound
;

type_param_bound:
  ':' expression
;

/* EXPRESSIONS */
/* ----------- */

expressions:
  expression ',' expression comma_expr_list comma_opt
| expression ','
| expression
;

comma_expr_list:
  %empty
| comma_expr_list ',' expression  
;

expression:
  disjunction IF disjunction ELSE expression
| disjunction
| lambdef
;

yield_expr:
  YIELD FROM expression
| YIELD star_expressions_opt
;

star_expressions:
  star_expression ',' star_expression comma_star_expression_list comma_opt
| star_expression ','
| star_expression
;

comma_star_expression_list:
  %empty
| comma_star_expression_list ',' star_expression
;

star_expression:
  '*' bitwise_or
| expression
;

star_named_expressions:
  star_named_expression comma_star_named_expression_list comma_opt
;

comma_star_named_expression_list:
  %empty
| comma_star_named_expression_list ',' star_named_expression
;

star_named_expression:
  '*' bitwise_or
| named_expression
;

assignment_expression:
  NAME COLON_EQUAL expression
;

/*
 COLON_EQUAL : ':='
*/

named_expression:
  assignment_expression
| expression
;

disjunction:
  conjunction OR conjunction or_conjunction_list
| conjunction
;

or_conjunction_list:
  %empty
| or_conjunction_list OR conjunction
;

conjunction:
  inversion AND inversion and_inversion_list
| inversion
;

and_inversion_list:
  %empty
| and_inversion_list AND inversion
;

inversion:
  NOT inversion
| comparison
;

/* Comparison operators */
/* -------------------- */

comparison:
  bitwise_or compare_op_bitwise_or_pair compare_op_bitwise_or_pair_list
| bitwise_or
;

compare_op_bitwise_or_pair_list:
  %empty
| compare_op_bitwise_or_pair_list compare_op_bitwise_or_pair
;

compare_op_bitwise_or_pair:
  eq_bitwise_or
| noteq_bitwise_or
| lte_bitwise_or
| lt_bitwise_or
| gte_bitwise_or
| gt_bitwise_or
| notin_bitwise_or
| in_bitwise_or
| isnot_bitwise_or
| is_bitwise_or
;

eq_bitwise_or:
  DOUBLEEQUAL bitwise_or
;

/**
 DOUBLEEQUAL : '=='
/

noteq_bitwise_or:
  NOTEQUAL bitwise_or
;

/*
 NOTEQUAL: '!='
*/

lte_bitwise_or:
  LESSTHANEQUAL bitwise_or
;

lt_bitwise_or:
  LESSTHAN bitwise_or
;

gte_bitwise_or: 
  GREATERTHANEQUAL bitwise_or
;

gt_bitwise_or:
  GREATERTHAN bitwise_or
;

notin_bitwise_or:
  NOT IN bitwise_or
;

in_bitwise_or:
  IN bitwise_or
;

isnot_bitwise_or:
 IS NOT bitwise_or
;

is_bitwise_or:
  IS bitwise_or
;

/* Bitwise operators */
/* ----------------- */

bitwise_or:
  bitwise_or '|' bitwise_xor
| bitwise_xor
;

bitwise_xor:
  bitwise_xor '^' bitwise_and
| bitwise_and
;

bitwise_and:
  bitwise_and '&' shift_expr
| shift_expr
;

shift_expr:
  shift_expr LEFTSHIFT sum
| shift_expr RIGHTSHIFT sum
| sum
;

/* Arithmetic operators */
/* -------------------- */

sum:
  sum '+' term
| sum '-' term
| term
;

term:
  term '*' factor
| term '/' factor
| term DOUBLESLASH factor
| term '%' factor
| term '@' factor
| factor
;

factor:
  '+' factor
| '-' factor
| '~' factor
| power
;

power:
  await_primary DOUBLESTAR factor
| await_primary
;

/* Primary elements */
/* ---------------- */

/* Primary elements are things like "obj.something.something", "obj[something]", "obj */(something)", "obj" ...

await_primary:
  AWAIT primary
| primary
;

primary:
  primary '.' NAME
| primary genexp
| primary '(' arguments_opt ')'
| primary '[' slices ']'
| atom
;

slices:
  slice
| slice_or_starred_expression comma_slice_or_starred_expression_list comma_opt
;

slice_or_starred_expression:
  slice
| starred_expression
;

comma_slice_or_starred_expression_list:
  %empty
| comma_slice_or_starred_expression_list ',' slice_or_starred_expression
;

slice:
  expression_opt ':' expression_opt colon_expression_opt_opt
| named_expression
;

expression_opt:
  %empty
| expression
;

colon_expression_opt_opt:
  %empty
| ':' expression_opt
;

atom:
  NAME
| TRUE
| FALSE
| NONE
| strings
| NUMBER
| group
| list
;


group:
  '(' yield_expr_or_named_expr ')'
;

yield_expr_or_named_expr:
  yield_expr
| named_expression
;

/* Lambda functions */
/* ---------------- */


/* LITERALS */
/* ======== */


string: 
  STRING
;

strings:
  string string_list
;

string_list:
  %empty
| string_list string
; 

list:
    | '[' [star_named_expressions] ']'


/* Dicts */
/* ----- */


/* Comprehensions & Generators */
/* --------------------------- */

for_if_clauses:
    | for_if_clause+

for_if_clause:
    | ASYNC 'for' star_targets 'in' ~ disjunction ('if' disjunction )*
    | 'for' star_targets 'in' ~ disjunction ('if' disjunction )*


/* FUNCTION CALL ARGUMENTS */
/* ======================= */

arguments:
    | args [','] &')'

args:
    | ','.(starred_expression | ( assignment_expression | expression !':=') !'=')+ [',' kwargs ]
    | kwargs

kwargs:
    | ','.kwarg_or_starred+ ',' ','.kwarg_or_double_starred+
    | ','.kwarg_or_starred+
    | ','.kwarg_or_double_starred+

starred_expression:
    | '*' expression

kwarg_or_starred:
    | NAME '=' expression
    | starred_expression

kwarg_or_double_starred:
    | NAME '=' expression
    | '**' expression

/* ASSIGNMENT TARGETS */
/* ================== */

/* Generic targets */
/* --------------- */

/* NOTE: star_targets may contain *bitwise_or, targets may not. */
star_targets:
    | star_target !','
    | star_target (',' star_target )* [',']

star_targets_list_seq: ','.star_target+ [',']

star_targets_tuple_seq:
    | star_target (',' star_target )+ [',']
    | star_target ','

star_target:
    | '*' (!'*' star_target)
    | target_with_star_atom

target_with_star_atom:
    | t_primary '.' NAME !t_lookahead
    | t_primary '[' slices ']' !t_lookahead
    | star_atom

star_atom:
    | NAME
    | '(' target_with_star_atom ')'
    | '(' [star_targets_tuple_seq] ')'
    | '[' [star_targets_list_seq] ']'

single_target:
    | single_subscript_attribute_target
    | NAME
    | '(' single_target ')'

single_subscript_attribute_target:
    | t_primary '.' NAME !t_lookahead
    | t_primary '[' slices ']' !t_lookahead

t_primary:
    | t_primary '.' NAME &t_lookahead
    | t_primary '[' slices ']' &t_lookahead
    | t_primary genexp &t_lookahead
    | t_primary '(' [arguments] ')' &t_lookahead
    | atom &t_lookahead

t_lookahead: '(' | '[' | '.'

/* Targets for del statements */
/* -------------------------- */

del_targets: ','.del_target+ [',']

del_target:
    | t_primary '.' NAME !t_lookahead
    | t_primary '[' slices ']' !t_lookahead
    | del_t_atom

del_t_atom:
    | NAME
    | '(' del_target ')'
    | '(' [del_targets] ')'
    | '[' [del_targets] ']'

/* TYPING ELEMENTS */
/* --------------- */

/* type_expressions allow */** but ignore them */
type_expressions:
    | ','.expression+ ',' '*' expression ',' '**' expression
    | ','.expression+ ',' '*' expression
    | ','.expression+ ',' '**' expression
    | '*' expression ',' '**' expression
    | '*' expression
    | '**' expression
    | ','.expression+

func_type_comment:
    | NEWLINE TYPE_COMMENT &(NEWLINE INDENT)   /* Must be followed by indented block */
    | TYPE_COMMENT

/* ========================= END OF THE GRAMMAR =========================== */



/* ========================= START OF INVALID RULES ======================= */

%%
