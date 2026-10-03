# KDE ToDo

Widget de lista de tarefas minimalista para a área de trabalho do KDE Plasma 6, inspirado no widget de Lembretes do iPhone.

![KDE ToDo em funcionamento](docs/demo.gif)

## Como funciona

- Passe o mouse sobre o widget e clique em **+** para criar uma tarefa. Enter salva.
- Clique na bolinha para concluir: a tarefa fica riscada e some em 2 segundos. Clicar de novo nesse intervalo desfaz.
- Tarefa concluída é apagada. Não tem histórico.
- As tarefas ficam salvas na configuração do widget e sobrevivem a reboot.

## Personalização

Em **Configurar...** (botão direito no widget):

- **Título**: opcional, aparece no topo.
- **Ícone**: nenhum, chama, raio, estrela, coração, alvo ou livro.
- **Cor de destaque**: laranja, azul, verde, roxo, rosa ou vermelho.
- **Tema**: escuro ou claro, independente do tema do sistema.

## Instalação

Requer KDE Plasma 6.

```sh
git clone https://github.com/JvCasc/KDE-ToDo.git
cd KDE-ToDo
kpackagetool6 -t Plasma/Applet -i package
```

Depois, clique com o botão direito na área de trabalho → **Adicionar widgets** → procure por **KDE ToDo List**.

### Atualizar

```sh
git pull
kpackagetool6 -t Plasma/Applet -u package
```

Se a mudança não aparecer, reinicie o Plasma:

```sh
systemctl --user restart plasma-plasmashell
```

### Remover

```sh
kpackagetool6 -t Plasma/Applet -r com.jvcasc.kdetodo
```

Remover o widget da área de trabalho apaga as tarefas dele.

## Créditos

- Fonte [Inter](https://rsms.me/inter/), licença SIL OFL 1.1
- Ícones [Lucide](https://lucide.dev/), licença ISC

## Licença

GPL-2.0-or-later
