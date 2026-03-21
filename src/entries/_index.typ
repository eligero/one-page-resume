#import "./simple.typ": simple
#import "./icon-list.typ": icon-list
#import "./dot-score-list.typ": dot-score-list
#import "./bar-percent-list.typ": bar-percent-list
#import "./tag-by-topic.typ": tag-by-topic
#import "./dynamic-columns.typ": dynamic-columns
#import "./helpers.typ": accent-heading, light-heading

#let entries = (
  "simple": simple,
  "icon-list": icon-list,
  "dot-score-list": dot-score-list,
  "bar-percent-list": bar-percent-list,
  "tag-by-topic": tag-by-topic,
  "dynamic-columns": dynamic-columns
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
    if i.len() == 0 { continue }
    
    show heading: it => {
      set block(above: 1em, below: 0.5em)
      if i.hide-heading == false { it }
    }
  
    if i.heading.len() > 0 {
      (_heading(content))(
        conf.at(content),
        i.heading
      )
    }
  
    entries.at(i.entry)(conf.at(content), i)
  }
}
