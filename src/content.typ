#import "entries/simple.typ": simple
#import "entries/icon-list.typ": icon-list
#import "entries/dot-score-list.typ": dot-score-list
#import "entries/bar-percent-list.typ": bar-percent-list
#import "entries/tag-by-topic.typ": tag-by-topic
#import "entries/helpers.typ": accent-heading, light-heading

#let entries = (
  "simple": simple,
  "icon-list": icon-list,
  "dot-score-list": dot-score-list,
  "bar-percent-list": bar-percent-list,
  "tag-by-topic": tag-by-topic
)

#let _colors(conf, content) = {
  if content in ("accent-column", "accent-header") {
    (
      accent: conf.page.colors.light,
      dark: conf.page.colors.light.darken(10%),
      light: conf.page.colors.light
    )
  } else {
    conf.page.colors
  }
}

#let _heading(content) = {
  if content in ("accent-column", "accent-header") {
    light-heading
  } else {
    accent-heading
  }
}

#let contents(conf, data, content: "accent-column") = {
  conf.at(content).insert("colors", _colors(conf, content))
  set text(size: conf.at(content).text.body-size)
  
  for i in data { 
    show heading: it => {
      set block(above: 1em, below: 0.8em)
      if i.hide-heading == false { it }
    }

    if i.heading.len() > 0 {
      (_heading(content))(
        conf.at(content),
        i.heading
      )
    }

    //set par(leading:0pt, spacing:0pt)

    entries.at(i.entry)(conf.at(content), i)
  }
}
