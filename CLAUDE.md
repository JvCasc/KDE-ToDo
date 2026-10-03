# KDE Todo

Widget (plasmoid) de to-do minimalista para KDE Plasma 6 (Fedora), feito em modo de aprendizado.

- Sempre retome com `/vibe-wise:learn`: o learner decide o design; Claude explica conceitos e implementa o que foi combinado.
- Estado do aprendizado e decisões: `.vibe-wise/` (`profile.md`, `progress.md` com a decisão pendente, `project-map.md` com requisitos, modelo de dados e fluxo). Leia antes de propor qualquer coisa.
- Código: `package/` (metadata.json, contents/config/main.xml, contents/ui/main.qml).
- Reinstalar após mudanças: `kpackagetool6 -t Plasma/Applet -u package` (se não atualizar: `systemctl --user restart plasma-plasmashell`).
- Idioma: português.
