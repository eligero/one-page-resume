#import "./helpers.typ": type-tag

#let tag-by-topic(conf, data) = {
  layout(size => {
    let _columns = {
      if size.width < 200pt or data.list.all(i => i.topic.len() == 0) {
        (100%,)
      } else {
        (1fr, 4fr)
      }
    }

    table(
      align: horizon,
      columns: _columns,
      column-gutter: 0.75em,
      row-gutter: 0.5em,
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
          _tags.push(type-tag(
            j.trim(),
            conf.text.body-size,
            conf.colors.accent,
            conf.colors.light
          ))
        }
        
        let _text = table.cell(
          inset: (top: 0.2em, bottom: 0.2em),
          _tags.join(h(0.33em))
        )
          
        if i.topic.len() > 0 { (_head, _text) } else { (_text,) }
      }
    )
  })
}
