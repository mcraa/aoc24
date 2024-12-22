import gleam/bool
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

  let assert Ok(search) =
    regex.from_string(
      "(do\\(\\))|(don\\'t\\(\\))|(mul\\(\\d{1,3}\\,\\d{1,3}\\))",
    )

  let matches = regex.scan(search, content)

  let partitions =
    matches
    |> list.map(fn(n) { n.content })
    |> list.chunk(fn(n) { n |> string.starts_with("do") })

  let first =
    partitions
    |> list.take(1)
    |> list.filter(fn(n) {
      n
      |> list.at(0)
      |> result.unwrap(" ")
      |> string.starts_with("don't")
      |> bool.negate
    })

  let first_mul =
    first
    |> list.map(fn(n) {
      list.map(n, mul_from_string) |> list.fold(0, fn(a, b) { a + b })
    })

  let do_wins =
    partitions
    |> list.drop(1)
    |> list.window_by_2
    |> list.filter(fn(n) {
      n.0 |> list.at(0) |> result.unwrap("") |> string.starts_with("do()")
    })

  let rest =
    do_wins
    |> list.map(fn(n) {
      n.1
      |> list.map(fn(k) { mul_from_string(k) })
      |> list.fold(0, fn(a, b) { a + b })
    })

  let res =
    rest
    |> list.append(first_mul)
    |> list.fold(0, fn(a, b) { a + b })

  io.println(res |> int.to_string)
}

pub fn mul_from_string(ms: String) -> Int {
  let parts =
    ms
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
}
