%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int line_num = 1;
int col_num = 1;

typedef struct SymbolTable {
    char *name;
    int index;
    struct SymbolTable *next;
} SymbolTable;

SymbolTable *symbol_table = NULL;
int symbol_count = 0;

// PIF and ST file pointers
FILE *pif_file, *st_file;

void add_to_symbol_table(const char *name) {
    SymbolTable *new_symbol = (SymbolTable *)malloc(sizeof(SymbolTable));
    new_symbol->name = strdup(name);
    new_symbol->index = symbol_count++;
    new_symbol->next = symbol_table;
    symbol_table = new_symbol;

    // Write to the ST file
    fprintf(st_file, "Symbol Table Entry: %s -> %d\n", name, new_symbol->index);
}

int lookup_symbol(const char *name) {
    SymbolTable *current = symbol_table;
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current->index;
        }
        current = current->next;
    }
    return -1; // Not found
}

void print_pif(const char *token, const char *type) {
    // Write to the PIF file
    fprintf(pif_file, "PIF: (%s, %s)\n", token, type);
}

%}

digit   [0-9]
letter  [a-zA-Z_]
identifier    {letter}({letter}|{digit})*
constant       {digit}+|true|false
operator       "+"|"-"|"*"|"/"|"=="|"!="|"<"|"<="|">"|">="
keyword        "int"|"main"|"bool"|"cin"|"cout"|"return"|"struct"|"while"|"if"|"else"
punctuation    "(" | ")" | "{" | "}" | ";" | "<<" | ">>"

%%
"int"           { print_pif(yytext, "KEYWORD"); }
"main"          { print_pif(yytext, "KEYWORD"); }
"bool"          { print_pif(yytext, "KEYWORD"); }
"cin"           { print_pif(yytext, "KEYWORD"); }
"cout"          { print_pif(yytext, "KEYWORD"); }
"return"        { print_pif(yytext, "KEYWORD"); }
"struct"        { print_pif(yytext, "KEYWORD"); }
"while"         { print_pif(yytext, "KEYWORD"); }
"if"            { print_pif(yytext, "KEYWORD"); }
"else"          { print_pif(yytext, "KEYWORD"); }

"("             { print_pif(yytext, "PUNCTUATION"); }
")"             { print_pif(yytext, "PUNCTUATION"); }
"{"             { print_pif(yytext, "PUNCTUATION"); }
"}"             { print_pif(yytext, "PUNCTUATION"); }
";"             { print_pif(yytext, "PUNCTUATION"); }
"<<"            { print_pif(yytext, "OPERATOR"); }
">>"            { print_pif(yytext, "OPERATOR"); }
"="             { print_pif(yytext, "OPERATOR"); }
"+"             { print_pif(yytext, "OPERATOR"); }
"-"             { print_pif(yytext, "OPERATOR"); }
"*"             { print_pif(yytext, "OPERATOR"); }
"/"             { print_pif(yytext, "OPERATOR"); }
"=="            { print_pif(yytext, "OPERATOR"); }
"!="            { print_pif(yytext, "OPERATOR"); }
"<"             { print_pif(yytext, "OPERATOR"); }
"<="            { print_pif(yytext, "OPERATOR"); }
">"             { print_pif(yytext, "OPERATOR"); }
">="            { print_pif(yytext, "OPERATOR"); }

{identifier}    { 
                    if (lookup_symbol(yytext) == -1) {
                        add_to_symbol_table(yytext);
                    }
                    print_pif(yytext, "IDENTIFIER");
                }
{constant}      { print_pif(yytext, "CONSTANT"); }

[ \t\n]+        { col_num = 1; line_num++; } // Skip whitespace and newlines
.               { printf("LEXICAL ERROR: Invalid character '%s' at line %d, column %d\n", yytext, line_num, col_num); }

%%

int main(int argc, char **argv)
{
    // Open output files
    pif_file = fopen("pif_output.txt", "w");
    if (!pif_file) {
        perror("Error opening PIF output file");
        return EXIT_FAILURE;
    }

    st_file = fopen("st_output.txt", "w");
    if (!st_file) {
        perror("Error opening ST output file");
        return EXIT_FAILURE;
    }

    if (argc > 1) {
        FILE *fp = fopen(argv[1], "r");
        if (!fp) {
            perror("File opening failed");
            return EXIT_FAILURE;
        }
        yyin = fp;
    }

    // Scan the input file
    yylex();

    // Close output files
    fclose(pif_file);
    fclose(st_file);

    return 0;
}
