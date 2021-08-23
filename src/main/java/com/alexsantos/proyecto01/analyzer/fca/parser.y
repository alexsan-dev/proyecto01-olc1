package com.alexsantos.proyecto01.analyzer.fca;

import java_cup.runtime.*;
import java.util.ArrayList;
import com.alexsantos.proyecto01.fca.Reports;
import com.alexsantos.proyecto01.graphs.*;

parser code {:
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
semicolom,openparenthesis,closeparenthesis, colom,
opensquarebracket, closesquarebracket;

terminal title, xaxis, values;
terminal bgtitlex, bgtitley;

non terminal START, MAIN,
COMPARE, SETGLOBALS, DECLARATIONS,
DECLARATION, FUNCTIONS, FUNCTION,
BARGRAPH;

non terminal ArrayList<String> STRINGLIST;
non terminal ArrayList<Double> DOUBLELIST;

non terminal BarGraph BARGRAPHPROPS;
non terminal Object[] BARGRAPHPROP;
non terminal String BARGRAPHPTITLEX;
non terminal String BARGRAPHPTITLEY;

non terminal String GRAPHTITLE;
non terminal Object[] GRAPHPROP;
non terminal ArrayList<String> GRAPHXAXIS;
non terminal ArrayList<Double> GRAPHVALUES;

precedence left major,minor,equals;
precedence right not;
precedence left plus,less;
precedence left times,div;

start with START;

START ::= MAIN {:
    Reports reports = Reports.getInstance();
    reports.generateGraphs();
:};

MAIN ::= main openbracket FUNCTIONS closebracket {: :};

FUNCTIONS ::= FUNCTION FUNCTIONS | FUNCTION |
SETGLOBALS | SETGLOBALS FUNCTIONS {: :};

FUNCTION ::= BARGRAPH | COMPARE semicolom {: :};

STRINGLIST ::= STRINGLIST:list comma strtext:text1 {:
    RESULT = list;
    RESULT.add(text1.substring(1, text1.length() - 1));
:} |
STRINGLIST:list comma id:text2 {:
    RESULT = list;
    Reports reports = Reports.getInstance();
    RESULT.add((String) reports.getGlobalProp(text2));
:} |
strtext:text3 {:
    ArrayList<String> newList = new ArrayList<String>();
    RESULT = newList;
    RESULT.add(text3.substring(1, text3.length() - 1));
:} |
id:text4 {:
    Reports reports = Reports.getInstance();
    ArrayList<String> newList = new ArrayList<String>();
    RESULT = newList;
    RESULT.add((String) reports.getGlobalProp(text4));
:};

DOUBLELIST ::= DOUBLELIST:list comma decimal:text1 {:
    RESULT = list;
    RESULT.add(Double.parseDouble(text1));
:} |
DOUBLELIST:list comma id:text2 {:
    RESULT = list;
    Reports reports = Reports.getInstance();
    RESULT.add((Double) reports.getGlobalProp(text2));
:} |
decimal:text3 {:
    ArrayList<Double> newList = new ArrayList<Double>();
    RESULT = newList;
    RESULT.add(Double.parseDouble(text3));
:} |
id:text4 {:
    Reports reports = Reports.getInstance();
    ArrayList<Double> newList = new ArrayList<Double>();
    RESULT = newList;
    RESULT.add((Double) reports.getGlobalProp(text4));
:};

COMPARE ::= compare:id openparenthesis strtext:path1 comma strtext:path2 closeparenthesis {:
    Reports reports = Reports.getInstance();
    reports.setComparePaths(path1.substring(1, path1.length() - 1), path2.substring(1, path2.length() - 1), idright);
:};

SETGLOBALS ::= setglobals openbracket DECLARATIONS closebracket {: :};

DECLARATIONS ::= DECLARATIONS DECLARATION semicolom | DECLARATION semicolom {: :};

DECLARATION ::= strtype id:idstr equals strtext:res {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idstr, res.substring(1, res.length() - 1));
:} | doubletype id:idbd equals decimal:dbres {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idbd, Double.parseDouble(dbres));
:};

BARGRAPH ::= bargraph openbracket BARGRAPHPROPS:graph closebracket {:
    Reports reports = Reports.getInstance();
    reports.graphs.add(graph);
:};

BARGRAPHPROPS ::= BARGRAPHPROPS:graph BARGRAPHPROP:prop semicolom {:
    RESULT = graph;
    RESULT.setProp(prop);
:} | GRAPHPROP:prop semicolom {:
    BarGraph barGraph = new BarGraph();
    RESULT = barGraph;
    RESULT.setProp(prop);
:};

BARGRAPHPROP ::= GRAPHPROP:prop {:
    RESULT = prop;
:} | BARGRAPHPTITLEX:propx {:
    RESULT = new Object[] {propx, "xaxisTitle", propxright};
:} | BARGRAPHPTITLEY:propy {:
    RESULT = new Object[] {propy, "yaxisTitle", propyright};
:};

GRAPHPROP ::= GRAPHTITLE:title {:
    RESULT = new Object[] {title, "title", titleright};
:} | GRAPHXAXIS:list {:
    RESULT = new Object[] {list, "xaxis", listright};
:} | GRAPHVALUES:list {:
    RESULT = new Object[] {list, "values", listright};
:};

GRAPHTITLE ::= title colom strtext:text {:
    RESULT = text;
:} | title colom id:tId {:
    Reports reports = Reports.getInstance();
    RESULT = (String) reports.getGlobalProp(tId);
:};

GRAPHXAXIS ::= xaxis colom opensquarebracket STRINGLIST:list closesquarebracket {:
    RESULT = list;
:};

GRAPHVALUES ::= values colom opensquarebracket DOUBLELIST:list closesquarebracket {:
    RESULT = list;
:};

BARGRAPHPTITLEX ::= bgtitlex colom strtext:text {:
    RESULT = text;
:} | bgtitlex colom id:tId {:
    Reports reports = Reports.getInstance();
    RESULT = (String) reports.getGlobalProp(tId);
:};

BARGRAPHPTITLEY ::= bgtitley colom strtext:text {:
    RESULT = text;
:} | bgtitley colom id:tId {:
    Reports reports = Reports.getInstance();
    RESULT = (String) reports.getGlobalProp(tId);
:};