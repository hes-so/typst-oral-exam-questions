// SPDX-FileCopyrightText: 2026 Jacques Supcik <jacques.supci@hes-so.ch>
//
// SPDX-License-Identifier: MIT
//
// This file is part of the HES-SO exam template.
//

#let fillgrid(square_size: 4mm, color: aqua) = {
  layout(size => {
    let columns = int(size.width / square_size)
    let rows = int(size.height / square_size)
    set line(
      stroke: 0.1mm + color,
    )
    let c = 0
    while (c <= columns) {
      place(line(start: (c * square_size, 0mm), end: (c * square_size, rows * square_size)))
      c = c + 1
    }
    let r = 0
    while (r <= rows) {
      place(line(start: (0mm, r * square_size), end: (columns * square_size, r * square_size)))
      r = r + 1
    }
  })
}

#let exam-name = state("exam", [])
#let exam-date = state("exam-date", [])
#let exam-logo = state("exam-logo", none)
#let exam-solution = state("exam-solution", false)

#let qno = counter("question")

#let question(
  title: none,
  author: none,
  solution: none,
  doc,
) = {
  set table(inset: (
    x: 5pt,
    y: 15pt,
  ))
  context [#exam-logo.get()]
  v(4mm)
  context [*#exam-name.get()*#h(1fr)*#exam-date.get()*]
  parbreak()
  context {
    let sol = exam-solution.get()
    if sol {
      box(stroke: black, inset: (x: 10pt, y: 15pt), width: 100%, radius: 2mm, align(
        center + horizon,
        text(
          fill: red,
          size: 30pt,
          weight: "black",
          [Corrigé],
        ),
      ))
    } else {
      box(
        stroke: black,
        inset: (x: 10pt, y: 25pt),
        width: 100%,
        radius: 2mm,
        [Nom de l'étudiant-e :],
      )
    }
  }
  v(2mm)
  [*Question #context qno.display("1a") : #title*]
  parbreak()

  doc
  v(2mm)
  context (
    {
      let sol = exam-solution.get()
      if sol {
        block(
          inset: 10mm,
          stroke: .7mm + green,
          fill: green.lighten(90%),
          radius: 2mm,
          width: 100%,
          [
            #solution
          ],
        )
        pagebreak(weak: true)
      } else {
        block(height: 1fr, width: 100%, fillgrid())
        pagebreak()
        block(height: 1fr, width: 100%, fillgrid())
      }
      pagebreak(weak: true, to: "odd")
    }
  )
}


#let exam(
  name: none,
  date: none,
  envelopes: (),
  logo: none,
) = {
  exam-name.update(name)
  exam-date.update(date)
  exam-logo.update(logo)
  for e in envelopes {
    qno.update(e.no)
    for q in e.questions {
      qno.step(level: 2)
      q
    }
  }
}

#let prof_evaluation_page(
  title: none,
  logo: image(
    width: 110mm,
    "img/mse_logo.svg",
  ),
  date: none,
  student: none,
  class: none,
  teacher: none,
  expert: none,
  duration: none,
  preparation: none,
  passage: none,
  version: none,
  question1: none,
  question2: none,
) = {
  set table(
    inset: (
      x: 5pt,
      y: 15pt,
    ),
  )
  place(top + right, [
    // Prefer widely available cursive/script-like fonts for the stamp.
    #set text(font: ("Noto Sans", "DejaVu Sans", "Liberation Sans"), size: 20pt, fill: blue)
    #rotate(-5deg, version)
  ])
  logo
  v(4mm)
  [*#title*#h(1fr)*#date*]
  table(
    columns: (9em, 11em, 10em, 4em, 1fr),
    table.cell(colspan: 3, [Nom de l'étudiant-e : *#student*]),
    table.cell(colspan: 2, [Classe : *#class*]),
    //    ---
    table.cell(colspan: 2, [Enseignant-e : *#teacher*]),
    table.cell(colspan: 3, [Expert-e : *#expert*]),
    //    ---
    table.cell(colspan: 1, [Durée : *#duration*]),
    table.cell(colspan: 1, [Préparation : *#preparation*]),
    table.cell(colspan: 1, [Passage : *#passage*]),
    table.cell(colspan: 2, [Note finale : ]),
    //    ---
    table.cell(colspan: 3, [Question 1: *#question1*]),
    table.cell(colspan: 2, [Note Question 1:]),
    table.cell(colspan: 3, [Question 2: *#question2*]),
    table.cell(colspan: 2, [Note Question 2:]),
  )
  v(2mm)
  block(
    height: 1fr,
    width: 100%,
    fillgrid(),
  )
}

