package com.alexsantos.proyecto01.analyzer.fca;

import java_cup.runtime.*;
import java.util.ArrayList;
import com.alexsantos.proyecto01.graphs.*;
import com.alexsantos.proyecto01.utils.Tools;
import com.alexsantos.proyecto01.fca.Reports;
import com.alexsantos.proyecto01.controllers.Primary;

/* ERRORES */
parser code {:
    public void syntax_error(Symbol s){
        Primary.print("Error Sintáctico en la Línea " + s.right +
        " Columna " + s.left + ". Componente: " + s.value + ".");

    }

    public void unrecovered_syntax_error(Symbol s) throws java.lang.Exception{
        Primary.print("Error síntactico irrecuperable en la Línea " +
        s.right + " Columna " + s.left + ". Componente: " + s.value +
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

/* NO TERMINALES DE GRAFICA DE LINEA */
non terminal LineGraph LINEGRAPHPROPS;
non terminal Object[] LINEGRAPHPROP;
non terminal String LINEGRAPHFILE;

start with START;

/* PRODUCCIONES GENERICAS DE STRINGS */
STRINGLIST ::= STRINGLIST:list comma strtext:text {:
    RESULT = list;
    RESULT.add(Tools.trimStr(text));
:} |
STRINGLIST:list comma id:text {:
    RESULT = list;
    Reports reports = Reports.getInstance();
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
    RESULT.add((String) reports.getGlobalProp(text));
:};

/* PRODUCCIONES GENERICAS DE DOUBLES */
DOUBLELIST ::= DOUBLELIST:list comma decimal:text {:
    RESULT = list;
    RESULT.add(Double.parseDouble(text));
:} |
DOUBLELIST:list comma id:text {:
    RESULT = list;
    Reports reports = Reports.getInstance();
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
    RESULT.add((Double) reports.getGlobalProp(text));
:};

/* INICIO */
START ::= MAIN {:
    Reports reports = Reports.getInstance();
    Primary.print("Generando todas las graficas");
    reports.generateGraphs();
    Primary.print("Fin de analisis lexico");
:};

/* DECLARACION INICIAL */
MAIN ::= main openbracket FUNCTIONS closebracket {: :};

/* LISTA DE FUNCIONES VALIDAS */
FUNCTIONS ::= FUNCTION FUNCTIONS | FUNCTION |
SETGLOBALS | SETGLOBALS FUNCTIONS {: :};

FUNCTION ::= BARGRAPH | PIEGRAPH | LINEGRAPH | COMPARE semicolom {: :};

/* FUNCION COMPARE */
COMPARE ::= compare:id openparenthesis strtext:path1 comma strtext:path2 closeparenthesis {:
    Reports reports = Reports.getInstance();
    reports.setComparePaths(Tools.trimStr(path1), Tools.trimStr(path2), idright);
    Primary.print("Comparando proyectos " + Tools.trimStr(path1) + " y " + Tools.trimStr(path2));
:};

/* DECALARAR GLOBALES */
SETGLOBALS ::= setglobals openbracket DECLARATIONS closebracket {: :};

DECLARATIONS ::= DECLARATIONS DECLARATION semicolom | DECLARATION semicolom {: :};

DECLARATION ::= strtype id:idstr equals strtext:text {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idstr, Tools.trimStr(text));
    Primary.print("Declarando variable " + idstr);
:} | doubletype id:idstr equals decimal:text {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idstr, Double.parseDouble(text));
    Primary.print("Declarando variable " + idstr);
:};

/* PRODUCCIONES DE GRAFICAS EN GENERAL */
GRAPHPROP ::= GRAPHTITLE:title {:
    RESULT = new Object[] {title, "title", titleright};
:} | GRAPHXAXIS:list {:
    RESULT = new Object[] {list, "xaxis", listright};
:} | GRAPHVALUES:list {:
    RESULT = new Object[] {list, "values", listright};
:};

GRAPHTITLE ::= title colom strtext:text {:
    RESULT = Tools.trimStr(text);
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

/* GRAFICAS DE LINEAS */
LINEGRAPH ::= linegraph openbracket LINEGRAPHPROPS:graph closebracket {:
    Reports reports = Reports.getInstance();
    reports.graphs.add(graph);
    Primary.print("Agregando grafica de lineas: " + graph.title);
:};

LINEGRAPHPROPS ::= LINEGRAPHPROPS:graph LINEGRAPHPROP:prop semicolom {:
    RESULT = graph;
    RESULT.setProp(prop);
:} | LINEGRAPHPROP:prop semicolom {:
    LineGraph lineGraph = new LineGraph();
    RESULT = lineGraph;
    RESULT.setProp(prop);
:};

LINEGRAPHPROP ::= GRAPHTITLE:text {:
    RESULT = new Object[] {text, "title", textright};
:} | LINEGRAPHFILE:text {:
    RESULT = new Object[] {text, "file", textright};
:};

LINEGRAPHFILE ::= file colom strtext:text {:
    RESULT = Tools.trimStr(text);
:} | file colom id:tId {:
    Reports reports = Reports.getInstance();
    RESULT = (String) reports.getGlobalProp(tId);
:};

/* GRAFICAS DE PIE */
PIEGRAPH ::= piegraph openbracket PIEGRAPHPROPS:graph closebracket {:
    Reports reports = Reports.getInstance();
    reports.graphs.add(graph);
    Primary.print("Agregando grafica de pie: " + graph.title);
:};

PIEGRAPHPROPS ::= PIEGRAPHPROPS:graph GRAPHPROP:prop semicolom {:
    RESULT = graph;
    RESULT.setProp(prop);
:} | GRAPHPROP:prop semicolom {:
    PieGraph pieGraph = new PieGraph();
    RESULT = pieGraph;
    RESULT.setProp(prop);
:};

/* GRAFICAS DE BARRAS */
BARGRAPH ::= bargraph openbracket BARGRAPHPROPS:graph closebracket {:
    Reports reports = Reports.getInstance();
    reports.graphs.add(graph);
    Primary.print("Agregando grafica de barras: " + graph.title);
:};

BARGRAPHPROPS ::= BARGRAPHPROPS:graph BARGRAPHPROP:prop semicolom {:
    RESULT = graph;
    RESULT.setProp(prop);
:} | BARGRAPHPROP:prop semicolom {:
    BarGraph barGraph = new BarGraph();
    RESULT = barGraph;
    RESULT.setProp(prop);
:};

BARGRAPHPROP ::= GRAPHPROP:prop {:
    RESULT = prop;
:} | BARGRAPHPTITLEX:prop {:
    RESULT = new Object[] {prop, "xaxisTitle", propright};
:} | BARGRAPHPTITLEY:prop {:
    RESULT = new Object[] {prop, "yaxisTitle", propright};
:};

BARGRAPHPTITLEX ::= bgtitlex colom strtext:text {:
    RESULT = Tools.trimStr(text);
:} | bgtitlex colom id:tId {:
    Reports reports = Reports.getInstance();
    RESULT = (String) reports.getGlobalProp(tId);
:};

BARGRAPHPTITLEY ::= bgtitley colom strtext:text {:
    RESULT = Tools.trimStr(text);
:} | bgtitley colom id:tId {:
    Reports reports = Reports.getInstance();
    RESULT = (String) reports.getGlobalProp(tId);
:};