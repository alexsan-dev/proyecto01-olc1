package com.alexsantos.proyecto01.analyzer.errors;

import java_cup.runtime.*;

/**
 *
 * @author alex
 */
public class ErrorSymbol {

    // GLOBALES
    int line, col;
    Object lex;
    String file;

    /**
     * Constructor
     *
     * @param s
     * @param file
     */
    public ErrorSymbol(Symbol s, String file) {
        line = s.left;
        col = s.right;
        lex = s.value;
        this.file = file;
    }
}
