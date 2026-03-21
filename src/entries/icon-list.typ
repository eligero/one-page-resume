#import "./helpers.typ": icon-parser

#let icon-list(conf, data) = {
  table(
    align: horizon,
    columns: (auto, 2fr),
    column-gutter: 0.5em,
    row-gutter: 0.75em,
    inset: (top: 0.25em, bottom: 0em, left: 0em, right: 0em),
    ..for i in data.list {

      let _icon = table.cell(
        align: top + center,
        icon-parser(
          i.icon,
          conf.text.body-size,
          fill-color: conf.colors.accent
        )
      )

      let _text = table.cell(
        text(
          weight: "bold",
          size: conf.text.body-size,
          font: conf.text.font,
          fill: conf.colors.accent,
          i.head
        ) + linebreak() +
        text(
          weight: "regular",
          size: conf.text.body-size,
          font: conf.text.font,
          fill: conf.colors.dark,
          i.text
        )
      ) 

      (_icon, _text)
    }
  )
}
