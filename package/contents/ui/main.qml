import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    // Lista em memória. ListModel (em vez de um array JS) para que adicionar
    // ou remover uma tarefa não recrie as outras linhas da lista,
    // o que reiniciaria animações de conclusão em andamento.
    ListModel { id: taskModel }

    // true enquanto o campo de nova tarefa está aberto
    property bool adding: false

    // Fonte Inter embutida no pacote (contents/fonts), igual em qualquer máquina.
    // Os dois arquivos registram a mesma família "Inter"; o peso escolhe o arquivo.
    FontLoader { id: interMedium; source: "../fonts/Inter-Medium.ttf" }
    FontLoader { id: interExtraBold; source: "../fonts/Inter-ExtraBold.ttf" }

    // Tamanhos relativos à fonte do Plasma: acompanham se o usuário mudar a fonte do sistema
    readonly property real taskPointSize: Kirigami.Theme.defaultFont.pointSize * 1.15
    readonly property real titlePointSize: Kirigami.Theme.defaultFont.pointSize * 1.6

    // Na área de trabalho, mostra o widget completo em vez de um ícone
    preferredRepresentation: fullRepresentation

    // Sem o fundo do tema do Plasma: o widget desenha o próprio fundo (ver fullRepresentation)
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    // Cores do widget (as do artifact), escolhidas pelo tema claro/escuro da config
    readonly property bool dark: Plasmoid.configuration.darkMode
    readonly property color bgColor: dark ? "#17171a" : "#ffffff"
    readonly property color borderColor: dark ? "#2c2c32" : "#e4e4e7"
    readonly property color textColor: dark ? "#f2f2f3" : "#18181b"
    readonly property color mutedColor: dark ? "#a3a3ab" : "#55555e"
    readonly property color ringColor: dark ? "#5a5a63" : "#a1a1aa"
    // Caixa do campo de nova tarefa e do hover do "+". Cores fixas, não as do tema
    // do KDE: o escuro repete o tom que o Breeze Dark dava (fundo e borda "Frame")
    readonly property color boxColor: dark ? "#141618" : bgColor
    readonly property color boxBorderColor: dark ? "#424446" : borderColor

    // Ao abrir: texto JSON da config -> lista em memória
    Component.onCompleted: {
        JSON.parse(Plasmoid.configuration.tasks).forEach(function (t) {
            taskModel.append({ taskId: t.id, text: t.text })
        })
    }

    // Lista em memória -> texto JSON na config (sobrescreve a lista inteira)
    function save() {
        var list = []
        for (var i = 0; i < taskModel.count; i++) {
            var t = taskModel.get(i)
            list.push({ id: t.taskId, text: t.text })
        }
        Plasmoid.configuration.tasks = JSON.stringify(list)
    }

    function indexOfId(id) {
        for (var i = 0; i < taskModel.count; i++) {
            if (taskModel.get(i).taskId === id) {
                return i
            }
        }
        return -1
    }

    function addTask(text) {
        var t = text.trim()
        if (t === "") {
            return
        }
        taskModel.append({ taskId: Plasmoid.configuration.nextId, text: t })
        Plasmoid.configuration.nextId += 1
        save()
    }

    function removeTask(id) {
        var i = indexOfId(id)
        if (i !== -1) {
            taskModel.remove(i)
            save()
        }
    }

    fullRepresentation: Item {
        id: full
        implicitWidth: Kirigami.Units.gridUnit * 14
        implicitHeight: Kirigami.Units.gridUnit * 12

        // Sobrescreve as cores do Kirigami para tudo dentro do widget:
        // título, texto das tarefas e o "+" herdam daqui em vez do tema do Plasma
        Kirigami.Theme.inherit: false
        Kirigami.Theme.textColor: root.textColor
        Kirigami.Theme.disabledTextColor: root.mutedColor
        Kirigami.Theme.backgroundColor: root.bgColor
        // Hover e foco na cor do texto, em vez do azul do sistema (ex.: borda do "+")
        Kirigami.Theme.hoverColor: root.textColor
        Kirigami.Theme.focusColor: root.textColor

        // Fundo próprio: opaco, arredondado, com borda fina
        Rectangle {
            anchors.fill: parent
            radius: 18
            color: root.bgColor
            border.width: 1
            border.color: root.borderColor
        }

        HoverHandler { id: hover }

        // Clique em área vazia do widget tira o foco dos campos ("clique fora")
        MouseArea {
            anchors.fill: parent
            onClicked: full.forceActiveFocus()
        }

        ColumnLayout {
            anchors.fill: parent
            // Margem interna (antes vinha do fundo do tema)
            anchors.margins: 16
            spacing: Kirigami.Units.smallSpacing

            // Linha do topo: ícone + título à esquerda, "+" à direita (visível só com o mouse em cima)
            RowLayout {
                Layout.fillWidth: true
                spacing: 3

                // Ícone escolhido em Configurar..., na cor de destaque; aparece mesmo sem título
                Kirigami.Icon {
                    visible: Plasmoid.configuration.icon !== ""
                    // Do tamanho da letra do título (≈ 20 px na fonte padrão, como no artifact)
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    transform: Translate { y: -1 }
                    source: visible ? Qt.resolvedUrl("../icons/" + Plasmoid.configuration.icon + ".svg") : ""
                    isMask: true
                    color: Plasmoid.configuration.accentColor
                }

                // Vazio: o texto some, mas continua ocupando o espaço à esquerda do "+"
                PlasmaComponents.Label {
                    id: titleLabel
                    Layout.fillWidth: true
                    text: Plasmoid.configuration.title
                    elide: Text.ElideRight
                    font.family: interExtraBold.name
                    font.weight: Font.ExtraBold
                    font.pointSize: root.titlePointSize

                    // Medidas da fonte do título, usadas para dimensionar o ícone
                    FontMetrics { id: titleMetrics; font: titleLabel.font }
                }

                PlasmaComponents.ToolButton {
                    id: addButton
                    icon.name: "list-add"
                    // Padding fixo: sem o fundo do tema ele cairia para outro valor
                    // (4 px = o que o tema dava; botão continua 30×30)
                    padding: 4
                    // No hover, a mesma caixa do campo de nova tarefa (borda fina,
                    // cantos arredondados) no lugar da moldura azul do tema
                    background: Rectangle {
                        radius: 6
                        color: root.boxColor
                        border.width: 1
                        border.color: root.boxBorderColor
                        opacity: addButton.hovered ? 1 : 0
                        Behavior on opacity { NumberAnimation { duration: Kirigami.Units.shortDuration } }
                    }
                    opacity: hover.hovered ? 1 : 0
                    enabled: hover.hovered
                    onClicked: root.adding = true
                    Behavior on opacity { NumberAnimation { duration: Kirigami.Units.shortDuration } }
                }
            }

            // Linha fina separando o topo das tarefas; some quando não há título nem ícone
            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 8
                Layout.bottomMargin: 8
                implicitHeight: 1
                color: root.borderColor
                visible: Plasmoid.configuration.title !== "" || Plasmoid.configuration.icon !== ""
            }

            ListView {
                id: list
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 12
                model: taskModel

                delegate: Item {
                    id: row
                    width: ListView.view.width
                    height: rowLayout.implicitHeight

                    // Copiados do modelo para continuarem acessíveis durante a animação
                    property int taskId: model.taskId
                    property string taskText: model.text
                    property bool done: false

                    // Clicar na bolinha inicia o sumiço; clicar de novo durante a animação desfaz
                    onDoneChanged: {
                        if (done) {
                            fade.start()
                        } else {
                            fade.stop()
                            row.opacity = 1
                        }
                    }

                    // A remoção de verdade só acontece no fim da animação
                    SequentialAnimation {
                        id: fade
                        NumberAnimation {
                            target: row
                            property: "opacity"
                            to: 0
                            duration: 2000
                        }
                        ScriptAction { script: root.removeTask(row.taskId) }
                    }

                    RowLayout {
                        id: rowLayout
                        width: parent.width
                        spacing: 6

                        // Bolinha: vazada; preenchida quando concluída
                        Rectangle {
                            Layout.alignment: Qt.AlignVCenter
                            implicitWidth: Kirigami.Units.iconSizes.small
                            implicitHeight: implicitWidth
                            radius: width / 2
                            border.width: 2
                            border.color: row.done ? Plasmoid.configuration.accentColor : root.ringColor
                            color: row.done ? Plasmoid.configuration.accentColor : "transparent"
                            Layout.leftMargin: 6

                            // Check no centro, quase preto para contrastar com a cor de destaque
                            Kirigami.Icon {
                                anchors.centerIn: parent
                                width: parent.width * 0.7
                                height: width
                                visible: row.done
                                source: "checkmark-symbolic"
                                isMask: true
                                color: "#17171a"
                            }

                            MouseArea {
                                anchors.fill: parent
                                // área de clique um pouco maior que o círculo
                                anchors.margins: -Kirigami.Units.smallSpacing
                                onClicked: row.done = !row.done
                            }
                        }

                        PlasmaComponents.Label {
                            Layout.fillWidth: true
                            text: row.taskText
                            wrapMode: Text.Wrap
                            // Concluída: riscada e com a cor apagada do tema
                            font.strikeout: row.done
                            color: row.done ? Kirigami.Theme.disabledTextColor : Kirigami.Theme.textColor
                            font.family: interMedium.name
                            font.weight: Font.Medium
                            font.pointSize: root.taskPointSize
                        }
                    }
                }

                // Campo de nova tarefa, logo abaixo da última tarefa.
                // O spacing da lista não vale para o footer: este Item reserva
                // a mesma folga acima do campo (e some junto com ele).
                footer: Item {
                    width: list.width
                    height: newTaskField.visible ? list.spacing + newTaskField.implicitHeight : 0

                    PlasmaComponents.TextField {
                        id: newTaskField
                        y: list.spacing
                        width: parent.width
                        // Texto começa na coluna do texto das tarefas (margem + bolinha + espaço)
                        leftPadding: 6 + Kirigami.Units.iconSizes.small + 6
                        placeholderTextColor: root.mutedColor
                        // Espaçamento fixo (6 px = o que a caixa do tema dava), igual em qualquer tema
                        topPadding: 6
                        bottomPadding: 6
                        rightPadding: 6
                        // Cor do widget em vez da do sistema; o cursor "|" usa a mesma cor
                        color: root.textColor
                        // Caixa própria no lugar da do tema, que vinha com as cores do
                        // sistema e molduras de hover e foco (azuis)
                        background: Rectangle {
                            radius: 6
                            color: root.boxColor
                            border.width: 1
                            border.color: root.boxBorderColor
                        }
                        visible: root.adding
                        placeholderText: "New task"
                        font.family: interMedium.name
                        font.weight: Font.Medium
                        font.pointSize: root.taskPointSize
                        onVisibleChanged: {
                            if (visible) {
                                text = ""
                                forceActiveFocus()
                            }
                        }
                        // Vazio: só fecha. Com texto: adiciona e fecha.
                        onEditingFinished: {
                            if (root.adding) {
                                root.adding = false
                                root.addTask(text)
                            }
                        }
                    }
                }
            }
        }
    }
}
