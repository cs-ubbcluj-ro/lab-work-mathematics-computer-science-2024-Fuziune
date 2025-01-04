%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
extern int yylex();
%}

/* Tokens */
%token INT MAIN BOOL CIN COUT RETURN STRUCT WHILE IF ELSE TRUE FALSE
%token IDENTIFIER CONSTANT
%token PLUS MINUS MUL DIV ASSIGN EQ NEQ LT LEQ GT GEQ LPAREN RPAREN LBRACE RBRACE SEMICOLON SHIFTIN SHIFTOUT

/* Operator precedence */
%left PLUS MINUS
%left MUL DIV

%%

program:
    INT MAIN LPAREN RPAREN LBRACE stmt_list RETURN expression SEMICOLON RBRACE
    {
        printf("Program parsed successfully.\n");
    }
;

stmt_list:
    stmt
    | stmt stmt_list
;

stmt:
    assign_stmt
    | iostmt
    | ifstmt
    | whilestmt
    | struct_stmt
;

assign_stmt:
    IDENTIFIER ASSIGN expression SEMICOLON
;

iostmt:
    CIN SHIFTIN IDENTIFIER SEMICOLON
    | COUT SHIFTOUT expression SEMICOLON
;

ifstmt:
    IF LPAREN condition RPAREN LBRACE stmt_list RBRACE
    | IF LPAREN condition RPAREN LBRACE stmt_list RBRACE ELSE LBRACE stmt_list RBRACE
;

whilestmt:
    WHILE LPAREN condition RPAREN LBRACE stmt_list RBRACE
;

struct_stmt:
    STRUCT IDENTIFIER LBRACE decl_list RBRACE SEMICOLON
;

decl_list:
    decl
    | decl decl_list
;

decl:
    INT IDENTIFIER SEMICOLON
    | BOOL IDENTIFIER SEMICOLON
;

expression:
    term
    | expression PLUS term
    | expression MINUS term
;

term:
    factor
    | term MUL factor
    | term DIV factor
;

factor:
    LPAREN expression RPAREN
    | IDENTIFIER
    | CONSTANT
    | TRUE
    | FALSE
;

condition:
    expression relation expression
;

relation:
    EQ
    | NEQ
    | LT
    | LEQ
    | GT
    | GEQ
;

%%

/* Error handling */
void yyerror(const char *s) {
    printf("Syntax error: %s\n", s);
}
