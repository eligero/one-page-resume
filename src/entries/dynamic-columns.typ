#import "./helpers.typ": icon-parser, type-tag


#let display-dates(date-start, date-end, format) = {
  let _format = {
    if format == "FULL"{
      "[year]-[month repr:numerical]-[day]"
    } else if format == "YM" {
      "[month repr:numerical]/[year]"
    } else { //"Y"
      "[year]"
    }
  }

  if date-start != false and date-end != false {
    if type(date-end) == str{
      date-start.display(_format) + " - " + date-end
    }else{
      date-start.display(_format) + " - " + date-end.display(_format)
    }
  } else if date-start != false {
    date-start.display(_format)
  } else {
    date-end.display(_format)
  }
}

#let ats-text(s, _size, _font, _repeat) = {
  text(
    size: _size,
    font: _font,
    fill:black.transparentize(100%),
    if _repeat {repeat(justify: false, s)} else {s}
  )
}

#let ats-gaps(_width, _size, _font) = {
  box(
    width: _width,
    ats-text(".", _size, _font, true)
  )
}

#let links-width(s, conf) = {
   measure(s).width + if s != none {
      let _pad = 0pt
      let _wlink = conf.text.body-size/3 + measure(h(0.1em)).width
      if s.child.func() == link {
        _pad += _wlink
      } else if s.child.has("children") {
        for i in s.child.children {
          if i.func() == link {
            _pad += _wlink
          }
        }
      }
      _pad
    } else {0pt}
}

#let make-content(conf, data, date-format, paragraph, extension: false) = { 
  let parameters = (
    icon: (
      width: 1.875em,
      size: 150% * conf.text.body-size,
      background-color: none,
      inline: false,
      padding: 0.5em
    )
  )


  let is_icon = (
    data.keys().contains("icon") and (
      (type(data.icon) == str and data.icon.len() > 0) or
      (type(data.icon) == dictionary and data.icon.icon.len() > 0
    )))
  let is_subtitle-right = data.keys().contains(
    "subtitle-right") and data.subtitle-right.len() > 0
  let is_dates = data.date-start != false or data.date-end != false
  let is_description = data.keys().contains(
    "description") and data.description.len() > 0
  let is_tags = data.keys().contains("tags") and data.tags.len() > 0


  let _dates = if not is_dates {none} else {
    text(
      font: conf.text.font,
      size: conf.text.body-size,
      weight: "regular",
      style: "italic",
      fill: conf.colors.accent,
      display-dates(data.date-start, data.date-end, date-format)
    )
  }

  let _subtitle-right = if not is_subtitle-right{none} else {
    text(
      font: conf.text.font,
      size: conf.text.body-size,
      weight: "regular",
      style: "italic",
      fill: if is_dates{conf.colors.dark} else {conf.colors.accent},
      eval(data.subtitle-right, mode: "markup")
    )
  }

  let gap-width = (
    icon: if is_icon { 
      parameters.icon.width + parameters.icon.padding } else {0pt},
    subtitle-right: links-width(_subtitle-right, conf),
    dates: measure(_dates).width
  )
  
  let title-line = if extension {none} else{
    let _text = text(
      font: conf.text.font,
      size: conf.text.body-size,
      weight: "bold",
      fill: conf.colors.accent,
      eval(data.title, mode: "markup")
    )
  
    _text + if is_dates {
      ats-gaps(
        100% - links-width(_text, conf) - gap-width.icon - gap-width.dates,
        conf.text.body-size,
        conf.text.font
      ) + _dates
    } else if is_subtitle-right {
      ats-gaps(
        100% - links-width(
          _text, conf) - gap-width.icon - gap-width.subtitle-right,
        conf.text.body-size,
        conf.text.font
      ) + _subtitle-right
    } else {
      none
    } + linebreak()
  }

  let subtitle-line = {
    let _text = text(
      font: conf.text.font,
      size: conf.text.body-size,
      weight: if extension {"bold"} else {"regular"},
      style: if extension {"normal"} else {"italic"},
      fill: if extension {conf.colors.accent} else {conf.colors.dark},
      data.subtitle
    )
    if extension and is_icon {
      box(
        clip: true,
        width: parameters.icon.width,
        height: 1em/2,
        align(
          horizon + center,
          circle(radius: 1em/4, fill: conf.colors.accent.transparentize(75%))
        )
      ) + h(parameters.icon.padding)
    } +_text + if extension and is_dates {
      ats-gaps(
        100% - measure(_text).width - gap-width.icon - gap-width.dates,
        conf.text.body-size,
        conf.text.font
      ) + _dates
    } else if is_subtitle-right and is_dates{
      ats-gaps(
        100% - measure(_text).width - gap-width.icon - gap-width.subtitle-right,
        conf.text.body-size,
        conf.text.font
      ) + _subtitle-right
    } else {
      none
    }
  }

  par(
    if not extension and is_icon {
      box(
        width: parameters.icon.width,
        height: parameters.icon.width,
        icon-parser(
          data.icon.icon,
          parameters.icon.size,
          fill-color: if data.icon.color != false {
            rgb(data.icon.color)} else {false},
          inline: parameters.icon.inline
        )
      ) + h(parameters.icon.padding) + box(
        title-line + subtitle-line
      )
    } else {
      title-line + subtitle-line
    }
  )

  if is_description {
    let _text = text(
      font: conf.text.font,
      size: conf.text.body-size,
      fill: conf.colors.dark,
      eval(data.description, mode: "markup")
    )

    par(
      box(inset: (
        left: parameters.icon.width + parameters.icon.padding,
        right: parameters.icon.width + parameters.icon.padding,
        top: 0em,
        bottom: 0em),
        outset: (
          left: -parameters.icon.width/2,
          bottom: if is_tags {paragraph.spacing} else {0pt}
        ),
        stroke: (left:1pt + conf.colors.accent.transparentize(75%)),
        _text
      )
    )
  }

  if is_tags {
    let _text = data.tags.split(",").map(j => type-tag(
      j.trim(), conf.text.body-size)).join(
      ats-text(", " + h(0.25em), conf.text.body-size, conf.text.font, false)
    )

    par(
      box(inset: (
        left: parameters.icon.width + parameters.icon.padding,
        right: parameters.icon.width + parameters.icon.padding,
        top: 0em,
        bottom: 0em),
        outset: (left: -parameters.icon.width/2),
        stroke: (left:1pt + conf.colors.accent.transparentize(75%)),
        _text
      )
    )
  }
}

#let dynamic-columns(conf, data) = {
  let paragraph = (
      leading: 0.5em,
      spacing: 0.75em,
      justify: true,
      linebreaks: "optimized",
    )

  set par(
    leading: paragraph.leading,
    spacing: paragraph.spacing,
    justify: paragraph.justify,
    linebreaks: paragraph.linebreaks
  )

  show link: it => {
    let _w=conf.text.body-size/3
    let _h=conf.text.body-size/3
    
    it + h(0.1em) + box(
      height: paragraph.leading,
      width: conf.text.body-size/3,
      curve(
        stroke: 0.5pt + conf.colors.accent,
        curve.line((_w/3, 0pt)),
        curve.line((0pt, 0pt)),
        curve.line((0pt, _h)),
        curve.line((_w, _h)),
        curve.line((_w, _h - _h/3)),
        curve.move((_w, 0pt), relative: false),
        curve.line((_w - _w/3, 0pt)),
        curve.line((_w, 0pt)),
        curve.line((_w, _h/3)),
        curve.move((_w/2, _h/2), relative: false),
        curve.line((_w, 0pt)),
      ) 
    )
  }

  for i in data.list {
    make-content(
      conf, i, data.date-format, paragraph,
      extension: false,
    )
    
    if i.keys().contains("extension") and i.extension.len() > 0 {
      for j in i.extension {
        j.insert("icon",i.icon)
        make-content(
          conf, j, data.date-format, paragraph,
          extension: true,
        )
      }
    }     
  }
}
