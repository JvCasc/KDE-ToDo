# Project Map

## Purpose
Widget de to-do list minimalista para a área de trabalho do KDE Plasma 6.7.3 (Fedora), inspirado no widget de lembretes do iPhone.

## Requirements
- Criar tarefa
- ~~Editar tarefa~~ (removido pelo learner no passo 8; corrigir = concluir e recriar)
- Marcar como feita → a tarefa é apagada (sem histórico)
- Fica na área de trabalho (painel: futuro)
- Tarefas sobrevivem a reboot
- Fora da v1: data limite, prioridade, cor, categoria

## Components (implementados — passo 1)
- package/metadata.json — identidade do plugin (com.jvcasc.kdetodo, Plasma 6)
- package/contents/config/main.xml — chaves tasks (String "[]") e nextId (Int 1)
- package/contents/ui/main.qml — PlasmoidItem; ListModel em memória; funções addTask/removeTask/save (editTask removida no passo 8); UI: "+" no hover, linhas com bolinha + texto, campo de nova tarefa no footer da ListView (passo 2)

- Visual (passo 3): lista vazia sem mensagem. Fundo (passo 7): Rectangle próprio opaco, raio 18, borda 1 px, margem 16; tema claro/escuro (chave darkMode, padrão escuro) com cores do artifact, aplicado sobrescrevendo Kirigami.Theme

- package/contents/config/config.qml + contents/ui/configGeneral.qml — página "Geral" de Configurar..., campo título (cfg_title); chave title (String "") no main.xml
- Título: Label à esquerda do "+", vazio por padrão
- Ícone (passo 11): chave icon (String, "" = nenhum); SVGs Lucide em contents/icons; Kirigami.Icon isMask na cor de destaque, à esquerda do título; aparece mesmo sem título
- Cor de destaque (passo 5): chave accentColor (Color, padrão #f97316), paleta fixa de 6 cores (rosa e vermelho no passo 16) em configGeneral.qml; concluir = texto riscado + bolinha na cor de destaque com check + fade 2 s
- Fonte (passo 6): Inter embutida em contents/fonts (Medium p/ tarefas e campos, 1,15× fonte do Plasma; ExtraBold p/ título, 1,6×), carregada por FontLoader; LICENSE.txt OFL junto

## Main Flow
config(tasks texto) --JSON.parse--> taskModel (ListModel, memória) --> ListView   [implementado]
ação do usuário --> altera taskModel --save(): JSON.stringify--> config (tasks, nextId)   [implementado]
Título: Configurar... → cfg_title → config (title) → Heading no topo   [implementado]
Criar: hover → "+" → campo com caixa própria (sem molduras de hover/foco; padding fixo 6), texto alinhado às tarefas, focado → Enter (vazio só fecha) [implementado]
Topo: ícone + título + linha fina (some sem título e sem ícone) + "+" (hover = mesma caixa do campo; caixa própria nos dois modos: claro branca/#e4e4e7, escuro #141618/#424446, raio 6, sem depender do tema do KDE) [implementado]
Concluir: bolinha → preenche + fade 2 s → remove (clicar de novo desfaz) [implementado]

## Data and Trust Boundaries
Armazenamento (confirmado pelo learner; leitura e escrita implementadas): plasmoid.configuration do Plasma (~/.config/plasma-org.kde.plasma.desktop-appletsrc). Ligado à instância do widget. Remover o widget apaga as tarefas — comportamento desejado pelo learner, não é problema.

## Build and Deployment
Pasta do projeto: /home/JvCasc/kde-todo (sem Git).
- Instalar: kpackagetool6 -t Plasma/Applet -i package
- Atualizar: kpackagetool6 -t Plasma/Applet -u package
- Instalado em ~/.local/share/plasma/plasmoids/com.jvcasc.kdetodo/
- Teste isolado (opcional): plasmoidviewer -a package (pacote plasma-sdk, não instalado)
- Logs do QML (console.*, erros) do plasmawindowed/plasmashell: journalctl --user

## Unknowns
- Widget no painel (fora da v1)

## Modelo de dados (confirmado pelo learner, implementado)
- Tarefa: { id, texto } — sem status (concluída = apagada)
- id: contador salvo na config, só aumenta (escolha do learner)
- Lista: array JSON serializado como texto na config; lido ao abrir, sobrescrito a cada ação
