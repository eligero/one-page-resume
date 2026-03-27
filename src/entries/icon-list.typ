#import "./helpers.typ": icon-parser

#let icon-list(conf, data) = {

  let paragraph = (
      leading: 0.5em,
      spacing: 0.75em,
      justify: true,
      linebreaks: "optimized",
    )

  set par(
    leading: paragraph.leading,
    spacing: paragraph.spacing,
    justify: paragraph.justify,
    linebreaks: paragraph.linebreaks
  )


  for i in data.list {
    let _icon = icon-parser(
      i.icon,
      conf.text.body-size,
      fill-color: conf.colors.accent,
      inline: false
    )

    let _par = box(
      width: 100% - 1.875em - 0.25em,
      text(
        weight: "bold",
        size: conf.text.body-size,
        font: conf.text.font,
        fill: conf.colors.accent,
        i.head
      )  + linebreak() + text(
        weight: "regular",
        size: conf.text.body-size,
        font: conf.text.font,
        fill: conf.colors.dark,
        hyphenate: false,
        i.text
      )
    )
  
    layout(size => {
      let (height,) = measure(width: size.width, _par)
      par(
        box(
          width: 1.875em,
          height: height,
          align(center, _icon)
        ) + h(0.25em) + _par
      )
    })
  }
}
