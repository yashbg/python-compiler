%{
%}

%%

/* STARTING RULES */
/* ============== */

file:
  statements NEWLINE
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
| BREAK
| CONTINUE
| global_stmt
;

compound_stmt:
  function_def
| if_stmt
| class_def
| for_stmt
| while_stmt
;

/* SIMPLE STATEMENTS */
/* ================= */

/* NOTE: annotated_rhs may start with 'yield'; yield_expr must start with 'yield' */
assignment:
  NAME ':' expression annotated_rhs_opt
| '(' single_target ')' ':' expression annotated_rhs_opt
| single_subscript_attribute_target ':' expression annotated_rhs_opt
| star_targets '=' star_targets_list annotated_rhs type_comment_opt
| single_target augassign annotated_rhs 
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
  star_expressions
;

augassign:
  PLUSEQUAL
| MINEQUAL
| STAREQUAL
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

global_stmt:
  GLOBAL NAME comma_name_list
;

comma_name_list:
  %empty
| comma_name_list ',' NAME
;

star_expressions_opt:
  %empty
| star_expressions
;

comma_expr_opt:
  %empty
| ',' expression
;

comma_opt:
  %empty
| ','
;

/* COMPOUND STATEMENTS */
/* =================== */

/* Common elements */
/* --------------- */

block:
  NEWLINE INDENT statements DEDENT
| simple_stmts
;

/* Class definitions */
/* ----------------- */

class_def:
  class_def_raw
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
  function_def_raw
;

function_def_raw:
  DEF NAME type_params_opt '(' params_opt ')' arrow_expr_opt ':' block
;

/*
ARROW : '->'
*/

arrow_expr_opt:
  %empty
| ARROW expression 
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
  DOUBLESTAR param_no_default
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
  FOR star_targets IN star_expressions ':' TYPE_COMMENT_opt block else_block_opt
;

/* With statement */
/* -------------- */

/* Try statement */
/* ------------- */

/* Except statement */
/* ---------------- */

/* Match statement */
/* --------------- */

star_named_expressions_opt:
  %empty
| star_named_expressions
;

/* Type statement */
/* --------------- */

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
| DOUBLESTAR NAME ':' expression
| DOUBLESTAR NAME
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


named_expression:
  expression
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
  primary
;

primary:
  primary '.' NAME
| primary '(' arguments_opt ')'
| atom
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
  '(' named_expression ')'
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
  '[' star_named_expressions_opt ']'
;

/* Dicts */
/* ----- */

/* Comprehensions & Generators */
/* --------------------------- */

/* FUNCTION CALL ARGUMENTS */
/* ======================= */

arguments:
  args comma_opt
;

args:
  expression comma_expr_list;
;

starred_expression:
  '*' expression
;

/* ASSIGNMENT TARGETS */
/* ================== */

/* Generic targets */
/* --------------- */

/* NOTE: star_targets may contain *bitwise_or, targets may not. */

star_targets:
  star_target
| star_target comma_star_target_list comma_opt
;

star_targets_list_seq:
  star_target comma_star_target_list comma_opt
;

comma_star_target_list:
  %empty
| comma_star_target_list ',' star target
;

star_target:
  '*' star_target
| target_with_star_atom
;

target_with_star_atom:
  t_primary '.' NAME
| star_atom
;

star_atom:
  NAME
| '(' target_with_star_atom ')'
| '[' star_targets_list_seq_opt ']'
;

star_targets_list_seq_opt:
  %empty
| star_targets_list_seq
;

single_target:
  single_subscript_attribute_target
| NAME
| '(' single_target ')'
;

single_subscript_attribute_target:
  t_primary '.' NAME
;

t_primary:
  t_primary '.' NAME
| t_primary '(' arguments_opt ')' 
| atom 
;

t_lookahead:
  '(' 
| '['
| '.'
;

/* Targets for del statements */
/* -------------------------- */

/* TYPING ELEMENTS */
/* --------------- */

/* ========================= START OF INVALID RULES ======================= */

%%
