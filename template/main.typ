// SPDX-FileCopyrightText: 2026 Jacques Supcik <jacques.supcik@hes-so.ch>
//
// SPDX-License-Identifier: MIT

#import "@local/hesso-oral-exam:0.2.6": exam, exam-solution

#set page(margin: (x: 20mm, top: 15mm, bottom: 20mm))
#set text(font: "Noto Sans")
#set enum(numbering: "a)")
#set text(lang: "fr")
#set par(justify: true)

#let data = toml("questions.toml")
#exam-solution.update(true)

#if sys.inputs.at("solution", default: "none") == "true" {
  exam-solution.update(true)
} else if sys.inputs.at("solution", default: "none") == "false" {
  exam-solution.update(false)
}

#let show-student-name = sys.inputs.at("show-student-name", default: "false") == "true"

// Load students.toml. If the `students` array is non-empty, envelopes are
// printed in student order. Pass `--input show-student-name=true` to also
// render each student's name in the header.
// Set `students = []` (or keep the array empty) to use the default order
// from questions.toml.
#let students = toml("students.toml").at("students", default: ())

#let ordered-envelopes = if students.len() > 0 {
  students.map(s => {
    let envelope-no = int(s.envelope)
    let e = data.envelopes.find(e => e.no == envelope-no)
    if e == none {
      panic("students.toml references envelope " + str(envelope-no) + " which is not present in questions.toml")
    }
    (
      no: envelope-no,
      student: s.name,
      questions: e.questions.map(q => include "questions/" + str(q) + ".typ"),
    )
  })
} else {
  data.envelopes.map(l => (
    no: l.no,
    questions: l.questions.map(q => {
      let s = "questions/" + str(q) + ".typ"
      include s
    }),
  ))
}

#exam(
  name: [Ecole des sorciers / 2024-25],
  date: [Examen oral du 30 juin 2025],
  logo: image(
    width: 110mm,
    "img/logo_heiafr_color.svg",
  ),
  envelopes: ordered-envelopes,
  show-student-name: show-student-name,
)
