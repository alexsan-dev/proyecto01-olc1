package com.alexsantos.proyecto01.analyzer.errors;

import java_cup.runtime.*;

/**
 *
 * @author alex
 */
public class ErrorSymbol {

    // GLOBALES
    public int line, col;
    public Object lex;
    public String file, msg;

    /**
     * Constructor
     *
     * @param s
     * @param file
     */
    public ErrorSymbol(Symbol s, String file, String msg) {
        line = s.right;
        col = s.left;
        lex = s.value;
        this.msg = msg;
        this.file = file;
    }
}
