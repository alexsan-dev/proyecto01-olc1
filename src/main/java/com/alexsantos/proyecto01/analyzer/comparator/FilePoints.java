package com.alexsantos.proyecto01.analyzer.comparator;

/**
 *
 * @author alex
 */
public class FilePoints {

    public float classPoints, varPoints, methodPoints, commentPoints;
    public int classCount, varCount, methodCount, commentCount;

    public FilePoints(
            float classPoints,
            float varPoints,
            float methodPoints,
            float commentPoints,
            int classCount,
            int varCount,
            int methodCount,
            int commentCount) {
        this.classPoints = classPoints;
        this.varPoints = varPoints;
        this.methodPoints = methodPoints;
        this.commentPoints = commentPoints;

        this.classCount = classCount;
        this.varCount = varCount;
        this.methodCount = methodCount;
        this.commentCount = commentCount;
    }
}
