package com.alexsantos.proyecto01;

import java.io.IOException;
import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;

/**
 * JavaFX App
 */
public class App extends Application {

    private static Scene scene;

    @Override
    /**
     * Iniciar vista inicial
     */
    public void start(Stage stage) throws IOException {
        scene = new Scene(loadFXML("primary"), 1000, 400);
        stage.setResizable(false);
        stage.setScene(scene);
        stage.show();
        stage.setTitle("FIUSAC Copy Analiyzer");
        stage.getIcons().add(new Image(App.class.getResourceAsStream("assets/icon.png")));
    }

    /**
     * Cambiar vistas
     *
     * @param fxml
     * @throws IOException
     */
    public static void setRoot(String fxml) throws IOException {
        scene.setRoot(loadFXML(fxml));
    }

    /**
     * Cargar archivo FXML
     *
     * @param fxml
     * @return
     * @throws IOException
     */
    private static Parent loadFXML(String fxml) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(App.class.getResource("views/" + fxml + ".fxml"));
        return fxmlLoader.load();
    }

    /**
     * Iniciar
     *
     * @param args
     */
    public static void main(String[] args) {
        launch();
        // ANALYZADOR
        /*try {
            File file = new File("/home/alex/Documentos/USAC/Compi1/proyecto01/proyecto01/src/test/javascript/input.js");
            JSParser parser = new JSParser(new JSScanner(new BufferedReader(new FileReader(file))));
            parser.parse();
        } catch (Exception ex) {
            System.err.println("Error: " + ex.getMessage());
        }*/
    }
}
