package com.alexsantos.proyecto01.graphs;

import com.alexsantos.proyecto01.analyzer.comparator.ElementCounter;
import com.alexsantos.proyecto01.fca.Reports;
import java.io.File;
import java.io.IOException;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtils;
import org.jfree.chart.JFreeChart;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;

/**
 *
 * @author alex
 */
public class LineGraph extends Graph {

    String file;

    /**
     * Constructor
     */
    public LineGraph() {
        file = "";
    }

    /**
     * Asignar propiedades de gráfica
     *
     * @param prop
     */
    @Override
    public void setProp(Object[] prop) {
        if (prop[0] != null) {
            // ENVIAR OTRAS PROPIEDADES
            super.setProp(prop);

            // NOMBRE DE LA PROPIEDAD
            String key = (String) prop[1];

            // ASIGNAR
            if (key.equals("file")) {
                if (file.isEmpty()) {
                    file = (String) prop[0];
                } else {
                    System.err.println("\nError en linea " + prop[2] + " ya se asigno una vez el titulo del Eje X.\n");
                }
            }
        } else {
            System.err.println("\nError valor nulo en linea " + prop[2] + "\n");
        }
    }

    /**
     * Crear lista de datos de freechart
     *
     * @return
     */
    private CategoryDataset createDataset() {
        // DATASET
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        Reports reports = Reports.getInstance();

        // LABELS
        String newPath1 = reports.path1.substring(0, reports.path1.length() - 1);
        String newPath2 = reports.path2.substring(0, reports.path2.length() - 1);

        String series1 = newPath1.substring(newPath1.lastIndexOf("/") + 1);
        String series2 = newPath2.substring(newPath2.lastIndexOf("/") + 1);
        String filePath1 = newPath1 + "/" + file;
        String filePath2 = newPath2 + "/" + file;

        // DATOS
        int pr1Vars = 0, pr1Methods = 0, pr1Classes = 0, pr1Comments = 0, pr2Vars = 0, pr2Methods = 0, pr2Classes = 0,
                pr2Comments = 0;

        for (int elementIndex = 0; elementIndex < reports.elements.size(); elementIndex++) {
            ElementCounter element = reports.elements.get(elementIndex);
            int counter = element.counter;

            // VERIFICAR NOMBRE DE ARCHIVO
            if (element.file.equals(filePath1)) {
                // ARCHIVO EN PROYECTO1
                if (element.proyectName.equals(series1)) {
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
            }

            // ARCHIVO EN PROYECTO 2
            if (element.file.equals(filePath2)) {
                if (element.proyectName.equals(series2)) {
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
        }

        // AGREGAR AL DATASET PROYECTO1
        dataset.addValue(pr1Vars, series1, "Variables");
        dataset.addValue(pr1Methods, series1, "Métodos");
        dataset.addValue(pr1Classes, series1, "Clases");
        dataset.addValue(pr1Comments, series1, "Comentarios");

        // AGREGAR AL DATASET PROYECTO2
        dataset.addValue(pr2Vars, series2, "Variables");
        dataset.addValue(pr2Methods, series2, "Métodos");
        dataset.addValue(pr2Classes, series2, "Clases");
        dataset.addValue(pr2Comments, series2, "Comentarios");

        return dataset;
    }

    @Override
    public void generateGraph(String name) {
        // DATASET
        CategoryDataset dataset = createDataset();

        // CREAR GRÁFICA
        JFreeChart chart = ChartFactory.createLineChart(title, "Proyectos", "Cantidad", dataset);

        // GUARDAR IMAGEN
        try {
            File fileStream = new File(name + "linechart_" + title + ".jpeg");
            ChartUtils.saveChartAsJPEG(fileStream, chart, 600, 400);
        } catch (IOException ex) {
            System.out.println(ex);
        }
    }
}
