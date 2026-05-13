# Oral Exam Template

`hesso-oral-exam` is a [Typst](https://typst.app/) template for generating oral exam question sheets for HES-SO. It organises questions into numbered envelopes,
supports an optional solution mode, and renders a grid-lined answer space for students.

## Installation

This package is not yet published in the Typst _Universe_, but you can easily install it using the [`utpm`](https://github.com/typst-community/utpm) command line tool.

If you cloned this repository, install the package from the local path:

```bash
git clone https://github.com/hes-so/typst-oral-exam-questions.git
utpm pkg install typst-oral-exam-questions
```

Or install it directly from GitHub:

```bash
utpm pkg install https://github.com/hes-so/typst-oral-exam-questions.git
```

## Usage

### Initialise a new project

Use the Typst template to scaffold a new project:

```bash
typst init @local/hesso-oral-exam my-exam
cd my-exam
```

This creates the following structure:

```
main.typ          # entry point
questions.toml    # envelope / question mapping
img/              # logos and images
questions/        # one .typ file per question
```

### Define your questions

Each question lives in its own file under `questions/`. Use the `question` function:

```typst
#import "@local/hesso-oral-exam:0.2.0": question

#question(
  title: [Question title],
  author: "Teacher Name",
  [
    Question body text.
  ],
  solution: [
    Solution text shown only in solution mode.
  ],
)
```

### Map questions to envelopes

Edit `questions.toml` to group questions into envelopes. Each envelope has a number (`no`) and a list of question file names (without the `.typ` extension):

```toml
envelopes = [
    { no = 1, questions = ["topic_01", "lab_01"] },
    { no = 2, questions = ["topic_02", "lab_02"] },
]
```

### Compile the exam

```bash
# Student version (no solutions)
typst compile main.typ

# Solution version
typst compile --input solution=true main.typ exam-solutions.pdf
```

## Template entry point

`main.typ` wires everything together via the `exam` function:

```typst
#import "@local/hesso-oral-exam:0.2.0": exam, exam-solution

#let data = toml("questions.toml")

#exam(
  name: [Course name / Year],
  date: [Oral exam date],
  logo: image(width: 110mm, "img/logo.svg"),
  envelopes: data.envelopes.map(l => (
    no: l.no,
    questions: l.questions.map(q => include "questions/" + str(q) + ".typ"),
  )),
)
```

## Package information

| Field   | Value                                     |
|---------|-------------------------------------------|
| Name    | `hesso-oral-exam`                         |
| Version | `0.2.1`                                   |
| License | MIT                                       |
| Author  | Jacques Supcik <jacques.supcik@hes-so.ch> |

## License

This project is licensed under the [MIT License](LICENSE).