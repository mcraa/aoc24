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
    |> list.map(fn(n) { string.split(n, "") })

  let height = {
    content |> list.length
  }
  let width = {
    content |> list.at(0) |> result.unwrap([]) |> list.length
  }

  let masks: List(List(#(Int, Int))) = [
    [#(-1, -1), #(0, 0), #(1, 1), #(-1, 1), #(0, 0), #(1, -1)],
  ]

  let iterx = list.range(0, width - 1)
  let itery = list.range(0, height - 1)

  let res =
    itery
    |> list.map(fn(y) {
      iterx
      |> list.map(fn(x) {
        check_masks_from_xy(
          ["MASMAS", "SAMSAM", "MASSAM", "SAMMAS"],
          content,
          masks,
          x,
          y,
        )
      })
    })
    |> list.flatten
    |> list.fold(0, fn(a, b) { a + b })

  io.println(res |> int.to_string)
}

pub fn check_masks_from_xy(
  search: List(String),
  content: List(List(String)),
  masks: List(List(#(Int, Int))),
  x: Int,
  y: Int,
) -> Int {
  masks
  |> list.map(fn(o) {
    o
    |> list.map(fn(c) {
      let #(dx, dy) = c
      content
      |> list.at(y + dy)
      |> result.unwrap([])
      |> list.at(x + dx)
      |> result.unwrap("")
    })
    |> string.concat
  })
  |> list.filter(fn(n) { search |> list.contains(n) })
  |> list.length
}
