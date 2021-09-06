package com.alexsantos.proyecto01.analyzer.tokens;

/**
 *
 * @author alex
 */
public class TokenSymbol {

    // GLOBALES
    public int line, col;
    public String file, lex, key;

    /**
     * Constructor
     *
     * @param file
     * @param lex
     * @param key
     * @param line
     * @param col
     */
    public TokenSymbol(String file, String lex, String key, int line, int col) {
        this.file = file;
        this.lex = lex;
        this.key = key;
        this.line = line;
        this.col = col;
    }
}
