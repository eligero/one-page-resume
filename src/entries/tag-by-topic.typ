#import "./helpers.typ": type-tag

#let get-topic(s, size, font, color) = {
  text(
    weight: "bold",
    size: size,
    font: font,
    fill: color,
    s
  )
}

#let get-tags(s, size) = {
  let _tags = s.split(",")

  _tags.map(j => type-tag(
    j.trim(),
    size,
  ))
}

#let ats-text(s, size, _repeat) = { 
  text(
    size: size,
    fill:black.transparentize(100%),
    if _repeat {repeat(gap: 0.25em, justify: false, s)} else {s}
  )
}

#let tag-by-topic(conf, data) = {
  layout(size => {
    let _columns = {
      if size.width < 200pt or data.list.all(i => i.topic.len() == 0) {
        1
      } else {
        2
      }
    }
  
    let _size = conf.text.body-size
    let _font = conf.text.font
    let _colors = (
      light: conf.colors.light,
      accent: conf.colors.accent,
      dark: conf.colors.dark
    )
    let _paragraph = (
      leading: 0.5em,
      spacing: 0.6em,
      justify: true,
      linebreaks: "optimized",
    )

    for i in range(data.list.len()) {
      let tag-list = get-tags(data.list.at(i).tags, _size)
      if _columns == 2 {
        let max-head-width = calc.max(..(
          data.list.map(d => measure(text(
            weight: "bold",
            size: conf.text.body-size,
            font: conf.text.font,
            fill: conf.colors.accent,
            d.topic
          )).width)
        ))

        let topic = get-topic(
          data.list.at(i).topic, _size, _font, _colors.accent
        )

        let first-column-width = (
          max-head-width
          + measure(text(size: _size, ": ")).width
        )
        
        let _line = (
          box(
            width: max-head-width - measure(topic).width,
            ats-text(" ", _size, true)
          )
          + topic
          + ats-text(": ", _size, false)
        )


        for j in range(tag-list.len()) {
          let _tag = tag-list.at(j)
          let _text = {
            if j == tag-list.len() - 1 {
              ""
            } else {
              ats-text(", ", _size, false) + h(0.25em)
            }
          }
        
          if measure(_line + _tag  + _text).width >= size.width {
            _line += (
              linebreak()
              + box(
               width: first-column-width,
               ats-text(" ", _size, true)
             )
            )
          }
          _line += _tag + _text
        }

        par(
          leading: _paragraph.leading,
          spacing: _paragraph.spacing,
          justify: _paragraph.justify,
          linebreaks: _paragraph.linebreaks,
          _line
        )

        if i != data.list.len() - 1 { v(_paragraph.spacing, weak: true) }

      } else {
        let _tags = tag-list.join(ats-text(", ", _size, false) + h(0.25em))
        
        if data.list.at(i).topic.len() > 0 {
          let topic = get-topic(
            data.list.at(i).topic, _size, _font, _colors.accent
          )

          par(
            leading: _paragraph.leading,
            spacing: _paragraph.spacing,
            justify: _paragraph.justify,
            linebreaks: _paragraph.linebreaks,
            topic 
           ) + v(_paragraph.spacing, weak: true)
        }
        par(
          leading: _paragraph.leading,
          spacing: _paragraph.spacing,
          justify: _paragraph.justify,
          linebreaks: _paragraph.linebreaks,
          _tags
         )
         if i != data.list.len() - 1 { v(_paragraph.spacing, weak: true)
         }
      }
    }
  })
}
