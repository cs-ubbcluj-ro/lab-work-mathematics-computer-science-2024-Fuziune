%{
#include <stdio.h>
#include <stdlib.h>

// Function to handle syntax errors
void yyerror(const char *s);

// Global variables to track line/column numbers
extern int line_num, col_num;

// Array to store production indexes
int production_index = 1;

%}

%token INT MAIN BOOL CIN COUT RETURN STRUCT WHILE IF ELSE
%token IDENTIFIER CONSTANT
%token PLUS MINUS MUL DIV ASSIGN EQ NEQ LT LEQ GT GEQ
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON SHIFTIN SHIFTOUT
%left PLUS MINUS
%left MUL DIV

%%

// Grammar Rules
program:
      INT MAIN LPAREN RPAREN LBRACE stmt_list RETURN expression SEMICOLON RBRACE {
          printf("Program syntactic correct\n");
      }
    ;

stmt_list:
      stmt {
          printf("Production %d: <stmt_list> ::= <stmt>\n", production_index++);
      }
    | stmt stmt_list {
          printf("Production %d: <stmt_list> ::= <stmt> <stmt_list>\n", production_index++);
      }
    ;

stmt:
      assign_stmt {
          printf("Production %d: <stmt> ::= <assign_stmt>\n", production_index++);
      }
    | iostmt {
          printf("Production %d: <stmt> ::= <iostmt>\n", production_index++);
      }
    | ifstmt {
          printf("Production %d: <stmt> ::= <ifstmt>\n", production_index++);
      }
    | whilestmt {
          printf("Production %d: <stmt> ::= <whilestmt>\n", production_index++);
      }
    | struct_stmt {
          printf("Production %d: <stmt> ::= <struct_stmt>\n", production_index++);
      }
    ;

assign_stmt:
      IDENTIFIER ASSIGN expression SEMICOLON {
          printf("Production %d: <assign_stmt> ::= <identifier> '=' <expression> ';'\n", production_index++);
      }
    ;

iostmt:
      CIN SHIFTIN IDENTIFIER SEMICOLON {
          printf("Production %d: <iostmt> ::= 'cin' '>>' <identifier> ';'\n", production_index++);
      }
    | COUT SHIFTOUT expression SEMICOLON {
          printf("Production %d: <iostmt> ::= 'cout' '<<' <expression> ';'\n", production_index++);
      }
    ;

// Add other grammar rules similarly...

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error at line %d, column %d: %s\n", line_num, col_num, s);
    exit(EXIT_FAILURE);
}

int main() {
    // Open input file
    extern FILE *yyin;
    yyin = fopen("input.txt", "r");
    if (!yyin) {
        perror("Error opening input file");
        return EXIT_FAILURE;
    }

    // Start parsing
    if (yyparse() == 0) {
        printf("Parsing complete\n");
    }

    fclose(yyin);
    return 0;
}
