%{
#include "y.tab.h" // Include token definitions from yacc
extern int yylval; // To pass token values
%}

digit        [0-9]
letter       [a-zA-Z_]
identifier   {letter}({letter}|{digit})*
constant     {digit}+|true|false
operator     "+"|"-"|"*"|"/"|"=="|"!="|"<"|"<="|">"|">="
keyword      "int"|"main"|"bool"|"cin"|"cout"|"return"|"struct"|"while"|"if"|"else"
punctuation  "(" | ")" | "{" | "}" | ";" | "<<" | ">>"

%%

"int"       { return INT; }
"main"      { return MAIN; }
"bool"      { return BOOL; }
"cin"       { return CIN; }
"cout"      { return COUT; }
"return"    { return RETURN; }
"struct"    { return STRUCT; }
"while"     { return WHILE; }
"if"        { return IF; }
"else"      { return ELSE; }

"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
";"         { return SEMICOLON; }
"<<"        { return SHIFTIN; }
">>"        { return SHIFTOUT; }
"="         { return ASSIGN; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"=="        { return EQ; }
"!="        { return NEQ; }
"<"         { return LT; }
"<="        { return LEQ; }
">"         { return GT; }
">="        { return GEQ; }

{identifier} {
    yylval = strdup(yytext); // Pass identifier text
    return IDENTIFIER;
}

{constant} {
    yylval = atoi(yytext); // Convert to integer
    return CONSTANT;
}

[ \t\n]+    { /* Skip whitespace */ }
.           { printf("Unknown character: %s\n", yytext); }

%%
