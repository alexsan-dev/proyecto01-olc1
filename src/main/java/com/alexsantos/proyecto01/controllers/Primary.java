package com.alexsantos.proyecto01.controllers;

import com.alexsantos.proyecto01.App;
import java.io.IOException;
import javafx.fxml.FXML;

public class Primary {
    @FXML
    private void switchToSecondary() throws IOException {
        App.setRoot("secondary");
    }
}
