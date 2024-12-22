import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let content =
    simplifile.read(from: "input")
    |> result.unwrap("")
    |> string.split("\n")
    |> list.map(fn(s) { string.split(s, "   ") })

  let first =
    content
    |> list.map(fn(i) {
      i
      |> list.at(0)
      |> result.unwrap("0")
      |> int.parse
      |> result.unwrap(0)
    })
    |> list.sort(int.compare)

  let second =
    content
    |> list.map(fn(i) {
      i
      |> list.at(1)
      |> result.unwrap("0")
      |> int.parse
      |> result.unwrap(0)
    })
    |> list.sort(int.compare)

  let x =
    first
    |> list.zip(second)
    |> list.map(fn(i) {
      case i.0 > i.1 {
        True -> i.0 - i.1
        False -> i.1 - i.0
      }
    })
    |> list.fold(0, fn(a, b) { a + b })

  io.println(
    x
    |> int.to_string,
  )
}
