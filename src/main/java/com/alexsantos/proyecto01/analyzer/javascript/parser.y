package com.alexsantos.proyecto01.analyzer.javascript;

import java_cup.runtime.*;
import java.util.HashMap;
import java.util.ArrayList;
import com.alexsantos.proyecto01.utils.Tools;
import com.alexsantos.proyecto01.analyzer.errors.*;
import com.alexsantos.proyecto01.analyzer.tokens.*;
import com.alexsantos.proyecto01.analyzer.comparator.MethodContent;

/* GENERAL */
parser code {:
    public String filePath;
    public HashMap<String, ArrayList<String>> elements;

    public void setFilePath (String path) {
        filePath = path;
        elements = new HashMap<String, ArrayList<String>>();

        elements.put("method-params", new ArrayList<String>());
        elements.put("method-lines", new ArrayList<String>());
        elements.put("class-method", new ArrayList<String>());
        elements.put("class-lines", new ArrayList<String>());
        elements.put("comment", new ArrayList<String>());
        elements.put("method", new ArrayList<String>());
        elements.put("class", new ArrayList<String>());
        elements.put("var", new ArrayList<String>());
    }

    public HashMap getElements () {
        return elements;
    }

    public void syntax_error (Symbol s) {
        System.err.println("\nError sintactico en la linea " + s.right +
        " columna " + s.left + " componente: " + s.value + ".\n");

        ErrorHandler errorHandler = ErrorHandler.getInstance();
        errorHandler.add(s, filePath, "Error sintactico");
    }

    public void unrecovered_syntax_error (Symbol s) throws java.lang.Exception {
        System.err.println("\nError sintactico irrecuperable en la linea " +
        s.right + " columna " + s.left + " componente: " + s.value +
        " no reconocido.\n");

        ErrorHandler errorHandler = ErrorHandler.getInstance();
        errorHandler.add(s, filePath, "Error sintactico irrecuperable");
    }
:}

action code {:
    public void addElement (String name, String value) {
        parser.elements.get(name).add(value);
    }

    public void addClassMethod (String classID, MethodContent content) {
        for (int contentIndex = 0;
            contentIndex < content.list.size();
            contentIndex++) {
            String[] declaration = content.list.get(contentIndex);
            if (declaration[0].equals("method")) {
               int methodStart = Integer.parseInt(declaration[1]);
               if (methodStart >= content.lineStart
                    && methodStart <= content.lineEnd) {
                 addElement("class-method", classID + "-" + declaration[2]);
               }
            }
        }
    }
:}

/* TIPOS GENERALES */
terminal String decimal,
strtext, id, cmt, mcmt;

/* SIMBOLOS */
terminal comma,equals,openbracket,timestimes,
closebracket,semicolom,openparenthesis,
closeparenthesis,colom,plus,lessM,times,
div,mod,or,and,xor,pluseq,lesseq,timeseq,
xoreq,diveq,modeq,not,major,minor,moreoreq,
lessoreq,notequals,plusplus,lessMlessM;

/* PALABRAS RESERVADAS */
terminal classsym,var,let,constsym,booltrue,
boolfalse,ifsym,elsesym,forsym,whilesym,dosym,
switchsym,defaultsym,casesym,breaksym,console,
dot,logsym,requiresym;

/* NO TERMINALES PRINCIPALES */
non terminal START,METHODS,METHOD,NEWCLASS,
ASSIGNMENT,EXPRESSIONS,VARVALUE,CONTROLSEQ,
COMMENTS,SWITCHSEQ,SWITCHSEQCASES,SWITCHSEQCONTENT,
EXPRESSIONOPT,FORSEQ,WHILESEQ,DOWHILESEQ,CONSOLESEQ,
FORSEQPARAMS,INLINEASSIGNMENTS,INLINEASSIGNMENT;

/* NO TERMINALES MEDIBLES */
non terminal String[] FUNCTIONHEADER, DECLARATION;
non terminal String COMMENT, MULTICOMMENT, VARTYPE;
non terminal ArrayList<String[]> DECLARATIONS;
non terminal String FUNCTION, CONSTROLSEQSYM;
non terminal MethodContent METHODCONTENT;
non terminal Object FUNCTIONPARAMS;

/* PRESEDENCIA */
precedence left plus, lessM;
precedence left times, div;
precedence left or, and;
precedence left mod, xor;
precedence left plusplus, lessMlessM, timestimes;
precedence left equals, notequals;
precedence left pluseq, lesseq;
precedence left timeseq, diveq;
precedence left modeq, xoreq;
precedence left major, minor;
precedence left openparenthesis, closeparenthesis;
precedence left moreoreq, lessoreq;
precedence left comma, semicolom;
precedence left cmt, mcmt;
precedence left var, let, constsym;

start with START;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* INICIO */
START ::= METHODS {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* FUNCIONES PRINCIPALES */
METHODS ::= METHODS METHOD | METHOD {: :};

METHOD ::= COMMENTS | NEWCLASS | FUNCTION | ASSIGNMENT
| error openbracket {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* COMENTARIOS */
COMMENTS ::= COMMENTS MULTICOMMENT:text {: addElement("comment", text); :}
| COMMENTS COMMENT:text {: addElement("comment", text); :}
| MULTICOMMENT:text {: addElement("comment", text); :}
| COMMENT:text {: addElement("comment", text); :};

COMMENT ::= cmt:text {:
    RESULT = text;
:};

MULTICOMMENT ::= mcmt:text {:
    RESULT = text;
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* CONTENIDO ENTRE LLAVES */
METHODCONTENT ::= openbracket:openLine
DECLARATIONS:list closebracket:closeLine {:
    int lineStart = openLineright;
    int lineEnd = closeLineright;
    MethodContent data = new MethodContent(list, lineStart, lineEnd);
    RESULT = data;
:} | openbracket:openLine closebracket:closeLine {:
    int lineStart = openLineright;
    int lineEnd = closeLineright;
    MethodContent data = new MethodContent(null, lineStart, lineEnd);
    RESULT = data;
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* CLASES */
NEWCLASS ::= classsym id:classID METHODCONTENT:content {:
    String counter = Integer.toString(content.lineEnd - content.lineStart);
    addElement("class", classID);
    addElement("class-lines", counter);
    addClassMethod(classID, content);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* METODOS */
FUNCTIONHEADER ::=  id:funcID openparenthesis
FUNCTIONPARAMS:params closeparenthesis {:
    String[] functionParams = new String[]{funcID, Integer.toString((int) params)};
    RESULT = functionParams;
:} | id:funcID openparenthesis closeparenthesis {:
    String[] functionParams = new String[]{funcID, "0"};
    RESULT = functionParams;
:};

FUNCTIONPARAMS ::= FUNCTIONPARAMS:count comma EXPRESSIONS {:
    int vl = (int) count;
    RESULT = ++vl;
:} | EXPRESSIONS  {:
    int defLines = 0;
    RESULT = defLines;
:};

FUNCTION ::= FUNCTIONHEADER:funcID METHODCONTENT:content {:
    String counter = Integer.toString(content.lineEnd - content.lineStart);
    addElement("method", funcID[0]);
    addElement("method-params", funcID[1]);
    addElement("method-lines", counter);
    RESULT = funcID[0];
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* DECLARACIONES */
DECLARATIONS ::= DECLARATIONS:list DECLARATION:line semicolom {:
    RESULT = list;
    String[] data = new String[] {line[0], line[1], line[2]};
    RESULT.add(data);
:} | DECLARATIONS:list DECLARATION:line {:
    RESULT = list;
    String[] data = new String[] {line[0], line[1], line[2]};
    RESULT.add(data);
:} | DECLARATION:line semicolom {:
    ArrayList<String[]> list = new ArrayList<String[]>();
    String[] data = new String[] {line[0], line[1], line[2]};
    RESULT = list;
    RESULT.add(data);
:} | DECLARATION:line {:
    ArrayList<String[]> list = new ArrayList<String[]>();
    String[] data = new String[] {line[0], line[1], line[2]};
    RESULT = list;
    RESULT.add(data);
:};

DECLARATION ::= CONTROLSEQ {:
    String[] data = new String[]{"control", "0", ""}; RESULT = data;
:} | FORSEQ {:
    String[] data = new String[]{"for", "0", ""}; RESULT = data;
:} | WHILESEQ {:
    String[] data = new String[]{"while", "0", ""}; RESULT = data;
:} | DOWHILESEQ {:
    String[] data = new String[]{"dowhile", "0", ""}; RESULT = data;
:} | SWITCHSEQ {:
    String[] data = new String[]{"switch", "0", ""}; RESULT = data;
:} | CONSOLESEQ {:
    String[] data = new String[]{"console", "0", ""}; RESULT = data;
:} | FUNCTIONHEADER {:
    String[] data = new String[]{"call", "0", ""}; RESULT = data;
:} | EXPRESSIONS {:
    String[] data = new String[]{"exp", "0", ""}; RESULT = data;
:} | ASSIGNMENT {:
    String[] data = new String[]{"assignment", "0", ""}; RESULT = data;
:} | NEWCLASS {:
    String[] data = new String[]{"class", "0", ""}; RESULT = data;
:} | FUNCTION:funcID {:
    String line = Integer.toString(funcIDright);
    String[] data = new String[]{"method", line, funcID};
    RESULT = data;
:} | COMMENTS {:
    String[] data = new String[]{"comment", "0", ""}; RESULT = data;
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* ASIGNACIONES */
INLINEASSIGNMENTS ::= INLINEASSIGNMENTS comma INLINEASSIGNMENT
| INLINEASSIGNMENT {: :};

INLINEASSIGNMENT ::= id:varID equals EXPRESSIONS {:
    addElement("var", varID);
:} | error equals | error semicolom {: :};

ASSIGNMENT ::= VARTYPE id:varID
| VARTYPE INLINEASSIGNMENTS | INLINEASSIGNMENTS {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* TIPOS DE VARIABLES */
VARTYPE ::= var {: RESULT = "var"; :}
| let {: RESULT = "let"; :}
| constsym {: RESULT = "const"; :} ;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* TODAS LAS EXPRESIONES VALIDAS */
EXPRESSIONS ::= EXPRESSIONS EXPRESSIONOPT EXPRESSIONS
| openparenthesis EXPRESSIONS closeparenthesis
| not EXPRESSIONS
| lessMlessM EXPRESSIONS
| lessM EXPRESSIONS
| VARVALUE | error VARVALUE | error EXPRESSIONOPT {: :};

EXPRESSIONOPT ::= plus| lessM | times | timestimes
| div | mod | or | and | xor | notequals
| equals equals | pluseq | lesseq | timeseq | xoreq
| diveq | modeq | moreoreq | lessoreq | major
| minor:text {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* VALORES DE VARIABLES */
VARVALUE ::= decimal | strtext | breaksym | id | booltrue
| boolfalse | id plusplus | id lessMlessM | plusplus id
| requiresym openparenthesis strtext closeparenthesis {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* IF ELSE */
CONTROLSEQ ::= CONSTROLSEQSYM openparenthesis EXPRESSIONS
closeparenthesis METHODCONTENT
| elsesym METHODCONTENT {: :};

CONSTROLSEQSYM ::= ifsym {: RESULT = "if"; :}
| elsesym ifsym {: RESULT = "else if"; :} ;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* FOR */
FORSEQ ::= forsym openparenthesis FORSEQPARAMS closeparenthesis
METHODCONTENT {: :};

FORSEQPARAMS ::= ASSIGNMENT semicolom EXPRESSIONS semicolom ASSIGNMENT
| ASSIGNMENT semicolom EXPRESSIONS semicolom EXPRESSIONS {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* WHILE */
WHILESEQ ::= whilesym openparenthesis EXPRESSIONS closeparenthesis
METHODCONTENT {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* DO WHILE */
DOWHILESEQ ::= dosym METHODCONTENT whilesym
openparenthesis EXPRESSIONS closeparenthesis {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* SWITCH */
SWITCHSEQ ::= switchsym openparenthesis VARVALUE closeparenthesis
openbracket SWITCHSEQCASES defaultsym colom
DECLARATIONS closebracket
| switchsym openparenthesis VARVALUE closeparenthesis
openbracket SWITCHSEQCASES closebracket {: :};

SWITCHSEQCASES ::= SWITCHSEQCASES SWITCHSEQCONTENT
| SWITCHSEQCONTENT {: :};

SWITCHSEQCONTENT ::= casesym VARVALUE colom DECLARATIONS {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* CONSOLE.LOG */
CONSOLESEQ ::= console dot logsym
openparenthesis EXPRESSIONS closeparenthesis
| console dot logsym openparenthesis closeparenthesis {: :};
