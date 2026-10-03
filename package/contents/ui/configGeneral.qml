import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    // Prefixo cfg_ liga esta propriedade à chave "title" do main.xml:
    // o Plasma preenche ao abrir e salva ao clicar em Aplicar/OK
    property alias cfg_title: titleField.text
    // Mesma ideia para a cor de destaque (chave "accentColor")
    property color cfg_accentColor
    // Tema do widget (chave "darkMode")
    property bool cfg_darkMode
    // Ícone ao lado do título (chave "icon"); "" = nenhum
    property string cfg_icon

    // Paleta fixa; trocar as cores é só editar esta lista
    readonly property var colorOptions: ["#f97316", "#3b82f6", "#22c55e", "#a855f7", "#ec4899", "#ef4444"]
    // Ícones de contents/icons (nome do arquivo sem ".svg"); "" = nenhum
    readonly property var iconOptions: ["", "flame", "zap", "star", "heart", "target", "book-open"]

    Kirigami.FormLayout {
        QQC2.TextField {
            id: titleField
            Kirigami.FormData.label: "Título:"
            placeholderText: "Sem título"
        }

        QQC2.RadioButton {
            Kirigami.FormData.label: "Tema:"
            text: "Escuro"
            checked: cfg_darkMode
            onToggled: cfg_darkMode = true
        }
        QQC2.RadioButton {
            text: "Claro"
            checked: !cfg_darkMode
            onToggled: cfg_darkMode = false
        }

        RowLayout {
            Kirigami.FormData.label: "Cor de destaque:"
            spacing: Kirigami.Units.smallSpacing

            Repeater {
                model: colorOptions

                // Bolinha clicável; a selecionada ganha um anel em volta
                Rectangle {
                    required property string modelData
                    readonly property bool selected: Qt.colorEqual(cfg_accentColor, modelData)

                    implicitWidth: Kirigami.Units.iconSizes.medium
                    implicitHeight: implicitWidth
                    radius: width / 2
                    color: "transparent"
                    border.width: 2
                    border.color: selected ? Kirigami.Theme.textColor : "transparent"

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 4
                        radius: width / 2
                        color: parent.modelData
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: cfg_accentColor = parent.modelData
                    }
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: "Ícone:"
            spacing: Kirigami.Units.smallSpacing

            Repeater {
                model: iconOptions

                // Quadrado clicável com o ícone na cor de destaque; o selecionado ganha um anel
                Rectangle {
                    required property string modelData
                    readonly property bool selected: cfg_icon === modelData

                    implicitWidth: Kirigami.Units.iconSizes.medium + 8
                    implicitHeight: implicitWidth
                    radius: 6
                    color: "transparent"
                    border.width: 2
                    border.color: selected ? Kirigami.Theme.textColor : "transparent"

                    Kirigami.Icon {
                        anchors.centerIn: parent
                        width: Kirigami.Units.iconSizes.smallMedium
                        height: width
                        // "nenhum": ícone do sistema de "proibido", na cor do texto
                        source: parent.modelData === "" ? "edit-none" : Qt.resolvedUrl("../icons/" + parent.modelData + ".svg")
                        isMask: true
                        color: parent.modelData === "" ? Kirigami.Theme.disabledTextColor : cfg_accentColor
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: cfg_icon = parent.modelData
                    }
                }
            }
        }
    }
}
