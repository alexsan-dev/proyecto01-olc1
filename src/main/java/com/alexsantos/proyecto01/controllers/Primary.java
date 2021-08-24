package com.alexsantos.proyecto01.controllers;

import com.jfoenix.controls.JFXTabPane;
import java.io.*;
import javafx.fxml.FXML;
import javafx.scene.control.Tab;
import javafx.scene.control.TextArea;
import javafx.scene.layout.AnchorPane;
import javafx.scene.text.Font;
import javafx.stage.FileChooser;
import javafx.stage.Stage;

public class Primary {

    private int selectedEditor = 0;

    @FXML
    private JFXTabPane tabs;

    private String readFile(File file) {
        // BUFFER
        StringBuilder stringBuffer = new StringBuilder();
        BufferedReader bufferedReader = null;

        try {
            // leer
            bufferedReader = new BufferedReader(new FileReader(file));
            String text;
            while ((text = bufferedReader.readLine()) != null) {
                stringBuffer.append(text + "\n");
            }
        } catch (Exception ex) {
            System.out.println(ex);
        } finally {
            try {
                // CERRAR BUFFER
                bufferedReader.close();
            } catch (Exception ex) {
                System.out.println(ex);
            }
        }

        // CONTENIDO
        return stringBuffer.toString();
    }

    @FXML
    private void openFile() {
        // ABRIR
        FileChooser chooser = new FileChooser();
        chooser.setTitle("Abrir FCA");

        // GUARDAR
        File file = chooser.showOpenDialog(new Stage());

        // ASIGNAR A EDITOR ACTUAL
        AnchorPane anchorPane = (AnchorPane) tabs.getTabs().get(selectedEditor).getContent();
        TextArea textArea = (TextArea) anchorPane.getChildren().get(0);
        textArea.setText(readFile(file));
    }

    @FXML
    private void closeEditorTab() {
        if (tabs.getTabs().size() > 1) {
            tabs.getTabs().remove(selectedEditor);
        }
    }

    @FXML
    private void addEditorTab() {
        Tab newTab = new Tab();
        int size = tabs.getTabs().size();
        newTab.setText("Editor");

        AnchorPane anchorPane = new AnchorPane();
        anchorPane.setMinHeight(0);
        anchorPane.setMinWidth(0);
        anchorPane.setPrefHeight(219.0);
        anchorPane.setPrefWidth(650.0);

        TextArea textArea = new TextArea();
        textArea.setMaxHeight(1.7976931348623157E308);
        textArea.setPrefHeight(245.0);
        textArea.setPrefWidth(610.0);
        textArea.setPromptText("Escribe tu codigo aqui.");
        textArea.setStyle("-fx-text-fill: #fff;");
        textArea.setFont(Font.font("Fira Code SemiBold", 13));
        textArea.setWrapText(true);

        newTab.setOnSelectionChanged(e -> {
            selectedEditor = tabs.getSelectionModel().getSelectedIndex();
        });

        anchorPane.getChildren().add(textArea);
        newTab.setContent(anchorPane);
        tabs.getTabs().add(newTab);
        tabs.getSelectionModel().selectLast();
        selectedEditor = size;
    }

    public void initialize() {
        addEditorTab();
    }

    public static void print(Object value) {
        System.out.println(value);
    }
}
