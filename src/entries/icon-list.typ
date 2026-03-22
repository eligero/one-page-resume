#import "./helpers.typ": icon-parser

#let icon-list(conf, data) = {
  let _measure(body) = {
    let size = measure(body)
    (width: size.width, height: size.height)
  }

  for i in data.list {
  
    let _icon = icon-parser(
      i.icon,
      conf.text.body-size,
      fill-color: conf.colors.accent,
      inline: false
    )

    let _head = text(
      weight: "bold",
      size: conf.text.body-size,
      font: conf.text.font,
      fill: conf.colors.accent,
      i.head
    ) 
    
      
    let _text = par(
      leading: 0.5em,
      spacing: 0em,
      justify: true,
      text(
        weight: "regular",
        size: conf.text.body-size,
        font: conf.text.font,
        fill: conf.colors.dark,
        hyphenate: false,
        i.text
      )
    )

    let _height = _measure(_icon).height
    
    block(
      width: 100%,
      inset: 0pt,
      outset: 0pt,
      spacing: 0pt,
      above: 0pt,
      below: 0pt,
      stack(
        dir:ltr,
        box(
          inset: 0pt,
          outset: 0pt,
          height: _height,
          width: _height,
          align(center, _icon)
        ),
        h(0.5em),
        stack(
          dir: ttb,
          box(width: 100% - _height - 0.5em, _head),
          v(0.6em),
          box(width: 100% - _height - 0.5em, _text),
        )
      )
    )
    
    if i!= data.list.last() {
      v(0.75em)
    }
  }
}
