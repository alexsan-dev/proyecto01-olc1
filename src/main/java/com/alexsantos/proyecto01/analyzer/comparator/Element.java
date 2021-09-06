package com.alexsantos.proyecto01.analyzer.comparator;

/**
 *
 * @author alex
 */
public class Element {

    // GLOBALES
    public double points;
    public String value;
    public String key;

    /**
     * Constructor
     *
     * @param key
     * @param value
     * @param points
     */
    public Element(String key, String value, double points) {
        this.key = key;
        this.value = value;
        this.points = points;
    }

    /**
     * Agregar puntos a clase
     *
     * @param nextPoints
     */
    public void addPoints(double nextPoints) {
        points += nextPoints;
    }
}
