package com.alexsantos.proyecto01.analyzer.fca;

import java_cup.runtime.Symbol;
import com.alexsantos.proyecto01.analyzer.errors.*;
import com.alexsantos.proyecto01.analyzer.tokens.*;

%%
%class FCAScanner
%public
%line
%column
%cup
%unicode
%ignorecase

%{
    String filePath = "";

    public void setFilePath (String path) {
        filePath = path;
    }

    public void addToken (String lex, String key, int line, int col) {
        TokensHandler tokens = TokensHandler.getInstance();
        tokens.add(filePath, lex, key, line, col);
    }
%}

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
WHITESPACE=[ \t\f]+
COMMENT=##.*[\n\r]
%%

"," {addToken("comma", ",", yyline, yycolumn);return new Symbol(sym.comma,yycolumn,yyline,yytext());}
":" {addToken("colom", ":", yyline, yycolumn);return new Symbol(sym.colom,yycolumn,yyline,yytext());}
"=" {addToken("equals", "=", yyline, yycolumn);return new Symbol(sym.equals,yycolumn,yyline,yytext());}
";" {addToken("semicolom", ";", yyline, yycolumn);return new Symbol(sym.semicolom,yycolumn,yyline,yytext());}
"{" {addToken("openbracket", "{", yyline, yycolumn);return new Symbol(sym.openbracket,yycolumn,yyline,yytext());}
"}" {addToken("closebracket", "}", yyline, yycolumn);return new Symbol(sym.closebracket,yycolumn,yyline,yytext());}
"(" {addToken("openparenthesis", "(", yyline, yycolumn);return new Symbol(sym.openparenthesis,yycolumn,yyline,yytext());}
")" {addToken("closeparenthesis", ")", yyline, yycolumn);return new Symbol(sym.closeparenthesis,yycolumn,yyline,yytext());}
"[" {addToken("opensquarebracket", "[", yyline, yycolumn);return new Symbol(sym.opensquarebracket,yycolumn,yyline,yytext());}
"]" {addToken("closesquarebracket", "]", yyline, yycolumn);return new Symbol(sym.closesquarebracket,yycolumn,yyline,yytext());}
"$" {addToken("dollar", "$", yyline, yycolumn);return new Symbol(sym.dollar,yycolumn,yyline,yytext());}

"generarreporteestadistico" {addToken("main", yytext(), yyline, yycolumn);return new Symbol(sym.main,yycolumn,yyline,yytext());}
"puntajeespecifico" {addToken("filePoints", yytext(), yyline, yycolumn);return new Symbol(sym.filePoints,yycolumn,yyline,yytext());}
"definirglobales" {addToken("setglobals", yytext(), yyline, yycolumn);return new Symbol(sym.setglobals,yycolumn,yyline,yytext());}
"puntajegeneral" {addToken("genPoints", yytext(), yyline, yycolumn);return new Symbol(sym.genPoints,yycolumn,yyline,yytext());}
"graficalineas" {addToken("linegraph", yytext(), yyline, yycolumn);return new Symbol(sym.linegraph,yycolumn,yyline,yytext());}
"graficabarras" {addToken("bargraph", yytext(), yyline, yycolumn);return new Symbol(sym.bargraph,yycolumn,yyline,yytext());}
"graficapie" {addToken("piegraph", yytext(), yyline, yycolumn);return new Symbol(sym.piegraph,yycolumn,yyline,yytext());}
"compare" {addToken("compare", "compare", yyline, yycolumn);return new Symbol(sym.compare,yycolumn,yyline,yytext());}

"titulox" {addToken("titulox", yytext(), yyline, yycolumn);return new Symbol(sym.bgtitlex,yycolumn,yyline,yytext());}
"tituloy" {addToken("tituloy", yytext(), yyline, yycolumn);return new Symbol(sym.bgtitley,yycolumn,yyline,yytext());}
"valores" {addToken("valores", yytext(), yyline, yycolumn);return new Symbol(sym.values,yycolumn,yyline,yytext());}
"titulo" {addToken("titulo", yytext(), yyline, yycolumn);return new Symbol(sym.title,yycolumn,yyline,yytext());}
"archivo" {addToken("archivo", yytext(), yyline, yycolumn);return new Symbol(sym.file,yycolumn,yyline,yytext());}
"ejex" {addToken("ejex", yytext(), yyline, yycolumn);return new Symbol(sym.xaxis,yycolumn,yyline,yytext());}

"string" {addToken("string", yytext(), yyline, yycolumn);return new Symbol(sym.strtype,yycolumn,yyline,yytext());}
"double" {addToken("double", yytext(), yyline, yycolumn);return new Symbol(sym.doubletype,yycolumn,yyline,yytext());}

{DECIMAL} {addToken("DECIMAL", yytext(), yyline, yycolumn);return new Symbol(sym.decimal,yycolumn,yyline, yytext());}
{STRTEXT} {addToken("STRTEXT", yytext(), yyline, yycolumn);return new Symbol(sym.strtext,yycolumn,yyline, yytext());}
{ID} {addToken("ID", yytext(), yyline, yycolumn);return new Symbol(sym.id,yycolumn,yyline,yytext());}

{MULTICOMMENT} {addToken("MULTICOMMENT", yytext(), yyline, yycolumn);}
{COMMENT} {addToken("COMMENT", yytext(), yyline, yycolumn);}
"#" {}

\n  {}
\r  {}
{WHITESPACE} {}

. {
    System.err.println("\nError lexico en la linea " + yyline +
        " columna " + yycolumn + " componente: " + yytext() + ".\n");

    Symbol s = new Symbol(0,yycolumn,yyline, yytext());
    ErrorHandler errorHandler = ErrorHandler.getInstance();
    errorHandler.add(s, filePath, "Error lexico");
}