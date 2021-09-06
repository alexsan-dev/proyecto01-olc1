package com.alexsantos.proyecto01.analyzer.javascript;
import java_cup.runtime.Symbol;

%%
%class JSScanner
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
DECIMAL={NUMBER}("."? [0-9]*)?
ID=({LETTER}|("_"{LETTER}))({LETTER}|{NUMBER}|"_")*

STRTEXT=[\"\“\'][^\"\”\'\n]*[\"\”\'\n]
MULTICOMMENT=(\/\*[^\*]*\*\/)
WHITESPACE=[ \t\f\n\r]+
COMMENT=\/\/.*[\n\r]
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

"+" {return new Symbol(sym.plus,yycolumn,yyline,yytext());}
"++" {return new Symbol(sym.plusplus,yycolumn,yyline,yytext());}
"--" {return new Symbol(sym.lessMlessM,yycolumn,yyline,yytext());}
"-" {return new Symbol(sym.lessM,yycolumn,yyline,yytext());}
"*" {return new Symbol(sym.times,yycolumn,yyline,yytext());}
"/" {return new Symbol(sym.div,yycolumn,yyline,yytext());}
"%" {return new Symbol(sym.mod,yycolumn,yyline,yytext());}
"||" {return new Symbol(sym.or,yycolumn,yyline,yytext());}
"&&" {return new Symbol(sym.and,yycolumn,yyline,yytext());}
"^" {return new Symbol(sym.xor,yycolumn,yyline,yytext());}
"+=" {return new Symbol(sym.pluseq,yycolumn,yyline,yytext());}
"-=" {return new Symbol(sym.lesseq,yycolumn,yyline,yytext());}
"*=" {return new Symbol(sym.timeseq,yycolumn,yyline,yytext());}
"^=" {return new Symbol(sym.xoreq,yycolumn,yyline,yytext());}
"%=" {return new Symbol(sym.modeq,yycolumn,yyline,yytext());}
"/=" {return new Symbol(sym.diveq,yycolumn,yyline,yytext());}
"!" {return new Symbol(sym.not,yycolumn,yyline,yytext());}
"!=" {return new Symbol(sym.notequals,yycolumn,yyline,yytext());}
"<=" {return new Symbol(sym.moreoreq,yycolumn,yyline,yytext());}
">=" {return new Symbol(sym.lessoreq,yycolumn,yyline,yytext());}
">" {return new Symbol(sym.major,yycolumn,yyline,yytext());}
"<" {return new Symbol(sym.minor,yycolumn,yyline,yytext());}

"class" {return new Symbol(sym.classsym,yycolumn,yyline,yytext());}
"var" {return new Symbol(sym.var,yycolumn,yyline,yytext());}
"let" {return new Symbol(sym.let,yycolumn,yyline,yytext());}
"const" {return new Symbol(sym.constsym,yycolumn,yyline,yytext());}
"true" {return new Symbol(sym.booltrue,yycolumn,yyline,yytext());}
"false" {return new Symbol(sym.boolfalse,yycolumn,yyline,yytext());}
"if" {return new Symbol(sym.ifsym,yycolumn,yyline,yytext());}
"else" {return new Symbol(sym.elsesym,yycolumn,yyline,yytext());}
"for" {return new Symbol(sym.forsym,yycolumn,yyline,yytext());}
"while" {return new Symbol(sym.whilesym,yycolumn,yyline,yytext());}
"do" {return new Symbol(sym.dosym,yycolumn,yyline,yytext());}
"switch" {return new Symbol(sym.switchsym,yycolumn,yyline,yytext());}
"case" {return new Symbol(sym.casesym,yycolumn,yyline,yytext());}
"break" {return new Symbol(sym.breaksym,yycolumn,yyline,yytext());}
"default" {return new Symbol(sym.defaultsym,yycolumn,yyline,yytext());}
"console" {return new Symbol(sym.console,yycolumn,yyline,yytext());}
"." {return new Symbol(sym.dot,yycolumn,yyline,yytext());}
"log" {return new Symbol(sym.logsym,yycolumn,yyline,yytext());}
"require" {return new Symbol(sym.requiresym,yycolumn,yyline,yytext());}

{DECIMAL} {return new Symbol(sym.decimal,yyline,yycolumn, yytext());}
{STRTEXT} {return new Symbol(sym.strtext,yyline,yycolumn, yytext());}
{ID} {return new Symbol(sym.id,yycolumn,yyline,yytext());}

{MULTICOMMENT} {return new Symbol(sym.cmt,yyline,yycolumn, yytext());}
{WHITESPACE} {}
{COMMENT} {return new Symbol(sym.mcmt,yyline,yycolumn, yytext());}
"//" {}

\n  {}
\r  {}

. {
    System.err.println("\nError lexico en la linea " + yyline +
        " columna " + yycolumn + " componente: " + yytext() + ".\n");
}