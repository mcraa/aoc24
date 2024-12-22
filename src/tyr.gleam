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

  let left =
    content
    |> list.map(fn(i) {
      i
      |> list.at(0)
      |> result.unwrap("0")
      |> int.parse
      |> result.unwrap(0)
    })
    |> list.sort(int.compare)

  let right =
    content
    |> list.map(fn(i) {
      i
      |> list.at(1)
      |> result.unwrap("0")
      |> int.parse
      |> result.unwrap(0)
    })
    |> list.sort(int.compare)

  let simfirst =
    left
    |> list.map(fn(a) {
      {
        list.filter(right, fn(b) { a == b })
        |> list.length
      }
      * a
    })
    |> list.fold(0, fn(a, b) { a + b })

  io.println(
    simfirst
    |> int.to_string,
  )
}
