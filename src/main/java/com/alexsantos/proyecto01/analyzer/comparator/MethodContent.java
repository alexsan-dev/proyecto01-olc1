package com.alexsantos.proyecto01.analyzer.comparator;

import java.util.ArrayList;

/**
 *
 * @author alex
 */
public class MethodContent {

    // GLOBALES
    public ArrayList<String[]> list;
    public int lineStart;
    public int lineEnd;

    /**
     * Constructor
     *
     * @param list
     * @param lineStart
     * @param lineEnd
     */
    public MethodContent(ArrayList<String[]> list, int lineStart, int lineEnd) {
        this.lineStart = lineStart;
        this.lineEnd = lineEnd;
        this.list = list;
    }

}
