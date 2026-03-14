
#let type-tag(content, colors, conf) = {
  box(
    fill: colors.accent.transparentize(50%),
    inset: (x: 0.25em, y: 0.05em),
    outset: (y: 0.2em),
    radius: 25%,
    baseline: 25%,
    text(
      weight: "regular",
      size: conf.body-size,
      font: conf.font,
      fill: colors.light,
      raw(content)
    )
  )
}


#let tag-by-topic(conf, data) = {
  layout(size => {
    let _columns = {
      if size.width < 200pt or data.list.all(i => i.topic.len() == 0) {
        1
      } else {
        (1fr, 4fr)
      }
    }

    table(
      align: horizon,
      columns: _columns,
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
            i.topic
          )
        )
        
        let _tags = ()
        for j in i.tags.split(",") {
          _tags.push(type-tag(j.trim(), conf.colors, conf.text))
        }
        
        let _text = table.cell(
          _tags.join(h(0.33em))
        )
          
        if i.topic.len() > 0 { (_head, _text) } else { (_text,) }
      }
    )
  })
}
