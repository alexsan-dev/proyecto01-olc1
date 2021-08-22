package com.alexsantos.proyecto01.analyzer;
import java_cup.runtime.Symbol;

%%
%class Scanner
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

LETTER =[a-zA-ZÑñ]+
NUMBER =[0-9]+
DECIMAL ={NUMBER} ("."? [0-9]*)?
ID =({LETTER}|("_"{LETTER}))({LETTER}|{NUMBER}|"_")*
STRTEXT =[\"\“\'] [^\"\”\'\n]* [\"\”\'\n]
WHITESPACE=[ \t\f]*
COMMENT=##.*[\n\r]
MULTICOMMENT=(#\*[^\*]*\*#)
%%

"+" {return new Symbol(sym.more,yycolumn,yyline,yytext());}
"-" {return new Symbol(sym.less,yycolumn,yyline,yytext());}
"*" {return new Symbol(sym.times,yycolumn,yyline,yytext());}
"/" {return new Symbol(sym.div,yycolumn,yyline,yytext());}

"#" {return new Symbol(sym.sharp,yycolumn,yyline,yytext());}

"<" {return new Symbol(sym.minor,yycolumn,yyline,yytext());}
">" {return new Symbol(sym.major,yycolumn,yyline,yytext());}
"=" {return new Symbol(sym.equals,yycolumn,yyline,yytext());}
"!" {return new Symbol(sym.not,yycolumn,yyline,yytext());}

\n  {return new Symbol(sym.breakln,yycolumn,yyline,yytext());}
\r  {return new Symbol(sym.breakln,yycolumn,yyline,yytext());}

{ID} {return new Symbol(sym.id,yycolumn,yyline,yytext());}
{DECIMAL} {return new Symbol(sym.decimal,yyline,yycolumn, yytext());}
{STRTEXT} {return new Symbol(sym.strtext,yyline,yycolumn, yytext());}
{NUMBER} {return new Symbol(sym.number,yyline,yycolumn, yytext());}
{WHITESPACE} {return new Symbol(sym.whitespace,yyline,yycolumn, yytext());}
{COMMENT} {}
{MULTICOMMENT} {}

. {
    System.out.println("Error lexico: "+yytext()+
    ", en la linea: "+yyline+", en la columna: "+yycolumn);
}