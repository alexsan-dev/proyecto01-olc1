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

    String path1;
    String path2;
    ArrayList<String> project1Paths;
    ArrayList<String> project2Paths;

    /**
     * Constructor
     */
    public Compare(String path1, String path2) {
        this.path1 = path1;
        this.path2 = path2;
        project1Paths = new ArrayList<String>();
        project2Paths = new ArrayList<String>();
    }

    private void getPaths(String path, ArrayList<String> list) {
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
    }

    public float getGeneralPoints(HashMap<String, FilePoints> points) {
        float generalPoints = 0;
        float commentPoints = 0;
        float varPoints = 0;
        float methodPoints = 0;
        float classPoints = 0;
        int commentCount = 0;
        int varCount = 0;
        int methodCount = 0;
        int classCount = 0;

        for (int i = 0; i < project1Paths.size(); i++) {
            FilePoints fPoints = points.get(project1Paths.get(i));
            commentPoints += fPoints.commentPoints;
            varPoints += fPoints.varPoints;
            methodPoints += fPoints.methodPoints;
            classPoints += fPoints.classPoints;
            commentCount += fPoints.commentCount;
            varCount += fPoints.varCount;
            methodCount += fPoints.methodCount;
            classCount += fPoints.classCount;
        }

        for (int i = 0; i < project2Paths.size(); i++) {
            FilePoints fPoints = points.get(project2Paths.get(i));
            commentPoints += fPoints.commentPoints;
            varPoints += fPoints.varPoints;
            methodPoints += fPoints.methodPoints;
            classPoints += fPoints.classPoints;
            commentCount += fPoints.commentCount;
            varCount += fPoints.varCount;
            methodCount += fPoints.methodCount;
            classCount += fPoints.classCount;
        }

        generalPoints = (float) (((commentCount / commentPoints) * 0.2) + ((varCount / varPoints) * 0.2) + ((methodCount / methodPoints) * 0.3) + ((classCount / commentPoints) * 0.3));
        return generalPoints;
    }

    public HashMap<String, FilePoints> getRange() {
        // PUNTAJE ESPECIFICO
        HashMap<String, FilePoints> points = new HashMap<String, FilePoints>();

        // LEER RUTAS
        getPaths(path1, project1Paths);
        getPaths(path2, project2Paths);

        // RECORRER
        for (int i = 0; i < project1Paths.size(); i++) {
            String path = project1Paths.get(i);
            String newPath1 = path1 + path;
            String newPath2 = path2 + path;

            File file1 = null;
            File file2 = null;

            JSParser parser1 = null;
            JSParser parser2 = null;

            try {
                file1 = new File(newPath1);
                file2 = new File(newPath2);

            } catch (Exception ex) {
                System.err.println("Error en projecto : " + ex.getMessage());
            }

            // ANALIZAR
            try {
                // ARCHIVO 01
                parser1 = new JSParser(new JSScanner(new BufferedReader(new FileReader(file1))));
                parser2 = new JSParser(new JSScanner(new BufferedReader(new FileReader(file2))));

            } catch (Exception ex) {
                System.err.println("Error en archivos : " + ex.getMessage());
            }

            parser1.setFilePath(newPath1);
            try {
                parser1.parse();
            } catch (Exception ex) {
                System.err.println("Error en parser1 : " + ex.getMessage());
            }

            // ARCHIVO 02
            parser2.setFilePath(newPath2);
            try {
                parser2.parse();
            } catch (Exception ex) {
                System.err.println("Error en parser2 : " + ex.getMessage());
            }

            // ELEMENTOS
            HashMap<String, ArrayList<String>> values1 = parser1.getElements();
            HashMap<String, ArrayList<String>> values2 = parser2.getElements();

            // CLASSES
            ArrayList<String> classList1 = values1.get("class");
            ArrayList<String> classList2 = values2.get("class");

            float classPoints = 0;
            int classCount = 0;

            // REPITENCIA
            for (int cI = 0; cI < classList1.size(); cI++) {
                boolean breakSearch = false;
                String currentId = classList1.get(cI);
                int lines = Integer.parseInt(values1.get("class-lines").get(cI));

                for (int cI2 = 0; cI2 < classList2.size(); cI2++) {
                    int lines2 = Integer.parseInt(values2.get("class-lines").get(cI));

                    if (lines == lines2) {
                        breakSearch = true;
                        classPoints += 0.4;

                    }

                    if (currentId.equals(classList2.get(cI2))) {
                        breakSearch = true;
                        classPoints += 0.2;

                    }

                }

                if (breakSearch) {
                    classCount++;
                }
            }

            // REPITENCIA EN METODOS
            float methodPoints = 0;
            int methodCount = 0;
            ArrayList<String> methodList1 = values1.get("method");
            ArrayList<String> methodList2 = values2.get("method");

            // NOMBRES
            for (int cI = 0; cI < methodList1.size(); cI++) {
                boolean breakSearch = false;
                String currentId = methodList1.get(cI);
                int lines = Integer.parseInt(values1.get("method-lines").get(cI));
                int params = Integer.parseInt(values1.get("method-params").get(cI));

                for (int cI2 = 0; cI2 < methodList2.size(); cI2++) {
                    int lines2 = Integer.parseInt(values2.get("method-lines").get(cI2));
                    int params2 = Integer.parseInt(values2.get("method-params").get(cI2));

                    if (currentId.equals(methodList2.get(cI2))) {
                        if (params == params2) {
                            methodPoints += 0.3;
                        }

                        if (lines == lines2) {
                            methodPoints += 0.3;
                        }
                        classPoints += 0.4;
                        methodPoints += 0.4;
                        breakSearch = true;

                    } else {
                        if (lines == lines2) {
                            methodPoints += 0.3;

                            if (params == params2) {
                                methodPoints += 0.3;
                            }

                            breakSearch = true;

                        }
                    }
                }

                if (breakSearch) {
                    methodCount++;
                }
            }

            // REPITENCIA DE VARIABLES
            float varPoints = 0;
            int varCount = 0;
            ArrayList<String> varList1 = values1.get("var");
            ArrayList<String> varList2 = values2.get("var");

            for (int cI = 0; cI < varList1.size(); cI++) {
                boolean breakSearch = false;
                String currentId = varList1.get(cI);

                for (int cI2 = 0; cI2 < varList2.size(); cI2++) {
                    if (currentId.equals(varList2.get(cI2))) {
                        breakSearch = true;
                    }
                }

                if (breakSearch) {
                    varPoints = 1;
                    varCount++;
                }
            }

            // REPITENCIA DE COMENTARIOS
            float commentPoints = 0;
            int commentCount = 0;
            ArrayList<String> cmtList1 = values1.get("comment");
            ArrayList<String> cmtList2 = values2.get("comment");

            for (int cI = 0; cI < cmtList1.size(); cI++) {
                boolean breakSearch = false;
                String currentId = cmtList1.get(cI);

                for (int cI2 = 0; cI2 < cmtList2.size(); cI2++) {
                    if (currentId.equals(cmtList2.get(cI2))) {
                        breakSearch = true;
                    }
                }

                if (breakSearch) {
                    commentPoints = 1;
                    commentCount++;
                }
            }

            // AGREGAR PUNTOS
            FilePoints filePoints = new FilePoints(classPoints, varPoints, methodPoints, commentPoints, classCount, varCount, methodCount, commentCount);
            points.put(path, filePoints);
        }

        return points;
    }
}
