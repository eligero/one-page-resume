#import "./helpers.typ": ats-gaps, ats-text

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

  return _bar
}

#let bar-percent-list(conf, data) = {
  let paragraph = (
    leading: 0.5em,
    spacing: 0.6em,
    justify: true,
    linebreaks: "optimized",
  )

  set par(
    leading: paragraph.leading,
    spacing: paragraph.spacing,
    justify: paragraph.justify,
    linebreaks: paragraph.linebreaks
  )

  let _data = (
    head-width: (),
    data: ()
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

    let _text = text(
      weight: "bold",
      size: conf.text.body-size,
      font: conf.text.font,
      fill: conf.colors.accent,
      i.text
    ) + box(
      width: 0pt,
      ats-text(":", conf.text.body-size, conf.text.font, false)
    )

    _data.head-width.push(measure(_text).width)
    _data.data.push((
      head: _text,
      tag: tag,
      percent: i.percent
    ))
  }

  let head-width = calc.max(.._data.head-width)

  for i in _data.data {
    par(
      ats-gaps(
        head-width - measure(i.head).width,
        conf.text.body-size,
        conf.text.font
      )
      + i.head
      + h(0.75em)
      + box(
        width: 0pt,
        ats-text(i.tag, conf.text.body-size, conf.text.font, false)
        )
      + box(
        width: 100% - head-width - 0.75em,
        bar-percent(i.percent, conf.colors))
      )
  }  
}
