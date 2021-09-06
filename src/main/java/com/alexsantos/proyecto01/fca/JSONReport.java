package com.alexsantos.proyecto01.fca;

import com.alexsantos.proyecto01.analyzer.comparator.Element;
import com.alexsantos.proyecto01.analyzer.comparator.FilePoints;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author alex
 */
public class JSONReport {

    // GLOBALES
    private HashMap<String, FilePoints> points;
    private ArrayList<String> paths;
    private double genPoints;

    /**
     * Constructor
     *
     * @param genPoints
     * @param elements
     */
    public JSONReport(ArrayList<String> paths, double genPoints, HashMap<String, FilePoints> points) {
        this.genPoints = genPoints;
        this.points = points;
        this.paths = paths;
    }

    /**
     * Generar tabla
     *
     * @param filePath
     * @return
     */
    public String getFilePointContent(String filePath) {
        String content = "";

        // AGREGAR ESPECIFICO
        FilePoints pathPoints = points.get(filePath);

        // PUNTOS DE CLASE
        for (Map.Entry<String, Element> entry : pathPoints.classPoints.entrySet()) {
            String key = entry.getKey();
            Element el = entry.getValue();

            content += "{\"archivo\" : \"" + filePath + "\",\n\"tipo\" : \"clase\",\n\"nombre\" : \"" + key + "\",\n\"puntaje\" : " + Double.toString(el.points) + "},";
        }

        // PUNTOS DE VARIABLE
        for (Map.Entry<String, Element> entry : pathPoints.varPoints.entrySet()) {
            String key = entry.getKey();
            Element el = entry.getValue();

            content += "{\"archivo\" : \"" + filePath + "\",\n\"tipo\" : \"variable\",\n\"nombre\" : \"" + key + "\",\n\"puntaje\" : " + Double.toString(el.points) + "},";
        }

        // PUNTOS DE METODOS
        for (Map.Entry<String, Element> entry : pathPoints.methodPoints.entrySet()) {
            String key = entry.getKey();
            Element el = entry.getValue();

            content += "{\"archivo\" : \"" + filePath + "\",\n\"tipo\" : \"metodo\",\n\"nombre\" : \"" + key + "\",\n\"puntaje\" : " + Double.toString(el.points) + "},";
        }

        // PUNTOS DE COMENTARIOS
        for (Map.Entry<String, Element> entry : pathPoints.commentPoints.entrySet()) {
            String key = entry.getKey();
            Element el = entry.getValue();

            content += "{\"archivo\" : \"" + filePath + "\",\n\"tipo\" : \"comentario\",\n\"nombre\" : \"" + key.replaceAll("[^a-zA-Z0-9]", " ") + "\",\n\"puntaje\" : " + Double.toString(el.points) + "},";
        }

        return content;
    }

    /**
     * Generar archivo
     */
    public void getJSONFile() {
        try {
            FileWriter writer = new FileWriter("./report/data.json");
            String content = "{ \"PuntajeGeneral\":" + Double.toString(genPoints) + ",\n\"PuntajesEspecificos\": [\n";

            // ANALIZAR PARA TODAS LOS ARCHIVOS DE UN PROYECTO
            for (int pathIndex = 0; pathIndex < paths.size(); pathIndex++) {
                content += getFilePointContent(paths.get(pathIndex));
            }

            content = content.substring(0, content.length() - 1);
            content += "]}";

            writer.write(content);
            writer.close();
        } catch (IOException e) {
            System.out.println("Error en JSON");
            e.printStackTrace();
        }
    }
}
