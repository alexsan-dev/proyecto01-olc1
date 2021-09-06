package com.alexsantos.proyecto01.analyzer.tokens;

import java.util.ArrayList;

/**
 *
 * @author alex
 */
public class TokensHandler {

    public static TokensHandler tkHandler;
    public static ArrayList<TokenSymbol> symbols;

    /**
     * Constructor
     *
     * @return
     */
    public static TokensHandler getInstance() {
        // VALIDAR NULLO
        if (tkHandler == null) {
            cleanProps();
        }

        // RETORNAR INSTANCIA
        return tkHandler;
    }

    /**
     * Reiniciar clase y propiedades
     */
    public static void cleanProps() {
        symbols = new ArrayList<TokenSymbol>();
        tkHandler = new TokensHandler();
    }

    /**
     * Agregar simbolo de error
     *
     * @param s
     * @param file
     */
    public static void add(String file, String lex, String key, int line, int col) {
        TokenSymbol symbol = new TokenSymbol(file, lex, key, line, col);
        symbols.add(symbol);
    }
}
