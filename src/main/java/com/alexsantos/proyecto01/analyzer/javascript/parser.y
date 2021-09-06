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
        errorHandler.add(s, filePath);
    }

    public void unrecovered_syntax_error (Symbol s) throws java.lang.Exception {
        System.err.println("\nError sintactico irrecuperable en la linea " +
        s.right + " columna " + s.left + " componente: " + s.value +
        " no reconocido.\n");

        ErrorHandler errorHandler = ErrorHandler.getInstance();
        errorHandler.add(s, filePath);
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
                    && methodStart < content.lineEnd) {
                 addElement("class-method", classID + "-" + declaration[2]);
               }
            }
        }
    }

    public void addToken (String lex, String key, int line, int col) {
        TokensHandler tokens = TokensHandler.getInstance();
        tokens.add(parser.filePath, lex, key, line, col);
    }
:}

/* TIPOS GENERALES */
terminal String decimal,
strtext, id, cmt, mcmt;

/* SIMBOLOS */
terminal comma,equals,openbracket,
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
EXPRESSION,COMMENTS,SWITCHSEQ,
SWITCHSEQCASES,SWITCHSEQCONTENT,EXPRESSIONOPT,
FORSEQ,WHILESEQ,DOWHILESEQ,CONSOLESEQ,
FORSEQPARAMS,EXPRESSIONGROUP,
INLINEASSIGNMENTS,INLINEASSIGNMENT;

/* NO TERMINALES MEDIBLES */
non terminal String[] FUNCTIONHEADER, DECLARATION;
non terminal String COMMENT, MULTICOMMENT, VARTYPE;
non terminal ArrayList<String[]> DECLARATIONS;
non terminal String FUNCTION, CONSTROLSEQSYM;
non terminal MethodContent METHODCONTENT;
non terminal Object FUNCTIONPARAMS;

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
START ::= METHODS {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* FUNCIONES PRINCIPALES */
METHODS ::= METHODS METHOD | METHOD {: :};

METHOD ::= NEWCLASS | FUNCTION | COMMENTS {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* COMENTARIOS */
COMMENTS ::= COMMENTS MULTICOMMENT:text {: addElement("comment", text); :}
| COMMENTS COMMENT:text {: addElement("comment", text); :}
| MULTICOMMENT:text {: addElement("comment", text); :}
| COMMENT:text {: addElement("comment", text); :};

COMMENT ::= cmt:text {:
    RESULT = text;
    addToken("comment", text, textright, textleft);
:};

MULTICOMMENT ::= mcmt:text {:
    RESULT = text;
    addToken("multicomment", text, textright, textleft);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* CONTENIDO ENTRE LLAVES */
METHODCONTENT ::= openbracket:openLine
DECLARATIONS:list closebracket:closeLine {:
    int lineStart = openLineright;
    int lineEnd = closeLineright;

    MethodContent data = new MethodContent(list, lineStart, lineEnd);
    addToken("openbracket", "{", openLineright, openLineleft);
    RESULT = data;
:} | openbracket:openLine closebracket:closeLine {:
    int lineStart = openLineright;
    int lineEnd = closeLineright;

    MethodContent data = new MethodContent(null, lineStart, lineEnd);
    addToken("openbracket", "{", openLineright, openLineleft);
    RESULT = data;
:} error openbracket {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* CLASES */
NEWCLASS ::= classsym id:classID METHODCONTENT:content {:
    String counter = Integer.toString(content.lineEnd - content.lineStart);
    addElement("class", classID);
    addElement("class-lines", counter);
    addClassMethod(classID, content);
    addToken("class", classID, classIDright, classIDleft);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* METODOS */
FUNCTIONHEADER ::=  id:funcID openparenthesis
FUNCTIONPARAMS:params closeparenthesis {:
    String[] paramss = new String[]{funcID, Integer.toString((int) params)};
    RESULT = paramss;
    addToken("function", funcID, funcIDright, funcIDleft);
:} | id:funcID openparenthesis closeparenthesis {:
    String[] paramss = new String[]{funcID, "0"};
    RESULT = paramss;
    addToken("function", funcID, funcIDright, funcIDleft);
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
    addToken("function", funcID[0], funcIDright, funcIDleft);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* DECLARACIONES */
DECLARATIONS ::= DECLARATIONS:list DECLARATION:line semicolom {:
    RESULT = list;
    String[] data = new String[] {line[0], line[1], line[2]};
    RESULT.add(data);
    addToken("semicolom", ";", lineright, lineleft);
:} | DECLARATIONS:list DECLARATION:line {:
    RESULT = list;
    String[] data = new String[] {line[0], line[1], line[2]};
    RESULT.add(data);
:} | DECLARATION:line semicolom {:
    ArrayList<String[]> list = new ArrayList<String[]>();
    String[] data = new String[] {line[0], line[1], line[2]};
    RESULT = list;
    RESULT.add(data);
    addToken("semicolom", ";", lineright, lineleft);
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
    addToken("id", varID, varIDright, varIDleft);
:};

ASSIGNMENT ::= VARTYPE:varText id:varID {:
    addElement("var", varID);
    addToken("id", varID, varIDright, varIDleft);
    addToken("vartype", varText, varTextright, varTextleft);
:} | VARTYPE INLINEASSIGNMENTS
| INLINEASSIGNMENTS {: :};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* TIPOS DE VARIABLES */
VARTYPE ::= var {: RESULT = "var"; :}
| let {: RESULT = "let"; :}
| constsym {: RESULT = "const"; :} ;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* TODAS LAS EXPRESIONES VALIDAS */
EXPRESSIONS ::= EXPRESSIONS EXPRESSIONOPT EXPRESSIONGROUP
| EXPRESSIONGROUP {: :};

EXPRESSIONGROUP ::= openparenthesis EXPRESSION closeparenthesis
| lessM openparenthesis EXPRESSION closeparenthesis
| not openparenthesis EXPRESSION closeparenthesis
| EXPRESSION {: :};

EXPRESSION ::= EXPRESSION EXPRESSIONOPT VARVALUE
| VARVALUE | error VARVALUE | error EXPRESSIONOPT {: :};

EXPRESSIONOPT ::= plus:text {:
    addToken("plus", "+", textright, textleft);
:} | lessM:text {:
    addToken("lessM", "-", textright, textleft);
:} | times:text {:
    addToken("times", "*", textright, textleft);
:} | times times:text {:
    addToken("timestimes", "**", textright, textleft);
:} | div:text {:
    addToken("div", "/", textright, textleft);
:} | mod:text {:
    addToken("mod", "%", textright, textleft);
:} | or:text {:
    addToken("or", "||", textright, textleft);
:} | and:text {:
    addToken("and", "&&", textright, textleft);
:} | xor:text {:
    addToken("xors", "^", textright, textleft);
:} | notequals:text {:
    addToken("notequals", "!=", textright, textleft);
:} | equals equals:text {:
    addToken("equalsequals", "==", textright, textleft);
:} | pluseq:text {:
    addToken("pluseq", "+=", textright, textleft);
:} | lesseq:text {:
    addToken("lesseq", "-=", textright, textleft);
:} | timeseq:text {:
    addToken("timeseq", "*=", textright, textleft);
:} | xoreq:text {:
    addToken("xoreq", "^=", textright, textleft);
:} | diveq:text {:
    addToken("diveq", "/=", textright, textleft);
:} | modeq:text {:
    addToken("modeq", "%=", textright, textleft);
:} | moreoreq:text {:
    addToken("moreoreq", ">=", textright, textleft);
:} | lessoreq:text {:
    addToken("lessoreq", "<=", textright, textleft);
:} | major:text {:
    addToken("major", ">", textright, textleft);
:} | minor:text {:
    addToken("minor", "-", textright, textleft);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* VALORES DE VARIABLES */
VARVALUE ::= decimal:text {:
    addToken("number", text, textright, textleft);
:} | strtext:text {:
    addToken("string", text, textright, textleft);
:} | breaksym:text {:
    addToken("break", "break", textright, textleft);
:} | id:text {:
    addToken("id", text, textright, textleft);
:} | booltrue:text {:
    addToken("bool", "true", textright, textleft);
:} | boolfalse:text {:
    addToken("bool", "false", textright, textleft);
:} | not boolfalse:text {:
    addToken("notbool", "!false", textright, textleft);
:} | not booltrue:text {:
    addToken("notbool", "!true", textright, textleft);
:} | not id:text {:
    addToken("id", text, textright, textleft);
:} | id:text plusplus {:
    addToken("id", text, textright, textleft);
:} | id:text lessMlessM {:
    addToken("id", text, textright, textleft);
:} | plusplus id:text {:
    addToken("id", text, textright, textleft);
:} | lessMlessM id:text {:
    addToken("id", text, textright, textleft);
:} | requiresym:req openparenthesis strtext:text closeparenthesis {:
    addToken("require", "require", reqright, reqleft);
    addToken("string", text, textright, textleft);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* IF ELSE */
CONTROLSEQ ::= CONSTROLSEQSYM:sym openparenthesis EXPRESSIONS
closeparenthesis METHODCONTENT {:
    addToken("controlsym", sym, symright, symleft);
:} | elsesym:sym METHODCONTENT {:
    addToken("controlsym", "else", symright, symleft);
:};

CONSTROLSEQSYM ::= ifsym {: RESULT = "if"; :}
| elsesym ifsym {: RESULT = "else if"; :} ;

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* FOR */
FORSEQ ::= forsym:sym openparenthesis:par FORSEQPARAMS closeparenthesis:par2
METHODCONTENT {:
    addToken("forsym", "for", symright, symleft);
    addToken("openparenthesis", "(", parright, parleft);
    addToken("closeparenthesis", ")", par2right, par2left);
:};

FORSEQPARAMS ::= ASSIGNMENT semicolom:s1 EXPRESSIONS semicolom:s2 EXPRESSIONS {:
    addToken("semicolom", ";", s1right, s1left);
    addToken("semicolom", ";", s2right, s2left);
:} | ASSIGNMENT semicolom:s1 EXPRESSIONS semicolom:s2 ASSIGNMENT {:
    addToken("semicolom", ";", s1right, s1left);
    addToken("semicolom", ";", s2right, s2left);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* WHILE */
WHILESEQ ::= whilesym:sym openparenthesis:par EXPRESSIONS closeparenthesis:par2
METHODCONTENT {:
    addToken("whilesym", "while", symright, symleft);
    addToken("openparenthesis", "(", parright, parleft);
    addToken("closeparenthesis", ")", par2right, par2left);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* DO WHILE */
DOWHILESEQ ::= dosym:dos METHODCONTENT whilesym:sym
openparenthesis:par EXPRESSIONS closeparenthesis:par2 {:
    addToken("dosym", "do", dosright, dosleft);
    addToken("whilesym", "while", symright, symleft);
    addToken("openparenthesis", "(", parright, parleft);
    addToken("closeparenthesis", ")", par2right, par2left);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* SWITCH */
SWITCHSEQ ::= switchsym:sym openparenthesis:par VARVALUE closeparenthesis:par2
openbracket:b1 SWITCHSEQCASES defaultsym:defsym colom:cols
DECLARATIONS closebracket:b2 {:
    addToken("switchsym", "switch", symright, symleft);
    addToken("openparenthesis", "(", parright, parleft);
    addToken("closeparenthesis", ")", par2right, par2left);
    addToken("openbracket", "{", b1right, b2left);
    addToken("colom", ":", colsright, colsleft);
    addToken("defaultsym", "default", defsymright, defsymleft);
:};

SWITCHSEQCASES ::= SWITCHSEQCASES SWITCHSEQCONTENT
| SWITCHSEQCONTENT {: :};

SWITCHSEQCONTENT ::= casesym:sym VARVALUE colom:cols DECLARATIONS breaksym:br {:
    addToken("casesym", "case", symright, symleft);
    addToken("colom", ":", colsright, colsleft);
    addToken("breaksym", "break", brright, brleft);
:} | casesym:sym VARVALUE colom:cols DECLARATIONS breaksym:br semicolom:sm {:
    addToken("casesym", "case", symright, symleft);
    addToken("colom", ":", colsright, colsleft);
    addToken("breaksym", "break", brright, brleft);
    addToken("semicolom", ";", smright, smleft);
:} | casesym:sym VARVALUE colom:cols breaksym:br semicolom:sm {:
    addToken("casesym", "case", symright, symleft);
    addToken("colom", ":", colsright, colsleft);
    addToken("breaksym", "break", brright, brleft);
    addToken("semicolom", ";", smright, smleft);
:} | casesym:sym VARVALUE colom:cols breaksym:br {:
    addToken("casesym", "case", symright, symleft);
    addToken("colom", ":", colsright, colsleft);
    addToken("breaksym", "break", brright, brleft);
:};

/*. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .*/
/* CONSOLE.LOG */
CONSOLESEQ ::= console:cls dot:d logsym:logs
openparenthesis:c1 EXPRESSIONS closeparenthesis:c2 {:
    addToken("console", "console", clsright, clsleft);
    addToken("dot", ".", dright, dleft);
    addToken("log", "log", logsright, logsleft);
    addToken("openparenthesis", "(", c1right, c1left);
    addToken("closeparenthesis", ")", c2right, c2left);
:} | console:cls dot:d logsym:logs openparenthesis:c1 closeparenthesis:c2 {:
    addToken("console", "console", clsright, clsleft);
    addToken("dot", ".", dright, dleft);
    addToken("log", "log", logsright, logsleft);
    addToken("openparenthesis", "(", c1right, c1left);
    addToken("closeparenthesis", ")", c2right, c2left);
:};
