import QtQuick
import org.kde.plasma.configuration

// Páginas da janela "Configurar..." do widget
ConfigModel {
    ConfigCategory {
        name: "General"
        icon: "configure"
        source: "configGeneral.qml"
    }
}
