import gleam/bool
import gleam/dict
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
    |> string.split("\n\n")

  let rules =
    content
    |> list.at(0)
    |> result.unwrap("")
    |> string.split("\n")
    |> list.map(fn(i) { i |> string.split("|") })
    |> list.group(fn(a) { a |> list.at(0) |> result.unwrap("") })

  let pages =
    content
    |> list.at(1)
    |> result.unwrap("")
    |> string.split("\n")
    |> list.map(fn(n) {
      n
      |> string.split(",")
      |> list.map(fn(i) { int.parse(i) |> result.unwrap(0) })
    })

  let iterate = list.range(0, { { pages |> list.length } - 1 })
  let goodrows =
    iterate
    |> list.filter(fn(i) {
      let row =
        pages
        |> list.at(i)
        |> result.unwrap([])

      let loop = list.range(0, { row |> list.length } - 1)

      let goodpages =
        loop
        |> list.filter(fn(l) {
          let rest =
            row
            |> list.take(l)

          let lts =
            row
            |> list.at(l)
            |> result.unwrap(0)
            |> get_lts_from_rules_for_num(rules)

          rest
          |> list.all(fn(i) { lts |> list.contains(i) |> bool.negate })
        })
        |> list.length

      goodpages == { loop |> list.length }
    })

  let res = goodrows |> get_middles_sum(pages)

  io.println(res |> int.to_string)
}

pub fn get_middles_sum(only: List(Int), pages: List(List(Int))) -> Int {
  only
  |> list.map(fn(n) {
    let row =
      pages
      |> list.at(n)
      |> result.unwrap([])

    let mid = {
      { row |> list.length } / 2
    }

    row |> list.at(mid) |> result.unwrap(0)
  })
  |> list.fold(0, fn(a, b) { a + b })
}

pub fn get_lts_from_rules_for_num(
  num: Int,
  rules: dict.Dict(String, List(List(String))),
) -> List(Int) {
  rules
  |> dict.get(num |> int.to_string)
  |> result.unwrap([])
  |> list.map(fn(n) {
    n |> list.at(1) |> result.unwrap("") |> int.parse |> result.unwrap(0)
  })
}
