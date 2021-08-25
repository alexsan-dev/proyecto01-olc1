package com.alexsantos.proyecto01.analyzer.errors;

import java.util.ArrayList;
import java_cup.runtime.*;

/**
 *
 * @author alex
 */
public class ErrorHandler {

    public static ErrorHandler errHandler;
    public static ArrayList<ErrorSymbol> symbols;

    /**
     * Constructor
     *
     * @return
     */
    public static ErrorHandler getInstance() {
        // VALIDAR NULLO
        if (errHandler == null) {
            cleanProps();
        }

        // RETORNAR INSTANCIA
        return errHandler;
    }

    /**
     * Reiniciar clase y propiedades
     */
    public static void cleanProps() {
        symbols = new ArrayList<ErrorSymbol>();
        errHandler = new ErrorHandler();
    }

    /**
     * Agregar simbolo de error
     *
     * @param s
     * @param file
     */
    public static void add(Symbol s, String file) {
        ErrorSymbol symbol = new ErrorSymbol(s, file);
        symbols.add(symbol);
    }
}
