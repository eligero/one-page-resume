#let bar-percent(percent, colors) = {
  let active-color = colors.accent
  let inactive-color = colors.light.darken(20%)

  let _bar = stack(
      dir: rtl,
      spacing: -5%,
      rect(
        width: 100% + 5% - percent * 1%,
        height: 0.4em,
        fill: inactive-color,
        radius: (right: 50%)
      ),

      rect(
        width: percent * 1%,
        height: 0.4em,
        fill: active-color, radius: 50%
      ),
    )

  _bar
}

#let bar-percent-list(conf, data) = {
  set par(
    spacing: 0.5em,
    leading: 0em,
  )

  for i in data.list {
    let tag = if i.percent >= 81 {
      data.ranges.last()
    } else if i.percent >= 61 {
      data.ranges.at(-2)
    } else if i.percent >= 41 {
      data.ranges.at(-3)
    } else if i.percent >= 21 {
      data.ranges.at(-4)
    } else {
      data.ranges.first()
    }

    let _head = text(
        weight: "bold",
        size: conf.text.body-size,
        font: conf.text.font,
        fill: conf.colors.accent,
        i.text
      ) + box(
        width: 0pt,
        text(
          ":",
          fill: white.transparentize(100%),
          size: conf.text.body-size,
          font: conf.text.font
        )
      )
        
    let _percent =  (
      box(
        width: 0pt,
        text(
          tag + ", ",
          fill: white.transparentize(100%),
          size: conf.text.body-size,
          font: conf.text.font
        )
      ) + box(bar-percent(i.percent, conf.colors))
    )

    block(
      box(width: 1fr, _head)
      + h(0.75em)
      + box(width: 2fr, _percent)
    )
  }
}
