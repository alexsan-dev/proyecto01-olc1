package com.alexsantos.proyecto01;

import javafx.application.Application;
import javafx.scene.image.Image;
import javafx.fxml.FXMLLoader;
import java.io.IOException;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

/**
 * JavaFX App
 */
public class App extends Application {

    private static Scene scene;

    @Override
    /**
     * Inicia la aplicación FXML
     * 
     * @param stage
     */
    public void start(Stage stage) throws IOException {
        scene = new Scene(loadFXML("primary"), 1000, 400);
        stage.setResizable(false);
        stage.setScene(scene);
        stage.show();
        stage.setTitle("FIUSAC Copy Analyzer");
        stage.getIcons().add(new Image(App.class.getResourceAsStream("assets/icon.png")));
    }

    /**
     * Cambiar archivo FXML
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
    }
}
