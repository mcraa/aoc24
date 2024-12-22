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
    |> list.map(fn(s) {
      string.split(s, " ")
      |> list.map(fn(s) { int.parse(s) |> result.unwrap(0) })
    })
    |> list.map(is_safe)
    |> list.filter(fn(b) { b })
    |> list.length

  io.println(content |> int.to_string)
}

pub fn is_safe(l: List(Int)) -> Bool {
  let diffs =
    l
    |> list.window(2)
    |> list.map(fn(p) {
      { p |> list.at(0) |> result.unwrap(0) }
      - { p |> list.at(1) |> result.unwrap(0) }
    })

  let allincrease =
    diffs
    |> list.all(fn(i) { i < 0 })

  let alldecrease =
    diffs
    |> list.all(fn(i) { i > 0 })

  let allinrange =
    diffs
    |> list.all(fn(i) { i > -4 && i < 4 })

  { alldecrease || allincrease } && allinrange
}
