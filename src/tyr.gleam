import gleam/int
import gleam/io
import gleam/list
import gleam/regex
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let content =
    simplifile.read(from: "input")
    |> result.unwrap("")

  let assert Ok(search) = regex.from_string("mul\\(\\d{1,3}\\,\\d{1,3}\\)")

  let matches = regex.scan(search, content)

  let muls =
    matches
    |> list.map(fn(m) {
      let parts =
        m.content
        |> string.split(",")

      let first =
        parts
        |> list.at(0)
        |> result.unwrap("0")
        |> string.split("(")
        |> list.at(1)
        |> result.unwrap("0")
        |> int.parse
        |> result.unwrap(0)

      let second =
        parts
        |> list.at(1)
        |> result.unwrap("0")
        |> string.split(")")
        |> list.at(0)
        |> result.unwrap("0")
        |> int.parse
        |> result.unwrap(0)

      first * second
    })

  let res =
    muls
    |> list.fold(0, fn(a, b) { a + b })

  io.println(res |> int.to_string)
}
