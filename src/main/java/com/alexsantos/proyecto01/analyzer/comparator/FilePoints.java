package com.alexsantos.proyecto01.analyzer.comparator;

import java.util.HashMap;

/**
 *
 * @author alex
 */
public class FilePoints {

    // GLOBALES
    public HashMap<String, Element> classPoints, varPoints, methodPoints, commentPoints;

    /**
     * Constructor
     *
     * @param classPoints
     * @param varPoints
     * @param methodPoints
     * @param commentPoints
     */
    public FilePoints(
            HashMap<String, Element> classPoints,
            HashMap<String, Element> varPoints,
            HashMap<String, Element> methodPoints,
            HashMap<String, Element> commentPoints) {
        // PUNTOS
        this.classPoints = classPoints;
        this.varPoints = varPoints;
        this.methodPoints = methodPoints;
        this.commentPoints = commentPoints;
    }
}
