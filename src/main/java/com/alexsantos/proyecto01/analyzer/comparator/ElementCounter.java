package com.alexsantos.proyecto01.analyzer.comparator;

/**
 *
 * @author alex
 */
public class ElementCounter {

    // GLOBALES
    public String proyectName;
    public String file;
    public int counter;
    public String key;

    /**
     * Constructor
     *
     * @param key
     * @param counter
     */
    public ElementCounter(String proyectName, String file, String key, int counter) {
        this.key = key;
        this.file = file;
        this.counter = counter;
        this.proyectName = proyectName;
    }

}
