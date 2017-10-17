%{
#include <iostream>
#include <string>
#include <fstream>
#include <cstdio>
#include <sstream>
#include <map>
#include <vector>

#define YYSTYPE atributos
using namespace std;

typedef struct ATRIBUTOS{
	string label;
	string traducao;
	string tipo;
	string tipo_traducao;
	int tamanho;
}atributos;

typedef struct VARIAVEL
{
	string tipo;
	string tipo_traducao;
	string nome_temp;
}Variavel;

int yylex();
void yyerror(sting);
string cria_nome_nova_temp();






%}

%token TK_INT TK_FLOAT TK_CHAR TK_ID
%token TK_MAIN TK_TIPO_INT TK_TIPO_BOOL TK_TIPO_FLOAT TK_TIPO_CHAR TK_TIPO_ID
%token TK_SOMA_ou_SUBTRACAO TK_DIVISAO_ou_MULTIPLICACAO // para quando for fazer soma = + ou -
%token TK_MENOR_QUE TK_MAIOR_QUE TK_IGUAL TK_DIFERENTE TK_MENOR_IGUAL TK_MAIOR_IGUAL TK_AND TK_OR TK_NOT
%token TK_ATRIBUICAO TK_CAST_DO_INT TK_CAST_DO_FLOAT
%token TK_FIM TK_ERROR

%start S

//precedencia de operações
%left TK_SOMA_ou_SUBTRACAO
%left TK_DIVISAO_ou_MULTIPLICACAO
%left TK_RELACIONAL
%left TK_LOGICO

%%

S 							: TK_TIPO_INT TK_MAIN '( '')'BLOCO
                {
                  cout << "/*Compilador FOCA*/\n" << "#include <iostream>\n#include<string.h>\n#include<stdio.h>\nint main(void)\n{\n" << $5.traducao << "\treturn 0;\n}" << endl; 
                };

BLOCO						: '{' COMANDOS '}'
                {
                  $$.traducao = $2.traducao; //todos os comandos sendo atribuido em $$
                };

COMANDOS				: COMANDO COMANDOS
                {
                  $$.traducao = $1.traducao + $2.traducao; //um comando(expressao)
                }
                |
                {
                  $$.traducao = "" //EOF
                }
                ;

COMANDO 				: E ';'
								;

E 							: OP_ARITMETICA
                | OP_LOGICA
                | OP_RELACIONAL
                | ATRIBUICAO
                ;

OP_ARITMETICA		: E TK_SOMA_ou_SUBTRACAO E
                {
                	$$.label = "temp" + cria_nome_nova_temp();
  								$$.traducao = $1.traducao + $3.traducao;//
  								if($1.tipo != $3.tipo){
                    		//implementar cast
                  }else{
                      	$$.tipo = $1.tipo;
                    		//linha para colocar ela no mapa
                    
                    ///TO BOLADAO FODASSE PAREI
                    		$$.traducao = $1.traducao + $3.traducao + "\t" + $$.tipo + " " + $$.label + " = " + $1.label + " + " + $3.label +" ;\n\n";
                    
                    		$$.traducao += '\t' + $$.label + " = " + $1.label + $2.traducao + $3.label + ";\n";
                    
                    		$$.traducao += 't' + $$.tipo +
                  }
    
                }
  
/*
OP_ARITMETICA 	: SOMA 
                | SUBTRACAO 
                | DIVISAO
                | MUTIPLICACAO				 
                ;
//eu queria chamar soma e subtracao de uma coisa só, mas depois faz isso
//ah, mas o raj faz isso, f-se, entenda soma como + ou -, se achar q ta merda essa nomenclatura é só botar essas regras aí em baixo dentro de OP_aritmetica
SOMA 						: E TK_SOMA_ou_SUBTRACAO E
                {
									
                }
*/ //AH FODASSEEE, vou fazer o q eu disse no ultimo comentario, to me sentindo solitario




















//FUNÇOES 
string cria_nome_nova_temp(){
	static int n = 0;
	n++;
    return "temp" + to_string(n);
}

variavel cria_var(string nome_temp){
    variavel * var =  malloc(sizeof(variavel));
    var -> nome_temp = nome_temp;
	return var;
}

typedef map<label, Variavel> MapaVar;

string declara_vars(MapaVar mapa_vars){
   	string s = "";
	for (MapVar::iterator it = mapa_vars.begin(); it!=mapa_vars.end(); ++it) {
    	s += '\t' + it->second.tipo + ' ' + it->second.nome_temp + ";\n";
	}
    return s;
}
