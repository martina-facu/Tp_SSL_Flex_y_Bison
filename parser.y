%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);

%}
%union{
   char* cadena;
   int num;
}

%token ASIGNACION PUNTOYCOMA COMA SUMA RESTA PARENTIZQUIERDO PARENTDERECHO FDT
%token <cadena> IDENTIFICADOR INICIO FIN LEER ESCRIBIR
%token <num> CONSTANTE

%%

objetivo: programa FDT
;
programa: INICIO sentencias FIN
;
sentencias: sentencias sentencia 
| sentencia
;
sentencia: IDENTIFICADOR {if(yyleng > 32){yyerror("ERROR SEMANTICO, se detecto un identificador con mas de 32 caracteres\n"); return 0;}} ASIGNACION expresion PUNTOYCOMA
| LEER PARENTIZQUIERDO identificadores PARENTDERECHO PUNTOYCOMA
| ESCRIBIR PARENTIZQUIERDO expresiones PARENTDERECHO PUNTOYCOMA
;
identificadores: identificador 
| identificadores COMA identificador
;
identificador: IDENTIFICADOR
;
expresiones: expresion 
| expresiones COMA expresion
;
expresion: primaria 
| expresion operadorAditivo primaria
;
primaria: IDENTIFICADOR 
| CONSTANTE 
| PARENTIZQUIERDO expresion PARENTDERECHO
;
operadorAditivo: SUMA 
| RESTA
;

%%

int main(){
   yyparse();
}
void yyerror(char* s){
   printf("%s", s); 
}
int yywrap(){
   return 1;
}