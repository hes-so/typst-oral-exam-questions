// SPDX-FileCopyrightText: 2026 Jacques Supcik <jacques.supci@hes-so.ch>
//
// SPDX-License-Identifier: MIT

#import "@local/hesso-oral-exam:0.2.0": exam, exam-solution

#set page(margin: (x: 20mm, top: 15mm, bottom: 20mm))
#set text(font: "Noto Sans")
#set enum(numbering: "a)")
#set text(lang: "fr")
#set par(justify: true)

#let data = toml("questions.toml")
#exam-solution.update(false)

#if sys.inputs.at("solution", default: "none") == "true" {
  exam-solution.update(true)
} else if sys.inputs.at("solution", default: "none") == "false" {
  exam-solution.update(false)
}

#exam(
  name: [Ecole des sorciers / 2024-25],
  date: [Examen oral du 30 juin 2025],
  logo: image(
    width: 110mm,
    "img/logo_heiafr_color.svg",
  ),
  envelopes: data.envelopes.map(l => (
    no: l.no,
    questions: l.questions.map(q => {
      let s = "questions/" + str(q) + ".typ"
      include s
    }),
  )),
)
