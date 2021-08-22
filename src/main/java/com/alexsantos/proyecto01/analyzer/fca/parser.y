package com.alexsantos.proyecto01.analyzer.fca;

import java_cup.runtime.*;
import java.util.ArrayList;
import com.alexsantos.proyecto01.fca.Reports;

parser code
{:
    public void syntax_error(Symbol s){
        System.out.println("Error Sintáctico en la Línea " + s.right +
        " Columna " + s.left + ". Componente: " + s.value + ".");

    }

    public void unrecovered_syntax_error(Symbol s) throws java.lang.Exception{
        System.out.println("Error síntactico irrecuperable en la Línea " +
        s.right + " Columna " + s.left + ". Componente: " + s.value +
        " no reconocido.");
    }
:}

terminal main,compare,setglobals,bargraph;
terminal strtype,doubletype;
terminal String number,decimal,strtext,id;
terminal sharp,comma,major,minor,equals,
not,plus,less,div,times,openbracket,closebracket,
semicolom,openparenthesis,closeparenthesis;

non terminal START, MAIN,
COMPARE, SETGLOBALS, DECLARATIONS,
DECLARATION, FUNCTIONS, FUNCTION,
BARGRAPH;

precedence left major,minor,equals;
precedence right not;
precedence left plus,less;
precedence left times,div;

start with START;

START ::= MAIN {:
:};

MAIN ::= main openbracket FUNCTIONS closebracket {:
:};

FUNCTIONS ::= FUNCTION FUNCTIONS | FUNCTION |
SETGLOBALS | SETGLOBALS FUNCTIONS {:
:};

FUNCTION ::= BARGRAPH | COMPARE semicolom {:
:};

COMPARE ::= compare:id openparenthesis strtext:path1 comma strtext:path2 closeparenthesis {:
    Reports reports = Reports.getInstance();
    reports.setComparePaths(path1, path2, idright, idleft);
:};

SETGLOBALS ::= setglobals openbracket DECLARATIONS closebracket {:
:};

DECLARATIONS ::= DECLARATIONS DECLARATION semicolom | DECLARATION semicolom {:
:};

DECLARATION ::= strtype id:idstr equals strtext:res {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idstr, res.substring(1, res.length() - 1));
:} | doubletype id:idbd equals decimal:dbres {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idbd, Double.parseDouble(dbres));
:};

BARGRAPH ::= bargraph openbracket closebracket {:
:};