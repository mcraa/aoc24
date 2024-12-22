import gleam/bool
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

  let fullength = content |> list.length

  let unsafes =
    content
    |> list.filter(fn(x) { is_safe(x) |> bool.negate })

  let safelength = fullength - { unsafes |> list.length }
  let fixables = unsafes |> list.map(is_fixable) |> list.filter(fn(x) { x })

  io.println(fullength |> int.to_string)
  io.println(safelength |> int.to_string)
  io.println({ fixables |> list.length } |> int.to_string)
  io.println("----")
  io.println({ { fixables |> list.length } + safelength } |> int.to_string)
}

pub fn is_fixable(l: List(Int)) -> Bool {
  let len = l |> list.length
  let iter = list.range(0, len)
  let variations =
    iter
    |> list.map(fn(i) {
      [{ l |> list.take(len - { i + 1 }) }, l |> list.drop(len - i)]
      |> list.flatten
    })

  variations
  |> list.any(is_safe)
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
