#let dot-rating(rating, colors, max-rating: 5) = {
  let active-color = colors.accent
  let inactive-color = colors.light.darken(20%)
	
  let _dot = stack(
		dir: ltr,
    spacing: 0.25em,
    ..range(max-rating).map(i => {
      circle(
        radius: 0.25em,
        fill: if i < rating { active-color } else { inactive-color }
      )
    })
  )

  _dot
}

#let dot-score-list(conf, data) = {
  set par(
    spacing: 0.5em,
    leading: 0em,
  )

  let _data = (
    head: (
      data: (),
      width: (),
    ),
    alt: (
      data: (),
      width: (),
    ),
    score: (),
  )

  let _measure(body) = {
    let size = measure(body)
    size.width
  }

  for i in data.list {
    _data.head.data.push(text(
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
    ))

    _data.head.width.push(
      _measure(_data.head.data.last())
    )
    
    if not data.hide-alt {
      _data.alt.data.push(
        text(
          weight: "regular",
          size: conf.text.body-size,
          font: conf.text.font,
          fill: conf.colors.dark,
          i.alt
        ) + box(
          width: 0pt,
          text(
            ", ",
            fill: white.transparentize(100%),
            size: conf.text.body-size,
            font: conf.text.font
          )
        )
      )
      _data.alt.width.push(
        _measure(_data.alt.data.last())
      )
    } else {
      _data.alt.width.push(0pt)
      _data.alt.data.push("")
    }
    
    _data.score.push(
      if data.hide-alt {
        box(
          width: 0pt,
          text(
            i.alt + ", ",
            fill: white.transparentize(100%),
            size: conf.text.body-size,
            font: conf.text.font
          )
        ) + box(dot-rating(i.rating, conf.colors))
      } else {
        box(dot-rating(i.rating, conf.colors))
      }
    )
  }

  let head-width = calc.max(.._data.head.width)
  let alt-width = calc.max(.._data.alt.width)

  for i in range(_data.head.data.len()) {
    block(
      box(width: head-width, _data.head.data.at(i))
      + h(0.75em)
      + box(width: alt-width, _data.alt.data.at(i))
      + if not data.hide-alt {h(0.75em)}
      + _data.score.at(i)
    )
  }
}
