#import "./helpers.typ": icon-parser, ats-gaps, ats-text

#let _name(conf, data) = {
  let name_array = data.name.split()
  let name = name_array.first() + " "
  let surname = name_array.slice(1).join(" ")

  text(
    weight: "regular",
    size: conf.header.name.size,
    font: conf.header.name.font,
    fill: conf.page.colors.dark,
    name
  ) + text(
    weight: "bold",
    size: conf.header.name.size,
    font: conf.header.name.font,
    fill: conf.page.colors.dark,
    surname
  )
}

#let _role(conf, data) = {  
  let size_corrector = 75%

  let role = text(
    font: conf.header.role.font,
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
    size: conf.header.role.loc_size,
    font: conf.header.role.font,
    fill: conf.page.colors.dark,
    weight: "regular",
    " " + data.location
  )

  role + text(
    size: conf.header.role.loc_size,
    font: conf.header.role.font,
    fill: conf.page.colors.dark,
    weight: "regular",
    h(1em)
  ) + icon + location
}

#let _line_icons(conf, data, line) = {
  let _regex = (
    email: (k: "email: ", re: regex("[\w\.-]+@[\w\.-]+\.\w+")),
    linkedin: (k: "linkedin: ", re: regex("(?:https?://)?(?:www\.)?linkedin\.com/in/[\w-]+/?")),
    github: (k: "github: ", re: regex("(?:https?://)?(?:www\.)?github\.com/[\w-]+/?")),
    x: (k: "x: ", re: regex("(?:https?://)?(?:www\.)?(?:x|twitter)\.com/[\w-]+/?")),
    default: (k: none, re:regex("(?:https?://|www\.)[^\s]+(?:\.[^\s]+)+"))
  )

  let _line = (
    pdf: none,
    ats: none
  )
  
  for i in data.at(line) {
    let icon = box(
      baseline: 12.5% * conf.header.line-icons.size,
      icon-parser(
        i.icon,
        conf.header.line-icons.size,
        fill-color: conf.page.colors.accent
    ))
    
    let _text = {
      if i.link.len() > 0 {
        text(
          size: conf.header.line-icons.size,
          fill: conf.page.colors.dark,
          font: conf.header.line-icons.font,
          link(i.link, i.text)
        )

        for (k, v) in _regex {
          if i.link.match(v.re) != none {
            if v.k == none {
              _line.ats += i.text + ": " + i.link + ";"
            } else {
              _line.ats += v.k + i.link + ";"
            }
            break
          }
        }
      } else {
        text(
          size: conf.header.line-icons.size,
          fill: conf.page.colors.dark,
          font: conf.header.line-icons.font,
          i.text
        )
      }
    }

    _line.pdf += icon + text(
        size: conf.header.line-icons.size,
        fill: conf.page.colors.dark,
        font: conf.header.line-icons.font,
        h(0.1em)
      ) + _text

    if i != data.at(line).last() {
      _line.pdf += box(
        width: 0pt,
        ats-text(
          ", ",
          conf.header.line-icons.size,
          conf.header.line-icons.font,
          false
        )
      ) + ats-gaps(
        0.75em,
        conf.header.line-icons.size,
        conf.header.line-icons.font
      )
    }
  }

  _line
}

#let header(conf, data, width) = {
  set par(leading: 0em, spacing: 0em)

  let line_1 = _line_icons(conf, data, "line_1")
  
  let line_2 = {
    if data.at("line_2").len() > 0 {
      _line_icons(conf, data, "line_2")
    } else {
      none
    }
  }
  
  let name = block(
    width: width - conf.page.margins.right,
    _name(conf, data)
  )
  
  let role = {    
    block(
      width: width - conf.page.margins.right,
      v(1em) + _role(conf, data) + v(0.75em)
    )
  
  }

  let pdf_line_1 = block(
    width: width - conf.page.margins.right,
    line_1.pdf
  )

  let pdf_line_2 = {
    if line_2.len() > 0 {
      block(
        width: width - conf.page.margins.right,
        v(0.5em) + line_2.pdf
      )
    } else {
      ""
    }
  }

  let build-ats-text(s) = {
    let _text = ""
    let _width = page.width - conf.page.margins.right - conf.page.margins.left

    for i in s.split(";") {
      if i == "" { continue }
      let _add_text = {
        if i == s.split(";").at(-2) {
           ats-text(i, 0.6pt, "arial", false)
        } else {
           ats-text(i + "; ", 0.6pt, "arial", false)
        }
      }
      if measure(_text + _add_text).width > _width {
        _text += linebreak() + _add_text
      } else {
        _text += _add_text
      }
    }
    _text
  }

  let ats-text = build-ats-text(
    "Name: " + data.name + ";" + "Location: " + data.location + ";" 
    + line_1.ats
    + if line_2 != none and line_2.ats.len() > 0 { line_2.ats } else { "" }
  )

  let ats = block(
    width: page.width - conf.page.margins.right - conf.page.margins.left,
    height: 0pt,
    v(0.6em) + ats-text + v(0.6em)
  )

  name + ats + role + pdf_line_1 + pdf_line_2

}
