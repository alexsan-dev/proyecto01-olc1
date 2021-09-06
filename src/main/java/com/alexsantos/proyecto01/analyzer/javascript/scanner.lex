package com.alexsantos.proyecto01.analyzer.javascript;

import java_cup.runtime.Symbol;
import com.alexsantos.proyecto01.analyzer.errors.*;
import com.alexsantos.proyecto01.analyzer.tokens.*;

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

NUMBER=[0-9]+
LETTER=[a-zA-ZÑñ]+
DECIMAL={NUMBER}("."? [0-9]*)?
ID=({LETTER}|("_"{LETTER}))({LETTER}|{NUMBER}|"_")*

STRTEXT=[\"\“\'][^\"\”\'\n]*[\"\”\'\n]
WHITESPACE=[ \t\f]+
COMMENT=\/\/((\\\n)|[^\n])*
%%

"," {addToken("comma", yytext(), yyline, yycolumn);return new Symbol(sym.comma,yycolumn,yyline,yytext());}
":" {addToken("colom", yytext(), yyline, yycolumn);return new Symbol(sym.colom,yycolumn,yyline,yytext());}
";" {addToken("semicolom", yytext(), yyline, yycolumn);return new Symbol(sym.semicolom,yycolumn,yyline,yytext());}
"{" {addToken("openbracket", yytext(), yyline, yycolumn);return new Symbol(sym.openbracket,yycolumn,yyline,yytext());}
"}" {addToken("closebracket", yytext(), yyline, yycolumn);return new Symbol(sym.closebracket,yycolumn,yyline,yytext());}
"(" {addToken("openparenthesis", yytext(), yyline, yycolumn);return new Symbol(sym.openparenthesis,yycolumn,yyline,yytext());}
")" {addToken("closeparenthesis", yytext(), yyline, yycolumn);return new Symbol(sym.closeparenthesis,yycolumn,yyline,yytext());}

"+=" {addToken("pluseq", yytext(), yyline, yycolumn);return new Symbol(sym.pluseq,yycolumn,yyline,yytext());}
"-=" {addToken("lesseq", yytext(), yyline, yycolumn);return new Symbol(sym.lesseq,yycolumn,yyline,yytext());}
"*=" {addToken("timeseq", yytext(), yyline, yycolumn);return new Symbol(sym.timeseq,yycolumn,yyline,yytext());}
"^=" {addToken("xoreq", yytext(), yyline, yycolumn);return new Symbol(sym.xoreq,yycolumn,yyline,yytext());}
"%=" {addToken("modeq", yytext(), yyline, yycolumn);return new Symbol(sym.modeq,yycolumn,yyline,yytext());}
"/=" {addToken("diveq", yytext(), yyline, yycolumn);return new Symbol(sym.diveq,yycolumn,yyline,yytext());}
"!=" {addToken("notequals", yytext(), yyline, yycolumn);return new Symbol(sym.notequals,yycolumn,yyline,yytext());}
"<=" {addToken("moreoreq", yytext(), yyline, yycolumn);return new Symbol(sym.moreoreq,yycolumn,yyline,yytext());}
">=" {addToken("lessoreq", yytext(), yyline, yycolumn);return new Symbol(sym.lessoreq,yycolumn,yyline,yytext());}
"++" {addToken("plusplus", yytext(), yyline, yycolumn);return new Symbol(sym.plusplus,yycolumn,yyline,yytext());}
"--" {addToken("lessless", yytext(), yyline, yycolumn);return new Symbol(sym.lessMlessM,yycolumn,yyline,yytext());}
"**" {addToken("times", yytext(), yyline, yycolumn);return new Symbol(sym.timestimes,yycolumn,yyline,yytext());}
"+" {addToken("plus", yytext(), yyline, yycolumn);return new Symbol(sym.plus,yycolumn,yyline,yytext());}
"-" {addToken("less", yytext(), yyline, yycolumn);return new Symbol(sym.lessM,yycolumn,yyline,yytext());}
"*" {addToken("times", yytext(), yyline, yycolumn);return new Symbol(sym.times,yycolumn,yyline,yytext());}
"/" {addToken("div", yytext(), yyline, yycolumn);return new Symbol(sym.div,yycolumn,yyline,yytext());}
"%" {addToken("mod", yytext(), yyline, yycolumn);return new Symbol(sym.mod,yycolumn,yyline,yytext());}
"^" {addToken("xor", yytext(), yyline, yycolumn);return new Symbol(sym.xor,yycolumn,yyline,yytext());}
"&&" {addToken("and", yytext(), yyline, yycolumn);return new Symbol(sym.and,yycolumn,yyline,yytext());}
"||" {addToken("or", yytext(), yyline, yycolumn);return new Symbol(sym.or,yycolumn,yyline,yytext());}
">" {addToken("major", yytext(), yyline, yycolumn);return new Symbol(sym.major,yycolumn,yyline,yytext());}
"<" {addToken("minor", yytext(), yyline, yycolumn);return new Symbol(sym.minor,yycolumn,yyline,yytext());}
"!" {addToken("not", yytext(), yyline, yycolumn);return new Symbol(sym.not,yycolumn,yyline,yytext());}
"=" {addToken("equals", yytext(), yyline, yycolumn);return new Symbol(sym.equals,yycolumn,yyline,yytext());}

"class" {addToken("class", yytext(), yyline, yycolumn);return new Symbol(sym.classsym,yycolumn,yyline,yytext());}
"var" {addToken("var", yytext(), yyline, yycolumn);return new Symbol(sym.var,yycolumn,yyline,yytext());}
"let" {addToken("let", yytext(), yyline, yycolumn);return new Symbol(sym.let,yycolumn,yyline,yytext());}
"const" {addToken("const", yytext(), yyline, yycolumn);return new Symbol(sym.constsym,yycolumn,yyline,yytext());}
"true" {addToken("booltrue", yytext(), yyline, yycolumn);return new Symbol(sym.booltrue,yycolumn,yyline,yytext());}
"false" {addToken("boolfalse", yytext(), yyline, yycolumn);return new Symbol(sym.boolfalse,yycolumn,yyline,yytext());}
"if" {addToken("if", yytext(), yyline, yycolumn);return new Symbol(sym.ifsym,yycolumn,yyline,yytext());}
"else" {addToken("else", yytext(), yyline, yycolumn);return new Symbol(sym.elsesym,yycolumn,yyline,yytext());}
"for" {addToken("for", yytext(), yyline, yycolumn);return new Symbol(sym.forsym,yycolumn,yyline,yytext());}
"while" {addToken("while", yytext(), yyline, yycolumn);return new Symbol(sym.whilesym,yycolumn,yyline,yytext());}
"do" {addToken("do", yytext(), yyline, yycolumn);return new Symbol(sym.dosym,yycolumn,yyline,yytext());}
"switch" {addToken("switch", yytext(), yyline, yycolumn);return new Symbol(sym.switchsym,yycolumn,yyline,yytext());}
"case" {addToken("case", yytext(), yyline, yycolumn);return new Symbol(sym.casesym,yycolumn,yyline,yytext());}
"break" {addToken("break", yytext(), yyline, yycolumn);return new Symbol(sym.breaksym,yycolumn,yyline,yytext());}
"default" {addToken("default", yytext(), yyline, yycolumn);return new Symbol(sym.defaultsym,yycolumn,yyline,yytext());}
"console" {addToken("console", yytext(), yyline, yycolumn);return new Symbol(sym.console,yycolumn,yyline,yytext());}
"." {addToken("dot", yytext(), yyline, yycolumn);return new Symbol(sym.dot,yycolumn,yyline,yytext());}
"log" {addToken("log", yytext(), yyline, yycolumn);return new Symbol(sym.logsym,yycolumn,yyline,yytext());}
"require" {addToken("require", yytext(), yyline, yycolumn);return new Symbol(sym.requiresym,yycolumn,yyline,yytext());}

{DECIMAL} {addToken("DECIMAL", yytext(), yyline, yycolumn);return new Symbol(sym.decimal,yycolumn,yyline, yytext());}
{STRTEXT} {addToken("STRTEXT", yytext(), yyline, yycolumn);return new Symbol(sym.strtext,yycolumn,yyline, yytext());}
{ID} {addToken("ID", yytext(), yyline, yycolumn);return new Symbol(sym.id,yycolumn,yyline,yytext());}

"/*"( [^*] | (\*+[^*/]) )*\*+\/  {addToken("MULTICOMMENT", yytext(), yyline, yycolumn);return new Symbol(sym.mcmt,yycolumn,yyline, yytext());}
{COMMENT} {addToken("COMMENT", yytext(), yyline, yycolumn);return new Symbol(sym.cmt,yycolumn, yyline, yytext());}

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