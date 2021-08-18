module com.alexsantos.proyecto01 {
    requires javafx.controls;
    requires javafx.fxml;

    opens com.alexsantos.proyecto01 to javafx.fxml;
    opens com.alexsantos.proyecto01.controllers to javafx.fxml;
    exports com.alexsantos.proyecto01;
    exports com.alexsantos.proyecto01.controllers;
}
