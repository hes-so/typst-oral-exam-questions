// SPDX-FileCopyrightText: 2026 Serge Ayer <serge.ayer@hes-so.ch>
// SPDX-FileCopyrightText: 2026 Jacques Supcik <jacques.supcik@hes-so.ch>
//
// SPDX-License-Identifier: MIT

#import "@local/hesso-oral-exam:0.2.4": prof_evaluation_page
#set page(margin: (x: 20mm, top: 15mm, bottom: 20mm))
#set text(font: "Noto Sans")

// Keep question and solution content continuous and avoid duplex-oriented blanks.
#show pagebreak.where(weak: true): none

#let role = sys.inputs.at("role", default: "enseignant")
#let my_exam(
  student: none,
  preparation: none,
  passage: none,
  question1: none,
  question2: none,
) = {
  prof_evaluation_page(
    title: [MA_Embreal / 2025-26],
    date: [Examen oral du 23 juin 2026],
    version: role,
    student: student,
    class: [MA_EmbReal],
    teacher: [Serge Ayer/Luca Haab],
    expert: [Luca Haab/Serge Ayer],
    duration: [20 min.],
    preparation: preparation,
    passage: passage,
    question1: question1,
    question2: question2,
  )
}

#let students = toml("students.toml").students
#let questions = toml("questions.toml")
#let qno = counter("question")
#let exam-solution = state("exam-solution", false)
#let exam-name = state("exam", [])
#let exam-date = state("exam-date", [])
#let exam-logo = state("exam-logo", none)

// Enable solution rendering in included question sheets.
#context exam-solution.update(true)
#context exam-name.update([HES-SO Cours MA_EmbReal / 2025-26])
#context exam-date.update([Examen oral du 23 juin 2026])
#context exam-logo.update(image(width: 110mm, "img/mse_logo.svg"))

#let envelope_questions(envelope_no) = {
  let envelopes = questions.envelopes
  envelopes.at(calc.rem-euclid(envelope_no - 1, envelopes.len())).questions
}

#for (idx, s) in students.enumerate() {
  let envelope_no = int(s.enveloppe)
  let envelope = envelope_questions(envelope_no)
  let question1_id = envelope.at(0).trim()
  let question2_id = envelope.at(1).trim()

  my_exam(
    student: [#s.name],
    preparation: [#s.arrival_time],
    passage: [#s.exam_time],
    question1: [#question1_id],
    question2: [#question2_id],
  )
  pagebreak()
  qno.update(envelope_no)
  qno.step(level: 2)
  include ("questions/" + question1_id + ".typ")
  pagebreak()
  qno.step(level: 2)
  include ("questions/" + question2_id + ".typ")
  if idx < students.len() - 1 {
    pagebreak()
  }
}
