#import "@preview/droplet:0.3.1": dropcap


#let simple(conf, data) = {

  if data.text.len() == 0 {
    data.text = lorem(20)
  }


  text(
    weight: "regular",
    font: conf.text.font,
    size: conf.text.body-size,
    fill: if data.hide-heading or data.heading.len() == 0 {
      conf.colors.accent
      } else {
        conf.colors.dark
      },
    if data.drop-cap {
      dropcap(
        height: 2,
        gap: 33% * conf.text.body-size,
        hanging-indent: 0em,
        overhang: 0pt,
        font: conf.text.font,
      )[#data.text]     
    } else {
      data.text
    }
  )
}