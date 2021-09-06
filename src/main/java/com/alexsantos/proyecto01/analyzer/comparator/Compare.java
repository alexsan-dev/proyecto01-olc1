package com.alexsantos.proyecto01.analyzer.comparator;

import com.alexsantos.proyecto01.analyzer.javascript.JSParser;
import com.alexsantos.proyecto01.analyzer.javascript.JSScanner;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.stream.Stream;

/**
 *
 * @author alex
 */
public class Compare {

    // GLOBALES
    public String path1;
    public String path2;
    public ArrayList<String> project1Paths;
    public ArrayList<String> project2Paths;
    private ArrayList<ElementCounter> elements;

    /**
     * Comparar proyectos
     *
     * @param path1
     * @param path2
     */
    public Compare(String path1, String path2) {
        project1Paths = new ArrayList<String>();
        project2Paths = new ArrayList<String>();
        elements = new ArrayList<ElementCounter>();
        this.path1 = path1;
        this.path2 = path2;
    }

    public ArrayList<ElementCounter> getElements() {
        return elements;
    }

    /**
     * Obtener todos los archivos de una carpeta
     *
     * @param path
     * @param list
     */
    public ArrayList<String> getPaths(String path) {
        ArrayList<String> list = new ArrayList<String>();

        // PROJECTO 1
        try (Stream<Path> paths = Files.walk(Paths.get(path))) {
            // FILTRAR
            paths
                    .filter(Files::isRegularFile)
                    .forEach(file -> {
                        // AGREGAR
                        list.add(file.getFileName().toString());
                    });
        } catch (IOException ex) {
            System.out.println(ex);
        }

        return list;
    }

    /**
     * Obtener puntaje general
     *
     * @param points
     * @return
     */
    public double getGeneralPoints(HashMap<String, FilePoints> points) {
        // PUNTOS
        double generalPoints = 0;
        double classPoints = 0;
        double varPoints = 0;
        double methodPoints = 0;
        double commentPoints = 0;

        int classCount = 0;
        int varCount = 0;
        int methodCount = 0;
        int commentCount = 0;

        // ASIGNAR PUNTOS DE PROYECTO1
        for (int i = 0; i < project1Paths.size(); i++) {
            FilePoints fPoints = points.get(project1Paths.get(i));

            // CALCULAR PUNTOS DE CLASES
            for (Element entry : fPoints.classPoints.values()) {
                classCount++;
                classPoints += entry.points;
            }

            // CALCULAR PUNTOS DE VARIABLES
            for (Element entry : fPoints.varPoints.values()) {
                varCount++;
                varPoints += entry.points;
            }

            // CALCULAR PUNTOS DE METODOS
            for (Element entry : fPoints.methodPoints.values()) {
                methodCount++;
                methodPoints += entry.points;
            }

            // CALCULAR PUNTOS DE COMENTARIOS
            for (Element entry : fPoints.commentPoints.values()) {
                commentCount++;
                commentPoints += entry.points;
            }
        }

        // CALCULAR CRITERIOS DE PUNTAJE GENERAL
        double genComments = (double) ((Double.compare(commentPoints, 0.6) > 0) ? ((commentCount / commentPoints) * 0.2) : 0);
        double genVars = (double) ((Double.compare(varPoints, 0.6) > 0) ? ((varCount / varPoints) * 0.2) : 0);
        double genMethods = (double) ((Double.compare(methodPoints, 0.6) > 0) ? ((methodCount / methodPoints) * 0.3) : 0);
        double genClasses = (double) ((Double.compare(classPoints, 0.6) > 0) ? ((classCount / classPoints) * 0.3) : 0);

        // CALCULAR PUNTAJE GENERAL
        generalPoints = genComments + genVars + genMethods + genClasses;
        return generalPoints;
    }

    /**
     * Obtener Hash de puntos
     *
     * @return HashMap<String, FilePoints>
     */
    public HashMap<String, FilePoints> getRange() {
        // PUNTAJE ESPECIFICO
        HashMap<String, FilePoints> points = new HashMap<String, FilePoints>();

        // LEER RUTAS
        project1Paths = getPaths(path1);
        project2Paths = getPaths(path2);

        String prPath1 = path1.substring(0, path1.length() - 1);
        String prPath2 = path2.substring(0, path2.length() - 1);

        String proyectPath1 = prPath1.substring(prPath1.lastIndexOf("/") + 1);
        String proyectPath2 = prPath2.substring(prPath2.lastIndexOf("/") + 1);

        // RECORRER
        for (int i = 0; i < project1Paths.size(); i++) {
            // RUTA DEL MISMO ARCHIVO EN DOS PROYECTOS
            String path = project1Paths.get(i);
            String newPath1 = path1 + path;
            String newPath2 = path2 + path;

            String parentPath1 = path1.substring(path1.lastIndexOf("/") + 1) + path;
            String parentPath2 = path2.substring(path2.lastIndexOf("/") + 1) + path;

            // ARCHIVOS
            JSParser parser1 = null;
            JSParser parser2 = null;
            File file1 = null;
            File file2 = null;

            // GENERAR ARCHIVOS
            try {
                file1 = new File(newPath1);
                file2 = new File(newPath2);

            } catch (Exception ex) {
                System.err.println("Error en projecto : " + ex.getMessage());
            }

            // CREAR PARSERS
            try {
                // ARCHIVO 01
                parser1 = new JSParser(new JSScanner(new BufferedReader(new FileReader(file1))));
                parser2 = new JSParser(new JSScanner(new BufferedReader(new FileReader(file2))));

            } catch (Exception ex) {
                System.err.println("Error en archivos : " + ex.getMessage());
            }

            // GENERAR PARSER
            try {
                parser1.setFilePath(parentPath1);
                parser1.parse();

                parser2.setFilePath(parentPath2);
                parser2.parse();
            } catch (Exception ex) {
                System.err.println("Error en parsers : " + ex.getMessage());
            }

            // ELEMENTOS
            HashMap<String, ArrayList<String>> elementsPr1 = parser1.getElements();
            HashMap<String, ArrayList<String>> elementsPr2 = parser2.getElements();

            // CLASSES
            HashMap<String, Element> classPoints = new HashMap<String, Element>();
            ArrayList<String> classList1 = elementsPr1.get("class");
            ArrayList<String> classList2 = elementsPr2.get("class");

            ElementCounter classCounter1 = new ElementCounter(proyectPath1, newPath1, "class", classList1.size());
            ElementCounter classCounter2 = new ElementCounter(proyectPath2, newPath2, "class", classList2.size());
            elements.add(classCounter1);
            elements.add(classCounter2);

            ArrayList<String> classLines1 = elementsPr1.get("class-lines");
            ArrayList<String> classLines2 = elementsPr2.get("class-lines");

            ArrayList<String> classMethods1 = elementsPr1.get("class-method");
            ArrayList<String> classMethods2 = elementsPr2.get("class-method");

            // BUSCAR
            for (int cI = 0; cI < classList1.size(); cI++) {
                // LOCAL
                String currentId = classList1.get(cI);

                // NUMERO DE LINEAS
                int lines = Integer.parseInt(classLines1.get(cI));

                // BUSCAR EN SEGUNDO ARCHIVO
                for (int cI2 = 0; cI2 < classList2.size(); cI2++) {
                    // LINEAS DEL SEGUNDO
                    int linesPr2 = Integer.parseInt(classLines2.get(cI));

                    // MISMO NUMERO DE ID
                    if (currentId.equals(classList2.get(cI2))) {
                        double localPoints = 0.2;

                        // BUSCAR REPITENCIA DE METODOS DE UNA CLASE
                        for (int methodIndex = 0; methodIndex < classMethods1.size(); methodIndex++) {
                            // ID METODO 1
                            boolean breakMethodSearch = false;
                            String methodId = classMethods1.get(methodIndex);

                            if (methodId.contains(currentId)) {
                                for (int method2Index = 0; method2Index < classMethods2.size(); method2Index++) {
                                    // ID METODO 2
                                    String methodId2 = classMethods2.get(method2Index);

                                    // MISMOS IDS
                                    if (methodId.equals(methodId2)) {
                                        breakMethodSearch = true;
                                        break;
                                    }
                                }

                                // AGREGAR PUNTOS
                                if (breakMethodSearch) {
                                    localPoints += 0.4;
                                    break;
                                }
                            }
                        }

                        // MISMO NUMERO DE LINEAS
                        if (lines == linesPr2) {
                            localPoints += 0.4;
                        }

                        // AGREGAR PUNTOS DE CLASE REPETIDA
                        Element classElement = new Element("class", currentId, localPoints);
                        classPoints.put(currentId, classElement);
                    }
                }
            }

            // REPITENCIA EN METODOS
            HashMap<String, Element> methodPoints = new HashMap<String, Element>();
            ArrayList<String> methodList1 = elementsPr1.get("method");
            ArrayList<String> methodList2 = elementsPr2.get("method");

            ElementCounter methodCounter1 = new ElementCounter(proyectPath1, newPath1, "method", methodList1.size());
            ElementCounter methodCounter2 = new ElementCounter(proyectPath2, newPath2, "method", methodList2.size());
            elements.add(methodCounter1);
            elements.add(methodCounter2);

            ArrayList<String> methodLines1 = elementsPr1.get("method-lines");
            ArrayList<String> methodLines2 = elementsPr2.get("method-lines");

            ArrayList<String> methodParams1 = elementsPr1.get("method-params");
            ArrayList<String> methodParams2 = elementsPr2.get("method-params");

            // NOMBRES
            for (int cI = 0; cI < methodList1.size(); cI++) {
                // LOCAL
                String currentId = methodList1.get(cI);
                int lines = Integer.parseInt(methodLines1.get(cI));
                int params = Integer.parseInt(methodParams1.get(cI));

                for (int cI2 = 0; cI2 < methodList2.size(); cI2++) {
                    // LINEAS Y PARAMETROS
                    int lines2 = Integer.parseInt(methodLines2.get(cI2));
                    int params2 = Integer.parseInt(methodParams2.get(cI2));
                    double localPoints = 0;

                    if (currentId.equals(methodList2.get(cI2))) {
                        localPoints += 0.4;

                        // MISMOS PARAMETROS
                        if (params == params2) {
                            localPoints += 0.3;
                        }

                        // MISMAS LINEAS
                        if (lines == lines2) {
                            localPoints += 0.3;
                        }

                    } else {

                        // MISMAS LINEAS
                        if (lines == lines2) {
                            localPoints += 0.3;

                            // MISMOS PARAMETROS
                            if (params == params2) {
                                localPoints += 0.3;
                            }

                        }
                    }

                    // AGREGAR PUNTOS DE METODO
                    if (localPoints > 0) {
                        Element methodElement = new Element("method", currentId, localPoints);
                        methodPoints.put(currentId, methodElement);
                    }
                }
            }

            // REPITENCIA DE VARIABLES
            HashMap<String, Element> varPoints = new HashMap<String, Element>();
            ArrayList<String> varList1 = elementsPr1.get("var");
            ArrayList<String> varList2 = elementsPr2.get("var");

            ElementCounter varCounter1 = new ElementCounter(proyectPath1, newPath1, "var", varList1.size());
            ElementCounter varCounter2 = new ElementCounter(proyectPath2, newPath2, "var", varList2.size());
            elements.add(varCounter1);
            elements.add(varCounter2);

            // NOMBRES
            for (int cI = 0; cI < varList1.size(); cI++) {
                // LOCAL
                String currentId = varList1.get(cI);

                for (int cI2 = 0; cI2 < varList2.size(); cI2++) {
                    // MISMO NOMBRE
                    if (currentId.equals(varList2.get(cI2))) {
                        Element varElement = new Element("var", currentId, 1);
                        varPoints.put(currentId, varElement);
                    }
                }
            }

            // REPITENCIA DE COMENTARIOS
            HashMap<String, Element> commentPoints = new HashMap<String, Element>();
            ArrayList<String> commentList1 = elementsPr1.get("comment");
            ArrayList<String> commentList2 = elementsPr2.get("comment");

            ElementCounter commentCounter1 = new ElementCounter(proyectPath1, newPath1, "comment", commentList1.size());
            ElementCounter commentCounter2 = new ElementCounter(proyectPath2, newPath2, "comment", commentList2.size());
            elements.add(commentCounter1);
            elements.add(commentCounter2);

            // NOMBRES
            for (int cI = 0; cI < commentList1.size(); cI++) {
                // LOCAL
                String currentId = commentList1.get(cI);

                for (int cI2 = 0; cI2 < commentList2.size(); cI2++) {
                    // MISMO NOMBRE
                    if (currentId.equals(commentList2.get(cI2))) {
                        Element commentElement = new Element("comment", currentId, 1);
                        commentPoints.put(currentId, commentElement);
                    }
                }
            }

            // AGREGAR PUNTOS
            FilePoints filePoints = new FilePoints(classPoints, varPoints, methodPoints, commentPoints);
            points.put(path, filePoints);
        }

        return points;
    }
}
