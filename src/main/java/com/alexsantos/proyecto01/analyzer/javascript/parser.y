package com.alexsantos.proyecto01.analyzer.javascript;

import java_cup.runtime.*;
import java.util.HashMap;
import java.util.ArrayList;
import com.alexsantos.proyecto01.utils.Tools;
import com.alexsantos.proyecto01.analyzer.errors.*;

/* GENERAL */
parser code {:
    public String filePath;
    public HashMap<String, ArrayList<String>> elements;

    public void setFilePath(String path){
        filePath = path;
        elements = new HashMap<String, ArrayList<String>>();
        elements.put("class", new ArrayList<String>());
        elements.put("class-lines", new ArrayList<String>());
        elements.put("method", new ArrayList<String>());
        elements.put("method-params", new ArrayList<String>());
        elements.put("method-lines", new ArrayList<String>());
        elements.put("var", new ArrayList<String>());
        elements.put("comment", new ArrayList<String>());
    }

    public HashMap getElements(){
        return elements;
    }

    public void syntax_error(Symbol s){
        System.err.println("\nError sintactico en la linea " + s.right +
        " columna " + s.left + " componente: " + s.value + ".\n");
        ErrorHandler errorHandler = ErrorHandler.getInstance();
        errorHandler.add(s, filePath);
    }

    public void unrecovered_syntax_error(Symbol s) throws java.lang.Exception{
        System.err.println("\nError sintactico irrecuperable en la linea " +
        s.right + " columna " + s.left + " componente: " + s.value +
        " no reconocido.\n");
        ErrorHandler errorHandler = ErrorHandler.getInstance();
        errorHandler.add(s, filePath);
    }
:}

action code {:
    public void addElement(String name, String value){
        parser.elements.get(name).add(value);
    }
:}

/* TIPOS GENERALES */
terminal String decimal,
strtext, id, cmt, mcmt;

/* SIMBOLOS */
terminal comma,equals,openbracket,
closebracket,semicolom,openparenthesis,
closeparenthesis,colom,opensquarebracket,
closesquarebracket, plus, lessM, times,
div, mod, or, and, xor, pluseq, lesseq,
timeseq, xoreq, diveq, modeq, not,
major, minor, moreoreq, lessoreq, notequals,
plusplus, lessMlessM;

/* PALABRAS RESERVADAS */
terminal classsym, var, let, constsym,
function, booltrue, boolfalse, ifsym,
elsesym, forsym, whilesym, dosym, switchsym,
defaultsym, casesym, breaksym, console,
dot, logsym, requiresym;

/* NO TERMINALES PRINCIPALES */
non terminal START, METHODS,
METHOD, NEWCLASS,
DECLARATIONS, DECLARATION,
ASSIGNMENT, EXPRESSIONS, VARVALUE,
CONTROLSEQ, CONSTROLSEQSYM,
VARTYPE, EXPRESSION, INLINEASSIGNMENTS,
INLINEASSIGNMENT, EXPRESSIONOPT,
EXPRESSIONSEQ, FORSEQ,
WHILESEQ, DOWHILESEQ, SWITCHSEQ,
SWITCHSEQCASES, SWITCHSEQCONTENT,
CONSOLESEQ, FORSEQPARAMS,
 EXPRESSIONGROUP, FUNCTION, COMMENTS;

non terminal Object METHODCONTENT, FUNCTIONPARAMS;
non terminal String[2] FUNCTIONHEADER;
non terminal String COMMENT, MULTICOMMENT;

/* PRESEDENCIA */
precedence left openparenthesis, closeparenthesis;
precedence left plus, lessM;
precedence left times, div;
precedence left or, and;
precedence left mod, xor;
precedence left plusplus, lessMlessM;
precedence left equals, notequals;
precedence left pluseq, lesseq;
precedence left timeseq, diveq;
precedence left modeq, xoreq;
precedence left major, minor;
precedence left moreoreq, lessoreq;
precedence left comma, semicolom;
precedence left cmt, mcmt;

start with START;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* INICIO */
START ::= METHODS {:

:};

METHODS ::= METHODS METHOD | METHOD {: :};

METHOD ::= NEWCLASS | FUNCTION {: :};

COMMENTS ::= COMMENTS COMMENT:text {: addElement("comment", text); :}
| COMMENTS MULTICOMMENT:text {: addElement("comment", text); :}
| COMMENT:text {: addElement("comment", text); :}
| MULTICOMMENT:text {: addElement("comment", text); :};

COMMENT ::= cmt:text {:
    RESULT = text;
:};

MULTICOMMENT ::= mcmt:text {:
    RESULT = text;
:};

METHODCONTENT ::= openbracket:openLine DECLARATIONS closebracket:closeLine {:
    int lineStart = openLineright;
    int lineEnd = closeLineright;
    RESULT = (int) (lineEnd - lineStart);
:}
| openbracket:openLine closebracket:closeLine {:
    int lineStart = openLineright;
    int lineEnd = closeLineright;
    RESULT = (int) (lineEnd - lineStart);
:};

NEWCLASS ::= classsym id:classID METHODCONTENT:lines {:
    addElement("class", classID);
    addElement("class-lines", Integer.toString((int) lines));
:};

FUNCTIONHEADER ::=  id:funcID openparenthesis FUNCTIONPARAMS:params closeparenthesis {:
    String[] paramss = new String[]{funcID, Integer.toString((int) params)};
    RESULT = paramss;
:} | id:funcID openparenthesis closeparenthesis {:
    String[] paramss = new String[]{funcID, "0"};
    RESULT = paramss;
:};

FUNCTIONPARAMS ::= FUNCTIONPARAMS:count comma VARVALUE {:
    int vl = (int) count;
    RESULT = ++vl;
:} | VARVALUE  {:
    int defLines = 0;
    RESULT = defLines;
:};

FUNCTION ::= FUNCTIONHEADER:funcID METHODCONTENT:lines {:
     addElement("method", funcID[0]);
     addElement("method-params", funcID[1]);
     addElement("method-lines", Integer.toString((int) lines));
:};

DECLARATIONS ::= DECLARATIONS DECLARATION semicolom
| DECLARATION semicolom
| DECLARATIONS DECLARATION
| DECLARATION {: :};

DECLARATION ::= ASSIGNMENT | CONTROLSEQ
| FORSEQ | WHILESEQ | DOWHILESEQ | SWITCHSEQ
| CONSOLESEQ | FUNCTIONHEADER | EXPRESSIONS
| NEWCLASS | FUNCTION | COMMENTS {: :};

INLINEASSIGNMENTS ::= INLINEASSIGNMENTS comma INLINEASSIGNMENT
| INLINEASSIGNMENT {: :};

INLINEASSIGNMENT ::= id:varID equals EXPRESSIONS {:
    addElement("var", varID);
:};

ASSIGNMENT ::= VARTYPE id:varID {:
    addElement("var", varID);
:} | VARTYPE INLINEASSIGNMENTS {: :};

VARTYPE ::= var | let | constsym {: :};

EXPRESSIONS ::= EXPRESSIONS EXPRESSIONOPT EXPRESSIONGROUP
| EXPRESSIONGROUP {: :};

EXPRESSIONGROUP ::= openparenthesis EXPRESSION closeparenthesis
| lessM openparenthesis EXPRESSION closeparenthesis
| not openparenthesis EXPRESSION closeparenthesis
| EXPRESSION {: :};

EXPRESSION ::= EXPRESSION EXPRESSIONOPT VARVALUE
| VARVALUE {: :};

EXPRESSIONOPT ::= plus | lessM | times | times times
| div | mod | or | and | xor | notequals | equals equals
| pluseq | lesseq | timeseq | xoreq | diveq | modeq
| moreoreq | lessoreq | major | minor {: :};

VARVALUE ::= decimal | strtext | breaksym
| id | booltrue | boolfalse | not boolfalse
| not booltrue | not id | id plusplus
| id lessMlessM  | plusplus id | lessMlessM id
| requiresym openparenthesis strtext closeparenthesis {: :};

CONTROLSEQ ::= CONSTROLSEQSYM openparenthesis EXPRESSIONS
closeparenthesis METHODCONTENT {: :};

CONSTROLSEQSYM ::= ifsym | elsesym | elsesym ifsym {: :};

FORSEQ ::= forsym openparenthesis FORSEQPARAMS closeparenthesis
METHODCONTENT {: :};

FORSEQPARAMS ::= ASSIGNMENT semicolom EXPRESSIONS semicolom EXPRESSIONS {: :};

WHILESEQ ::= whilesym openparenthesis EXPRESSIONS closeparenthesis
METHODCONTENT {: :};

DOWHILESEQ ::= dosym METHODCONTENT whilesym
openparenthesis EXPRESSIONS closeparenthesis {: :};

SWITCHSEQ ::= switchsym openparenthesis VARVALUE closeparenthesis
openbracket SWITCHSEQCASES defaultsym colom DECLARATIONS closebracket {: :};

SWITCHSEQCASES ::= SWITCHSEQCASES SWITCHSEQCONTENT
| SWITCHSEQCONTENT {: :};

SWITCHSEQCONTENT ::= casesym VARVALUE colom DECLARATIONS breaksym
| casesym VARVALUE colom DECLARATIONS breaksym semicolom
| casesym VARVALUE colom breaksym semicolom
| casesym VARVALUE colom breaksym {: :};

CONSOLESEQ ::= console dot logsym
openparenthesis EXPRESSIONS closeparenthesis
| console dot logsym openparenthesis closeparenthesis {: :};
