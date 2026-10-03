# Learning Progress

## Requisitos da v1 (definidos pelo learner)
- Introduced: conceito de plasmoid (pasta + metadata.json + QML/JS, instalado via kpackagetool6) — explicado pelo Claude
- Learner definiu escopo e não-escopo da v1 (ver project-map.md)
- Learner sugeriu persistência em "arquivo simples numa pasta", sem saber o mecanismo

## Persistência
- Introduced (Claude explicou): QML não escreve arquivos arbitrários; opções plasmoid.configuration / LocalStorage / arquivo próprio via ponte
- Learner escolheu plasmoid.configuration — razão: lista simples, não precisa de lugar complexo
- Learner decidiu: tarefa concluída é apagada (não vê valor em histórico)
- Learner decidiu (2026-10-02): remover o widget apagar as tarefas é desejado (prefere assim); não tratar como problema

## Representação dos dados
- Learner propôs: tarefa = {id, texto} em JSON; id para identificar tarefa a editar/apagar
- Learner removeu campo status após Claude apontar contradição com "apagar ao concluir"
- Introduced (Claude explicou): serialização (JSON.stringify/parse); lista em memória vs. cópia na config (sobrescreve inteira, não "anexa")
- Demonstrated understanding: learner raciocinou sozinho que posição na lista não serve como id (apagar a 3ª de 4 faz a 4ª mudar de posição → ids precisariam ser renumerados)
- Introduced (Claude explicou): limite de inteiros em JS não é problema prático; contador em memória se perde no reboot
- Learner escolheu contador salvo na config — razão: considera o mais simples, aceita não ser o mais elegante

## Passo 1 — esqueleto (implementado)
- Learner aprovou escopo do passo 1 (incl. additions: id com.jvcasc.kdetodo, defaults "[]" e 1)
- Instalado com kpackagetool6 com sucesso; learner confirmou que apareceu no desktop

## Passo 2 — criar/editar/concluir (implementado)
- Learner propôs: "+" no hover → campo focado → Enter adiciona; duplo clique edita, Enter/clique fora salva; bolinha vazada preenche e tarefa some em animação
- Casos de borda decididos pelo learner: sem cancelamento; criar vazio só fecha; editar para vazio apaga; campo fecha após criar; clicar na bolinha durante a animação desfaz (como no iPhone)
- Introduced (Claude explicou): editingFinished dispara com Enter e com perda de foco; tarefas pertencem à instância (learner viu na prática ao remover o widget)
- Learner aprovou additions: remoção só ao fim da animação (2 s = janela de desfazer); "+" no canto superior direito; trim; painel fora da v1
- Detalhe de implementação (Claude, explicado no report): ListModel em memória em vez de array JS, para não recriar linhas/reiniciar animações; formato salvo na config não mudou
- Passo 1 verificado pelo learner (apareceu no desktop); instância extra no painel foi adicionada por engano (containment formfactor=2), não pelo código
- Verificação: kpackagetool6 -u ok; plasmawindowed carregou 6 s sem erros de QML; learner testou no desktop e reportou tudo funcionando

## Passo 3 — visual (implementado em parte)
- Learner decidiu: lista vazia fica vazia; "+" continua no canto superior direito; espaçamentos, fonte e margens ele ajusta manualmente
- Introduced (Claude explicou): onde ajustar no main.qml (Layout.leftMargin, spacing, font.pointSize/family, implicitWidth/Height); Kirigami.Units vs. pixels fixos
- Introduced (Claude explicou): blur do KWin é por janela; widgets do desktop ficam na mesma janela do wallpaper → sem desfoque real; opções: translúcido do tema / Rectangle próprio / blur simulado
- Learner escolheu fundo translúcido do Plasma "por enquanto"; quer testar as outras opções no futuro
- Implementado: Plasmoid.backgroundHints = PlasmaCore.Types.TranslucentBackground; kpackagetool6 -u ok; plasmawindowed carregou 6 s sem erros de QML do widget; learner ainda não conferiu no desktop

## Passo 4 — título configurável (implementado)
- Introduced (Claude explicou): "Configurar..." = main.xml + config/config.qml + ui/configGeneral.qml; prefixo cfg_ liga campo à chave; usuário escreve, widget reage
- Introduced (Claude explicou): package/ é cópia de trabalho; Plasma lê a cópia instalada → precisa kpackagetool6 -u antes do restart (learner editava sem reinstalar)
- Learner decidiu: título na linha do "+", à esquerda; começa vazio; vazio = só tarefas, como antes; negrito e maior que as tarefas
- Learner aprovou additions: título longo cortado com "…"; Kirigami.Heading level 3; página "Geral" com ícone configure
- Verificação: kpackagetool6 -u ok; plasmawindowed 6 s sem erros (não carrega a página de config); módulos kcmutils e plasma.configuration presentes; janela de config não testada pelo Claude

## Passo 5 — estilo do artifact "LockIn A · Minimal" (implementado)
- Learner trouxe artifact próprio (claude.ai Design); gostou de: texto riscado ao concluir, bolinha preenchida com check, barra "X/Y feitas"; manteve o próprio "+" (não copiar o campo do artifact)
- Learner decidiu: risco + fade juntos (fade 2 s e desfazer mantidos)
- Introduced (Claude apontou): barra de feitas conflita com "concluída = apagada, sem histórico" (não há registro de feitas)
- Learner decidiu: sem barra/contagem; modelo de dados inalterado
- Learner decidiu: cor de destaque fixa (não a do tema), escolhida pelo usuário em paleta fixa nas configurações; padrão laranja; delegou ao Claude as cores da paleta (vai repensar no futuro)
- Learner aprovou additions: paleta #f97316/#3b82f6/#22c55e/#a855f7; entrada accentColor (Color) no main.xml; bolinhas com anel na selecionada; check #17171a; texto concluído riscado + disabledTextColor; borda da bolinha vazia segue o tema
- Verificação: kpackagetool6 -u ok; plasmawindowed 6 s sem erros de QML do widget; página de config não testada pelo Claude (sem qmllint)

## Passo 6 — fonte e tamanhos (implementado)
- Learner pediu: tarefas maiores, título maior e mais grosso como no artifact, fonte "tipo Apple" escolhida pelo Claude
- Introduced (Claude explicou): font.family "Inter" não estava instalada → Qt caía na Noto Sans sem avisar; SF Pro não pode ser usada fora da Apple; fonte do sistema vs. embutida no pacote (FontLoader)
- Claude escolheu Inter (a pedido); learner decidiu embutir a fonte no package (não explicou o motivo)
- Learner aprovou additions: Inter-Medium/ExtraBold + LICENSE.txt (OFL) em contents/fonts; tarefas 1,15× e título 1,6× a fonte do Plasma (relativos); campos de texto com a mesma fonte das tarefas
- Verificação: kpackagetool6 -u ok (fontes presentes na cópia instalada); plasmawindowed 6 s sem erros; carregamento do FontLoader não confirmado isoladamente (sem runtime qml)

## Passo 7 — fundo próprio opaco e arredondado (implementado)
- Learner pediu: bordas mais arredondadas e fundo opaco ("fosco") como no artifact, no lugar do translúcido do tema
- Introduced (Claude explicou): raio do fundo do tema vem do SVG do Plasma (não ajustável) → NoBackground + Rectangle próprio; cores fixas exigem texto com cores da mesma origem
- Learner decidiu: usuário escolhe claro/escuro em Configurar...; raio 18 px
- Learner aprovou additions: padrão escuro; cores claro/escuro do artifact; borda 1 px; chave darkMode (Bool); RadioButtons Escuro/Claro; sobrescrever Kirigami.Theme no widget; margem interna 16 px
- Verificação: kpackagetool6 -u ok; plasmawindowed 6 s sem erros; visual não conferido pelo Claude (captura pegou outra janela; descartada); campos de texto talvez mantenham o visual do sistema — learner deve conferir

## Passo 8 — "+" sem azul, campo sem caixa, linha sob o título, sem edição (implementado)
- Learner pediu: borda de hover do "+" na cor das letras; campo de nova tarefa sem borda; linha fina cinza separando título e tarefas (mais espaço, mais elegante)
- Introduced (Claude explicou): azul = hoverColor/focusColor do tema, não sobrescritos no passo 7; campo tem caixa própria do tema além do foco
- Learner decidiu: remover a edição de tarefas ("não tão útil") — muda requisito da v1; tirar a caixa inteira do campo; linha some quando não há título
- Learner aprovou additions: hoverColor/focusColor = cor do texto; linha na cor da borda, 1 px, 8 px acima/abaixo; texto do campo alinhado ao texto das tarefas; placeholder na cor apagada
- Verificação: kpackagetool6 -u ok; plasmawindowed 6 s sem erros; visual não conferido pelo Claude

## Passo 9 — caixa sem borda no campo (implementado)
- Learner revisou passo 8: quer a caixa de volta no campo de nova tarefa, só sem borda
- Introduced (Claude explicou): caixa do tema tem a borda no mesmo SVG → desenhar caixa própria
- Learner aprovou additions: surface #232328/#f4f4f5; raio 10; largura toda com texto alinhado às tarefas; sem contorno de foco
- Verificação: kpackagetool6 -u ok; plasmawindowed 6 s sem erros; visual não conferido pelo Claude

## Passo 10 — caixa do tema de volta, foco na cor do texto (implementado)
- Learner revisou passo 9: volta a caixa original do tema, com borda; a borda de foco deve ser branca (cor das letras) em vez de azul
- Implementado: removida a caixa própria e surfaceColor; o foco do lineedit.svgz do tema usa ColorScheme-ViewFocus = focusColor, já sobrescrito no passo 8
- Verificação: kpackagetool6 -u ok; plasmawindowed 6 s sem erros; cor do contorno não conferida pelo Claude

## Passo 11 — ícone ao lado do título (implementado)
- Inspirado no fogo do artifact. Introduced (Claude explicou): ícone do tema do sistema vs. SVG embutido; Kirigami.Icon isMask pinta numa cor só
- Learner decidiu: SVG embutido no pacote; opção "nenhum"; cor de destaque; salvar o nome do ícone; sem título o ícone aparece sozinho no topo; delegou ao Claude a escolha dos ícones (estilo traço como o fogo)
- Learner aprovou additions: flame (desenho do artifact), zap, star, heart, target, book-open (Lucide, ISC, LICENSE.txt em contents/icons); chave icon (String, "" = nenhum, padrão ""); fileira "Ícone:" na página Geral com anel no selecionado; tamanho = ascent da fonte do título, 8 px de espaço; linha fina aparece com título ou ícone
- Verificação: kpackagetool6 -u ok (ícones na cópia instalada); plasmawindowed 6 s sem erros, com e sem icon=flame na config; visual e página de config não conferidos pelo Claude

## Ajustes manuais e passo 12 (2026-10-03)
- Learner ajustou sozinho: ícone fixo em 30 px e subido (Claude explicou caixa do Label inclui descendentes; opções transform Translate vs. Layout.bottomMargin); spacing da lista = 12 (Claude apontou onde ficam os spacings)
- Introduced (Claude explicou): spacing do ListView não se aplica ao footer
- Passo 12 (implementado, learner aprovou): footer = Item que reserva folga de list.spacing acima do TextField; altura 0 com campo fechado. Verificação: kpackagetool6 -u ok; plasmawindowed 6 s sem erros; visual não conferido pelo Claude

## Passo 13 — molduras cinza no campo e no "+" (implementado, 2026-10-03)
- Retomada da decisão pendente do contorno azul. Introduced (Claude explicou): caixa = background SVG com moldura de foco; padding vem das margens da caixa; fonte independe da caixa; cor definida no próprio componente chega mesmo com inherit: false
- Learner decidiu: manter a caixa do campo, moldura de foco cinza bem claro (remover se não der); moldura de hover do "+" cinza
- Learner aprovou additions: frameColor #d4d4d8 (escuro) / #a1a1aa (claro); hover do campo e clique do "+" também cinza; no TextField focusColor/hoverColor, no ToolButton highlightColor/hoverColor/focusColor = frameColor
- Verificação: kpackagetool6 -u ok; plasmawindowed 6 s sem erros; cor não conferida pelo Claude — learner deve confirmar (plano B: remover moldura)

## Passo 14 — campo sem moldura (implementado, 2026-10-03)
- Learner conferiu o passo 13: ainda azul. Pediu o plano B: remover a moldura do campo de nova tarefa para ver como fica
- Implementado: background do TextField = KSvg.FrameSvgItem lineedit prefix "base" (só a caixa, sem camadas hover/focus); mesmas margens → padding igual; removidas as cores focus/hover do campo
- Verificação: kpackagetool6 -u ok; plasmawindowed 6 s sem erros; visual não conferido pelo Claude

## Passo 15 — hover do "+" igual à caixa do campo (implementado, 2026-10-03)
- Learner aprovou o campo sem moldura (passo 14: "ficou ótimo")
- Learner decidiu: hover do "+" igual à caixa do campo — borda fina cinza, cantos arredondados
- Learner aprovou additions: reusar KSvg lineedit "base" como background do ToolButton; preenchimento leve junto; fade shortDuration; manter tamanho
- Implementado: background próprio com opacity no hover; padding: 4 fixo (medido: era 4, botão 30×30); removidas frameColor e as cores do passo 13
- Correção: logs do QML do plasmawindowed vão para o journal (journalctl --user), não para o terminal — verificações "sem erros" dos passos anteriores não olhavam no lugar certo
- Verificação: kpackagetool6 -u ok; journal sem erros; botão medido 30×30 após a mudança; visual não conferido pelo Claude

## Passo 16 — caixa no tema claro + rosa e vermelho (implementado, 2026-10-03)
- Learner reportou bug: no tema claro, hover do "+" e caixa do campo com fundo escuro
- Introduced (Claude explicou): preenchimento do lineedit "base" é ColorScheme-ViewBackground → backgroundColor do Kirigami.Theme do item; TextField/ToolButton não herdam as sobrescritas do full → vinha o fundo do BreezeDark do sistema; borda é ColorScheme-Frame
- Learner decidiu: escuro fica como está (cor do sistema); claro = caixa branca (fundo do widget), só a borda aparece; rosa e vermelho no estilo das cores atuais
- Learner aprovou additions: #ec4899 e #ef4444 depois do roxo; backgroundColor: root.dark ? undefined : root.bgColor nos dois FrameSvgItem (undefined desfaz a sobrescrita)
- Verificação: kpackagetool6 -u ok; journal sem erros. Learner conferiu: cores novas ok; caixa continuou escura no claro → correção falhou
- Introduced (Claude explicou): KSvg só repassa do Kirigami texto/fundo/destaque/positivo/neutro/negativo; ViewBackground e Frame vêm sempre do esquema do sistema. Caixa do tema veio da escolha do passo 10 (voltar à caixa original), não de decisão por BreezeDark; combinava no escuro por coincidência
- Learner decidiu: caixa própria só no modo claro, para ver como fica; se gostar, fará também no escuro
- Learner aprovou additions: fundo bgColor, borda 1 px borderColor, raio 6; mesmo Rectangle no hover do "+"
- Implementado: background = Item com FrameSvgItem (visible: dark) + Rectangle (visible: !dark); campo repassa margins da caixa do tema (alias) → padding igual nos dois modos; removidas as linhas backgroundColor sem efeito
- Verificação: kpackagetool6 -u ok; plasmawindowed 6 s em escuro e claro (default trocado só na cópia instalada, depois reinstalado), journal sem erros; visual não conferido pelo Claude

## Passo 16b — cor do texto digitado no claro (implementado, 2026-10-03)
- Learner aprovou a caixa própria no claro ("muito bom"); reportou texto digitado e cursor brancos
- Causa: TextField do Plasma usa colorSet View com cores do sistema (color = Kirigami.Theme.textColor); cursor padrão usa a cor do texto
- Implementado: color: root.dark ? Kirigami.Theme.textColor : root.textColor (escuro inalterado, como decidido)
- Verificação: kpackagetool6 -u ok; plasmawindowed escuro e claro, journal sem erros; visual não conferido pelo Claude

## Passo 17 — caixa própria também no escuro (implementado, 2026-10-03)
- Learner decidiu: caixa própria no escuro; razão (dele): usuário com outro tema do KDE teria cor diferente da esperada; manter o tom escuro atual
- Claude mediu: margens da caixa do tema = 6 px em cada lado; campo com 31 px de altura
- Learner aprovou additions: boxColor #141618 / boxBorderColor #424446 no escuro (valores do Breeze Dark; Frame = 20% entre fundo e texto); claro inalterado; raio 6 nos dois; padding fixo 6 (topo/baixo/direita); color do texto = root.textColor nos dois modos; seleção de texto fica com o sistema (fora do escopo)
- Implementado: background = Rectangle único no campo e no hover do "+"; removido import KSvg e lógica de duas camadas
- Verificação: kpackagetool6 -u ok; plasmawindowed escuro e claro, journal sem erros, campo com 31 px e padding 6 nos dois; visual não conferido pelo Claude

## Pending decision
- Passos 14–15 conferidos pelo learner no desktop (2026-10-03)
- Nenhuma decisão em aberto. Learner conferiu passos 16–17 no desktop: tudo funcionando (2026-10-03)
- Futuro: repensar paleta de cores; painel
- 2026-10-03: learner considera o widget concluído e pediu sugestões de melhoria; Claude listou propostas (Git, robustez do JSON.parse, campo aberto após Enter, acesso ao "+" sem hover, rolagem, reordenar, modo automático claro/escuro, painel, i18n/KDE Store). Nenhuma escolhida ainda

## Dúvidas sobre possibilidades (2026-10-02)
- Introduced (Claude explicou): posição do widget no desktop pertence ao containment, não ao plasmoid; mover = modo edição ou clicar-e-segurar; "arrastar como janela" exigiria virar janela própria (PlasmaCore.Window/plasmawindowed), com custos
