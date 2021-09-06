package com.alexsantos.proyecto01.fca;

import com.alexsantos.proyecto01.analyzer.comparator.ElementCounter;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.stream.Stream;

/**
 *
 * @author alex
 */
public class AnalyticsReport {

    private ArrayList<ElementCounter> elements;
    private String proyect1, proyect2;

    /**
     * Constructor
     */
    public AnalyticsReport(ArrayList<ElementCounter> elements, String proyect1, String proyect2) {
        this.elements = elements;
        this.proyect1 = proyect1;
        this.proyect2 = proyect2;
    }

    /**
     * Generar filas
     *
     * @return
     */
    public String getTokenTable() {
        String content = "";

        int pr1Vars = 0,
                pr1Methods = 0,
                pr1Classes = 0,
                pr1Comments = 0,
                pr2Vars = 0,
                pr2Methods = 0,
                pr2Classes = 0,
                pr2Comments = 0;

        for (int elementIndex = 0; elementIndex < elements.size(); elementIndex++) {
            ElementCounter element = elements.get(elementIndex);
            int counter = element.counter;

            // VERIFICAR NOMBRE DE ARCHIVO
            if (element.proyectName.equals(proyect1)) {
                if (element.key.equals("var")) {
                    pr1Vars = counter;
                }
                if (element.key.equals("method")) {
                    pr1Methods = counter;
                }
                if (element.key.equals("class")) {
                    pr1Classes = counter;
                }
                if (element.key.equals("comment")) {
                    pr1Comments = counter;
                }

            }

            // ARCHIVO EN PROYECTO 2
            if (element.proyectName.equals(proyect2)) {
                if (element.key.equals("var")) {
                    pr2Vars = counter;
                }
                if (element.key.equals("method")) {
                    pr2Methods = counter;
                }
                if (element.key.equals("class")) {
                    pr2Classes = counter;
                }
                if (element.key.equals("comment")) {
                    pr2Comments = counter;
                }

            }
        }

        // CREAR STRING
        content += "<tr><td>Total Variables</td><td>" + Integer.toString(pr1Vars) + "</td><td>" + Integer.toString(pr2Vars) + "</td></tr>"
                + "<tr><td>Total Clases</td><td>" + Integer.toString(pr1Classes) + "</td><td>" + Integer.toString(pr2Classes) + "</td></tr>"
                + "<tr><td>Total Metodos</td><td>" + Integer.toString(pr1Methods) + "</td><td>" + Integer.toString(pr2Methods) + "</td></tr>"
                + "<tr><td>Total Comentarios</td><td>" + Integer.toString(pr1Comments) + "</td><td>" + Integer.toString(pr2Comments) + "</td></tr>";

        // RECORRER
        return content;
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
     * Editar archivo
     *
     * @param filePath
     * @param oldString
     * @param newString
     */
    private void modifyFile(String filePath, String oldString, String newString) {
        try {
            byte[] encoded = Files.readAllBytes(Paths.get(filePath));
            String content = new String(encoded, "utf-8");

            FileWriter writer = new FileWriter("report/analytics/index.html");
            String contentWithTable = content.replace(oldString, newString);

            // GRAFICAS
            String barCharts = "", lineCharts = "", pieCharts = "";
            ArrayList<String> assetPaths = getPaths("report/assets");
            for (int pathIndex = 0; pathIndex < assetPaths.size(); pathIndex++) {
                String asset = assetPaths.get(pathIndex);

                if (asset.startsWith("barchart_")) {
                    barCharts += "<img src=\"../assets/" + asset + "\"/>";
                }

                if (asset.startsWith("linechart_")) {
                    lineCharts += "<img src=\"../assets/" + asset + "\"/>";
                }

                if (asset.startsWith("piechart_")) {
                    pieCharts += "<img src=\"../assets/" + asset + "\"/>";
                }
            }

            contentWithTable = contentWithTable.replace("{line_charts}", lineCharts)
                    .replace("{bar_charts}", barCharts)
                    .replace("{pie_chart}", pieCharts);
            writer.write(contentWithTable);
            writer.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    /**
     * Seleccionar template
     */
    public void generateReport() {
        modifyFile("report/analytics/template.html", "{table_content}", getTokenTable());
    }
}
