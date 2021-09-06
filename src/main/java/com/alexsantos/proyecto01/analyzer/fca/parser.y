package com.alexsantos.proyecto01.analyzer.fca;

import java_cup.runtime.*;
import java.util.ArrayList;
import com.alexsantos.proyecto01.graphs.*;
import com.alexsantos.proyecto01.utils.Tools;
import com.alexsantos.proyecto01.fca.Reports;
import com.alexsantos.proyecto01.analyzer.errors.*;
import com.alexsantos.proyecto01.analyzer.tokens.*;

/* GENERAL */
parser code {:
    String filePath;

    public void setFilePath (String path) {
        filePath = path;
    }

    public void syntax_error (Symbol s) {
        System.err.println("\nError sintactico en la linea " + s.right +
        " columna " + s.left + " componente: " + s.value + ".\n");

        ErrorHandler errorHandler = ErrorHandler.getInstance();
        errorHandler.add(s, filePath);
    }

    public void unrecovered_syntax_error (Symbol s) throws java.lang.Exception{
        System.err.println("\nError sintactico irrecuperable en la linea " +
        s.right + " columna " + s.left + " componente: " + s.value +
        " no reconocido.\n");

        ErrorHandler errorHandler = ErrorHandler.getInstance();
        errorHandler.add(s, filePath);
    }
:}

action code {:
    public void addToken (String lex, String key, int line, int col) {
        TokensHandler tokens = TokensHandler.getInstance();
        tokens.add(parser.filePath, lex, key, line, col);
    }
:};

/* TIPOS GENERALES */
terminal String decimal,strtext,id;

/* FUNCIONES Y PALABRAS RESERVADAS */
terminal strtype,doubletype;
terminal main,compare,setglobals,
bargraph,piegraph,linegraph,filePoints;

terminal dollar, genPoints;

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
BARGRAPH,PIEGRAPH,LINEGRAPH, GENPOINTS;

/* NO TERMINALES GENERICAS */
non terminal ArrayList<String> STRINGLIST;
non terminal ArrayList<Double> DOUBLELIST;
non terminal String[] FILEPOINTS;

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

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* PRODUCCIONES GENERICAS DE STRINGS */
STRINGLIST ::= STRINGLIST:list comma strtext:text {:
    RESULT = list;
    RESULT.add(Tools.trimStr(text));
    addToken("string", text, textright, textleft);
:} | STRINGLIST:list comma id:text {:
    RESULT = list;
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(text) != null)
        RESULT.add((String) reports.getGlobalProp(text));
    addToken("id", text, textright, textleft);
:} | strtext:text {:
    ArrayList<String> newList = new ArrayList<String>();
    RESULT = newList;
    RESULT.add(Tools.trimStr(text));
    addToken("string", text, textright, textleft);
:} | id:text {:
    Reports reports = Reports.getInstance();
    ArrayList<String> newList = new ArrayList<String>();
    RESULT = newList;
    if(reports.getGlobalProp(text) != null)
        RESULT.add((String) reports.getGlobalProp(text));
    addToken("string", text, textright, textleft);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* PRODUCCIONES GENERICAS DE DOUBLES */
DOUBLELIST ::= DOUBLELIST:list comma decimal:text {:
    RESULT = list;
    RESULT.add(Double.parseDouble(text));
    addToken("double", text, textright, textleft);
:} | DOUBLELIST:list comma id:text {:
    RESULT = list;
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(text) != null)
        RESULT.add((Double) reports.getGlobalProp(text));

    addToken("id", text, textright, textleft);
:} | DOUBLELIST:list comma GENPOINTS:line {:
    RESULT = list;
    Reports reports = Reports.getInstance();
    RESULT.add((Double) reports.genPoints);
:} | DOUBLELIST:list comma FILEPOINTS:params {:
    RESULT = list;
    Reports reports = Reports.getInstance();
    RESULT.add(reports.getFilePoints(params[0], params[1], params[2]));
:} | decimal:text {:
    ArrayList<Double> newList = new ArrayList<Double>();
    RESULT = newList;
    RESULT.add(Double.parseDouble(text));
    addToken("double", text, textright, textleft);
:} | id:text {:
    Reports reports = Reports.getInstance();
    ArrayList<Double> newList = new ArrayList<Double>();
    RESULT = newList;
    if(reports.getGlobalProp(text) != null)
        RESULT.add((Double) reports.getGlobalProp(text));
    addToken("id", text, textright, textleft);
:} | GENPOINTS:line {:
    Reports reports = Reports.getInstance();
    ArrayList<Double> newList = new ArrayList<Double>();
    RESULT = newList;
    RESULT.add(reports.genPoints);
:} | FILEPOINTS:params {:
    Reports reports = Reports.getInstance();
    ArrayList<Double> newList = new ArrayList<Double>();
    RESULT = newList;
    RESULT.add(reports.getFilePoints(params[0], params[1], params[2]));
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* INICIO */
START ::= MAIN {: :};

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
    reports.setComparePaths(Tools.trimStr(path1),Tools.trimStr(path2),idright);
    addToken("compare", path1 +" , "+path2, idright, idleft);
:} | error openparenthesis {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* DECALARAR GLOBALES */
SETGLOBALS ::= setglobals openbracket DECLARATIONS closebracket {: :};

DECLARATIONS ::= DECLARATIONS DECLARATION semicolom
| DECLARATION semicolom | error semicolom {: :};

DECLARATION ::= strtype id:idstr equals strtext:text {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idstr, Tools.trimStr(text));
    addToken("id", idstr, idstrright, idstrleft);
:} | doubletype id:idstr equals decimal:text {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idstr, Double.parseDouble(text));
    addToken("id", idstr, idstrright, idstrleft);
:} | doubletype id:idstr equals GENPOINTS:text {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idstr, reports.genPoints);
    addToken("id", idstr, idstrright, idstrleft);
:} | doubletype id:idstr equals FILEPOINTS:params {:
    Reports reports = Reports.getInstance();
    reports.setGlobalProp(idstr,
    reports.getFilePoints(params[0], params[1], params[2]));
    addToken("id", idstr, idstrright, idstrleft);
:};

GENPOINTS ::= dollar:line openbracket genPoints closebracket {:
    addToken("genPoints", "PuntajeGeneral", lineright, lineleft);
:};

FILEPOINTS ::= dollar openbracket filePoints:line
comma strtext:path comma strtext:key comma strtext:id closebracket {:
    String tPath = Tools.trimStr(path);
    String tKey = Tools.trimStr(key);
    String tId =Tools.trimStr(id);
    String[] params = new String[] {tPath, tKey, tId};
    RESULT = params;
    addToken("filePoints", tPath + "," + tKey + "," + tId, lineright, lineleft);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
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
    addToken("title", text, textright, textleft);
:} | title colom id:tId {:
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(tId) != null)
        RESULT = (String) reports.getGlobalProp(tId);
    else
        RESULT = null;

    addToken("id", tId, tIdright, tIdleft);
:};

GRAPHXAXIS ::= xaxis:line colom opensquarebracket
STRINGLIST:list closesquarebracket {:
    RESULT = list;
    addToken("xaxis", "ejex", lineright, lineleft);
:};

GRAPHVALUES ::= values:line colom opensquarebracket
DOUBLELIST:list closesquarebracket {:
    RESULT = list;
    addToken("values", "valores", lineright, lineleft);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* GRAFICAS DE LINEAS */
LINEGRAPH ::= linegraph:line openbracket LINEGRAPHPROPS:graph closebracket {:
    Reports reports = Reports.getInstance();
    reports.addGraph(graph, "lineas");
    addToken("linegraph", "graficalineas", lineright, lineleft);
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
    RESULT = new Object[] {text, "title", textright};
:} | LINEGRAPHFILE:text {:
    RESULT = new Object[] {text, "file", textright};
:};

LINEGRAPHFILE ::= file:line colom strtext:text {:
    RESULT = Tools.trimStr(text);
    addToken("file", "archivo", lineright, lineleft);
    addToken("string", text , textright, textleft);
:} | file:line colom id:tId {:
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(tId) != null)
        RESULT = (String) reports.getGlobalProp(tId);
    else
        RESULT = null;
    addToken("file", "archivo", lineright, lineleft);
    addToken("id", tId , tIdright, tIdleft);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* GRAFICAS DE PIE */
PIEGRAPH ::= piegraph:line openbracket PIEGRAPHPROPS:graph closebracket {:
    Reports reports = Reports.getInstance();
    reports.addGraph(graph, "pie");
    addToken("piegraph", "graficapie", lineright, lineleft);
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
BARGRAPH ::= bargraph:line openbracket BARGRAPHPROPS:graph closebracket {:
    Reports reports = Reports.getInstance();
    reports.addGraph(graph, "barras");
    addToken("bargraph", "graficabarras", lineright, lineleft);
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
    RESULT = new Object[] {prop, "xaxisTitle", propright};
:} | BARGRAPHPTITLEY:prop {:
    RESULT = new Object[] {prop, "yaxisTitle", propright};
:};

BARGRAPHPTITLEX ::= bgtitlex:line colom strtext:text {:
    RESULT = Tools.trimStr(text);
    addToken("bgtitlex", "titulox", lineright, lineleft);
    addToken("string", text, textright, textleft);
:} | bgtitlex:line colom id:tId {:
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(tId) != null)
        RESULT = (String) reports.getGlobalProp(tId);
    else
        RESULT = null;

    addToken("bgtitlex", "titulox", lineright, lineleft);
    addToken("id", tId, tIdright, tIdleft);
:};

BARGRAPHPTITLEY ::= bgtitley:line colom strtext:text {:
    RESULT = Tools.trimStr(text);
    addToken("bgtitley", "tituloy", lineright, lineleft);
    addToken("string", text, textright, textleft);
:} | bgtitley:line colom id:tId {:
    Reports reports = Reports.getInstance();
    if(reports.getGlobalProp(tId) != null)
        RESULT = (String) reports.getGlobalProp(tId);
    else
        RESULT = null;

    addToken("bgtitley", "tituloy", lineright, lineleft);
    addToken("id", tId, tIdright, tIdleft);
:};