#let bar-percent(percent, colors) = {
  let tag = if percent >= 81 { "Expert" }
            else if percent >= 61 { "Proficient" }
            else if percent >= 41 { "Advanced" }
            else if percent >= 21 { "Intermediate" }
            else { "Beginner" }
 
  let _tag = box(width: 0pt, text(tag, fill: white.transparentize(100%)))

  let active-color = colors.accent
  let inactive-color = colors.light.darken(20%)

  let _bar = box(stack(
      dir: rtl,
      spacing: -5%,
      rect(width: 100% + 5% - percent * 1%, height: 0.4em, fill: inactive-color, radius: (right: 50%)),
      rect(width: percent * 1%, height: 0.4em, fill: active-color, radius: 50%),
    ))  + linebreak()

  _tag + _bar
}

#let bar-percent-list(conf, data) = {
  table(
    align: horizon,
    columns: (auto, 2fr),
    column-gutter: 0.75em,
    row-gutter: 0.75em,
    inset: 0pt,
    ..for i in data.list {
      let _head = table.cell(
        text(
          weight: "bold",
          size: conf.text.body-size,
          font: conf.text.font,
          fill: conf.colors.accent,
          i.text
        )
      )
        
      let _percent = table.cell(
        bar-percent(i.percent, conf.colors)
      )

      (_head, _percent)
    }
  )
}
