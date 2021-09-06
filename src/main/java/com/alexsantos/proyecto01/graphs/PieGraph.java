package com.alexsantos.proyecto01.graphs;

import java.io.File;
import java.io.IOException;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtils;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.general.PieDataset;

/**
 *
 * @author alex
 */
public class PieGraph extends Graph {

    public PieGraph() {
    }

    /**
     * Crear dataset de freechart
     *
     * @return
     */
    private PieDataset createDataset() {
        DefaultPieDataset dataset = new DefaultPieDataset();

        // AGREGAR DATOS
        if (values.size() > 0 && xaxis.size() >= values.size()) {
            for (int i = 0; i < values.size(); i++) {
                dataset.setValue(xaxis.get(i) + " = " + values.get(i), values.get(i));
            }
        } else {
            System.err.println("\nError faltan valores en el eje X en grafica de pie " + title + "\n");
        }

        return dataset;
    }

    /**
     * Generar imagen de gráfica
     *
     * @param path
     */
    @Override
    public void generateGraph(String path) {
        // DATASET
        PieDataset dataset = createDataset();

        // CREAR GRÁFICA
        JFreeChart chart = ChartFactory.createPieChart(title, dataset, true, true, false);

        // GUARDAR IMAGEN
        try {
            File file = new File(path + "piechart_" + title + ".jpeg");
            ChartUtils.saveChartAsJPEG(file, chart, 600, 400);
        } catch (IOException ex) {
            System.err.println("\n" + ex + "\n");
        }
    }
}
