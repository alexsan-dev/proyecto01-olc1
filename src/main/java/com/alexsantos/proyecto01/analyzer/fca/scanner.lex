package com.alexsantos.proyecto01.analyzer.fca;
import java_cup.runtime.Symbol;

%%
%class FCAScanner
%public
%line
%column
%cup
%unicode
%ignorecase

%init{
    yyline = 1;
    yycolumn = 1;
%init}

NUMBER=[0-9]+
LETTER=[a-zA-ZÑñ]+
DECIMAL={NUMBER} ("."? [0-9]*)?
ID=({LETTER}|("_"{LETTER}))({LETTER}|{NUMBER}|"_")*

STRTEXT=[\"\“\'] [^\"\”\'\n]* [\"\”\'\n]
MULTICOMMENT=(#\*[^\*]*\*#)
WHITESPACE=[ \t\f\n\r]+
COMMENT=##.*[\n\r]
%%

"," {return new Symbol(sym.comma,yycolumn,yyline,yytext());}
":" {return new Symbol(sym.colom,yycolumn,yyline,yytext());}
"=" {return new Symbol(sym.equals,yycolumn,yyline,yytext());}
";" {return new Symbol(sym.semicolom,yycolumn,yyline,yytext());}
"{" {return new Symbol(sym.openbracket,yycolumn,yyline,yytext());}
"}" {return new Symbol(sym.closebracket,yycolumn,yyline,yytext());}
"(" {return new Symbol(sym.openparenthesis,yycolumn,yyline,yytext());}
")" {return new Symbol(sym.closeparenthesis,yycolumn,yyline,yytext());}
"[" {return new Symbol(sym.opensquarebracket,yycolumn,yyline,yytext());}
"]" {return new Symbol(sym.closesquarebracket,yycolumn,yyline,yytext());}

"generarreporteestadistico" {return new Symbol(sym.main,yycolumn,yyline,yytext());}
"definirglobales" {return new Symbol(sym.setglobals,yycolumn,yyline,yytext());}
"graficalineas" {return new Symbol(sym.linegraph,yycolumn,yyline,yytext());}
"graficabarras" {return new Symbol(sym.bargraph,yycolumn,yyline,yytext());}
"graficapie" {return new Symbol(sym.piegraph,yycolumn,yyline,yytext());}
"compare" {return new Symbol(sym.compare,yycolumn,yyline,yytext());}

"titulox" {return new Symbol(sym.bgtitlex,yycolumn,yyline,yytext());}
"tituloy" {return new Symbol(sym.bgtitley,yycolumn,yyline,yytext());}
"valores" {return new Symbol(sym.values,yycolumn,yyline,yytext());}
"titulo" {return new Symbol(sym.title,yycolumn,yyline,yytext());}
"archivo" {return new Symbol(sym.file,yycolumn,yyline,yytext());}
"ejex" {return new Symbol(sym.xaxis,yycolumn,yyline,yytext());}

"string" {return new Symbol(sym.strtype,yycolumn,yyline,yytext());}
"double" {return new Symbol(sym.doubletype,yycolumn,yyline,yytext());}

{DECIMAL} {return new Symbol(sym.decimal,yyline,yycolumn, yytext());}
{STRTEXT} {return new Symbol(sym.strtext,yyline,yycolumn, yytext());}
{ID} {return new Symbol(sym.id,yycolumn,yyline,yytext());}

{MULTICOMMENT} {}
{WHITESPACE} {}
{COMMENT} {}
"#" {}

\n  {}
\r  {}

. {
    System.out.println("Error lexico: "+yytext()+
    ", en la linea: "+yyline+", en la columna: "+yycolumn);
}