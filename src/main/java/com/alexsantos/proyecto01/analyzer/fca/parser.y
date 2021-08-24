package com.alexsantos.proyecto01.analyzer.fca;

import java_cup.runtime.*;
import java.util.ArrayList;
import com.alexsantos.proyecto01.graphs.*;
import com.alexsantos.proyecto01.utils.Tools;
import com.alexsantos.proyecto01.fca.Reports;

/* ERRORES */
parser code {:
    public void syntax_error(Symbol s){
        System.out.println("Error sintactico en la linea " + s.left +
        " Columna " + s.right + ". Componente: " + s.value + ".");

    }

    public void unrecovered_syntax_error(Symbol s) throws java.lang.Exception{
        System.out.println("Error sintactico irrecuperable en la linea " +
        s.left + " Columna " + s.right + ". Componente: " + s.value +
        " no reconocido.");
    }
:}

/* TIPOS GENERALES */
terminal String decimal,strtext,id;

/* FUNCIONES Y PALABRAS RESERVADAS */
terminal strtype,doubletype;
terminal main,compare,setglobals,
bargraph,piegraph,linegraph;

/* SIMBOLOS */
terminal comma,equals,openbracket,
closebracket,semicolom,openparenthesis,
closeparenthesis,colom,opensquarebracket,
closesquarebracket;

/* CARACTERISTICAS DE LAS GRAFICAS */
terminal title,xaxis,values,file,
bgtitlex,bgtitley;

/* NO TERMINALES PRINCIPALES */
non terminal START,MAIN,
COMPARE,SETGLOBALS,DECLARATIONS,
DECLARATION,FUNCTIONS,FUNCTION,
BARGRAPH,PIEGRAPH,LINEGRAPH;

/* NO TERMINALES GENERICAS */
non terminal ArrayList<String> STRINGLIST;
non terminal ArrayList<Double> DOUBLELIST;

/* NO TERMINALES DE GRAFICAS EN GENERAL */
non terminal String GRAPHTITLE;
non terminal Object[] GRAPHPROP;
non terminal ArrayList<String> GRAPHXAXIS;
non terminal ArrayList<Double> GRAPHVALUES;

/* NO TERMINALES DE GRAFICA DE BARRAS */
non terminal BarGraph BARGRAPHPROPS;
non terminal Object[] BARGRAPHPROP;
non terminal String BARGRAPHPTITLEX;
non terminal String BARGRAPHPTITLEY;

/* NO TERMINALES DE GRAFICA DE PIE */
non terminal PieGraph PIEGRAPHPROPS;
non terminal Object[] PIEGRAPHPROP;

/* NO TERMINALES DE GRAFICA DE LINEA */
non terminal LineGraph LINEGRAPHPROPS;
non terminal Object[] LINEGRAPHPROP;
non terminal String LINEGRAPHFILE;

start with START;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* PRODUCCIONES GENERICAS DE STRINGS */
STRINGLIST ::= STRINGLIST:list comma strtext:text {:
    RESULT = list;
    RESULT.add(Tools.trimStr(text));
:} |
STRINGLIST:list comma id:text {:
    RESULT = list;
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(text) != null)
        RESULT.add((String) reports.getGlobalProp(text));
:} |
strtext:text {:
    ArrayList<String> newList = new ArrayList<String>();
    RESULT = newList;
    RESULT.add(Tools.trimStr(text));
:} |
id:text {:
    Reports reports = Reports.getInstance();
    ArrayList<String> newList = new ArrayList<String>();
    RESULT = newList;
    if(reports.getGlobalProp(text) != null)
        RESULT.add((String) reports.getGlobalProp(text));
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* PRODUCCIONES GENERICAS DE DOUBLES */
DOUBLELIST ::= DOUBLELIST:list comma decimal:text {:
    RESULT = list;
    RESULT.add(Double.parseDouble(text));
:} |
DOUBLELIST:list comma id:text {:
    RESULT = list;
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(text) != null)
        RESULT.add((Double) reports.getGlobalProp(text));
:} |
decimal:text {:
    ArrayList<Double> newList = new ArrayList<Double>();
    RESULT = newList;
    RESULT.add(Double.parseDouble(text));
:} |
id:text {:
    Reports reports = Reports.getInstance();
    ArrayList<Double> newList = new ArrayList<Double>();
    RESULT = newList;
    if(reports.getGlobalProp(text) != null)
        RESULT.add((Double) reports.getGlobalProp(text));
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* INICIO */
START ::= MAIN {:
    Reports reports = Reports.getInstance();
    reports.generateGraphs();
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* DECLARACION INICIAL */
MAIN ::= main openbracket FUNCTIONS closebracket {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* LISTA DE FUNCIONES VALIDAS */
FUNCTIONS ::= FUNCTION FUNCTIONS | FUNCTION
| SETGLOBALS | SETGLOBALS FUNCTIONS {: :};

FUNCTION ::= BARGRAPH | PIEGRAPH | LINEGRAPH | COMPARE
| error openbracket | error closebracket {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* FUNCION COMPARE */
COMPARE ::= compare:id openparenthesis strtext:path1 comma strtext:path2
closeparenthesis semicolom {:
    Reports reports = Reports.getInstance();
    reports.setComparePaths(Tools.trimStr(path1), Tools.trimStr(path2), idleft);
:} | error openparenthesis {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* DECALARAR GLOBALES */
SETGLOBALS ::= setglobals openbracket DECLARATIONS closebracket {: :};

DECLARATIONS ::= DECLARATIONS DECLARATION semicolom
| DECLARATION semicolom | error semicolom {: :};

DECLARATION ::= strtype id:idstr equals strtext:text {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idstr, Tools.trimStr(text));
:} | doubletype id:idstr equals decimal:text {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idstr, Double.parseDouble(text));
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* PRODUCCIONES DE GRAFICAS EN GENERAL */
GRAPHPROP ::= GRAPHTITLE:title {:
    RESULT = new Object[] {title, "title", titleleft};
:} | GRAPHXAXIS:list {:
    RESULT = new Object[] {list, "xaxis", listleft};
:} | GRAPHVALUES:list {:
    RESULT = new Object[] {list, "values", listleft};
:};

GRAPHTITLE ::= title colom strtext:text {:
    RESULT = Tools.trimStr(text);
:} | title colom id:tId {:
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(tId) != null)
        RESULT = (String) reports.getGlobalProp(tId);
    else
        RESULT = "";
:};

GRAPHXAXIS ::= xaxis colom opensquarebracket
STRINGLIST:list closesquarebracket {:
    RESULT = list;
:};

GRAPHVALUES ::= values colom opensquarebracket
DOUBLELIST:list closesquarebracket {:
    RESULT = list;
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* GRAFICAS DE LINEAS */
LINEGRAPH ::= linegraph openbracket LINEGRAPHPROPS:graph closebracket {:
    Reports reports = Reports.getInstance();
    reports.addGraph(graph, "lineas");
:};

LINEGRAPHPROPS ::= LINEGRAPHPROPS:graph LINEGRAPHPROP:prop semicolom {:
    RESULT = graph;
    RESULT.setProp(prop);
:} | LINEGRAPHPROP:prop semicolom {:
    LineGraph lineGraph = new LineGraph();
    RESULT = lineGraph;
    RESULT.setProp(prop);
:} | error semicolom {:
    LineGraph lineGraph = new LineGraph();
    RESULT = lineGraph;
:};

LINEGRAPHPROP ::= GRAPHTITLE:text {:
    RESULT = new Object[] {text, "title", textleft};
:} | LINEGRAPHFILE:text {:
    RESULT = new Object[] {text, "file", textleft};
:};

LINEGRAPHFILE ::= file colom strtext:text {:
    RESULT = Tools.trimStr(text);
:} | file colom id:tId {:
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(tId) != null)
        RESULT = (String) reports.getGlobalProp(tId);
    else
        RESULT = "";
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* GRAFICAS DE PIE */
PIEGRAPH ::= piegraph openbracket PIEGRAPHPROPS:graph closebracket {:
    Reports reports = Reports.getInstance();
    reports.addGraph(graph, "pie");
:};

PIEGRAPHPROPS ::= PIEGRAPHPROPS:graph GRAPHPROP:prop semicolom {:
    RESULT = graph;
    RESULT.setProp(prop);
:} | GRAPHPROP:prop semicolom {:
    PieGraph pieGraph = new PieGraph();
    RESULT = pieGraph;
    RESULT.setProp(prop);
:} | error semicolom {:
    PieGraph pieGraph = new PieGraph();
    RESULT = pieGraph;
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* GRAFICAS DE BARRAS */
BARGRAPH ::= bargraph openbracket BARGRAPHPROPS:graph closebracket {:
    Reports reports = Reports.getInstance();
    reports.addGraph(graph, "barras");
:};

BARGRAPHPROPS ::= BARGRAPHPROPS:graph BARGRAPHPROP:prop semicolom {:
    RESULT = graph;
    RESULT.setProp(prop);
:} | BARGRAPHPROP:prop semicolom {:
    BarGraph barGraph = new BarGraph();
    RESULT = barGraph;
    RESULT.setProp(prop);
:} | error semicolom {:
    BarGraph barGraph = new BarGraph();
    RESULT = barGraph;
:};

BARGRAPHPROP ::= GRAPHPROP:prop {:
    RESULT = prop;
:} | BARGRAPHPTITLEX:prop {:
    RESULT = new Object[] {prop, "xaxisTitle", propleft};
:} | BARGRAPHPTITLEY:prop {:
    RESULT = new Object[] {prop, "yaxisTitle", propleft};
:};

BARGRAPHPTITLEX ::= bgtitlex colom strtext:text {:
    RESULT = Tools.trimStr(text);
:} | bgtitlex colom id:tId {:
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(tId) != null)
        RESULT = (String) reports.getGlobalProp(tId);
    else
        RESULT = "";
:};

BARGRAPHPTITLEY ::= bgtitley colom strtext:text {:
    RESULT = Tools.trimStr(text);
:} | bgtitley colom id:tId {:
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(tId) != null)
        RESULT = (String) reports.getGlobalProp(tId);
    else
        RESULT = "";
:};