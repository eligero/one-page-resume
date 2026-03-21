#import "./helpers.typ": icon-parser

#let _name(conf, data) = {
  set text(
    size: conf.header.name.size,
    font: conf.header.name.font,
    fill: conf.page.colors.dark
  )

  let name_array = data.name.split()
  let name = name_array.first() + " "
  let surname = name_array.slice(1).join(" ")

  name + strong(surname)
}

#let _role(conf, data) = {
  set text(size: conf.header.role.loc_size, font: conf.header.role.font)
  
  let size_corrector = 75%

  let role = text(
    size: conf.header.role.role_size,
    weight: "bold",
    fill: conf.page.colors.accent, data.role
  )

  let icon = box(
    baseline: -12.5% * size_corrector * conf.header.role.loc_size,
    icon-parser(
      "fa-location-dot",
      size_corrector * conf.header.role.loc_size,
      fill-color: conf.page.colors.accent
  ))

  let location = text(
    fill: conf.page.colors.dark,
    weight: "regular",
    " " + data.location
  )

  role + h(1em) +icon + location
}

#let _line_icons(conf, data, line) = {
  set text(
    size: conf.header.line-icons.size,
    fill: conf.page.colors.dark,
    font: conf.header.line-icons.font
  )

  let _line = ""
  for i in data.at(line) {
    let icon = box(
      baseline: 12.5% * conf.header.line-icons.size,
      icon-parser(
        i.icon,
        conf.header.line-icons.size,
        fill-color: conf.page.colors.accent
    ))
    
    let _text = if i.link.len() > 0 { link(i.link, i.text) } else {i.text}
    _line += icon + h(0.1em) + _text
    if i != data.at(line).last() {
      _line += h(0.6em)
    }
  }
  _line
}

#let header(conf, data, width) = {
  
  set par(leading: 0em, spacing: 0em)
  
  let name = block(
    width: width - conf.page.margins.right,
    _name(conf, data),
  )
  
  let role = block(
    width: width - conf.page.margins.right,
    v(1em) + _role(conf, data) + v(0.75em)
  )

  let line_1 = block(
    width: width - conf.page.margins.right,
    _line_icons(conf, data, "line_1")
  )

  let line_2 =if data.at("line_2").len() > 0 {
    block(
      width: width - conf.page.margins.right,
      v(0.5em) +_line_icons(conf, data, "line_2")
    )
  } else {""}

  name + role + line_1 + line_2
}
