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
    [#(0, 0), #(0, -1), #(0, -2), #(0, -3)],
    [#(0, 0), #(1, -1), #(2, -2), #(3, -3)],
    [#(0, 0), #(1, 0), #(2, 0), #(3, 0)],
    [#(0, 0), #(1, 1), #(2, 2), #(3, 3)],
    [#(0, 0), #(0, 1), #(0, 2), #(0, 3)],
    [#(0, 0), #(-1, 1), #(-2, 2), #(-3, 3)],
    [#(0, 0), #(-1, 0), #(-2, 0), #(-3, 0)],
    [#(0, 0), #(-1, -1), #(-2, -2), #(-3, -3)],
  ]
  // 0    1    2    3    4    5    6    7    x
  // 1 -3,-3           0,-3            3,-3
  // 2      -2,-2      0,-2       2,-2
  // 3           -1,-1 0,-1  1,-1
  // 4  -3,0 -2,0 -1,0(0, 0) 1, 0  2, 0  3,0 
  // 5            -1,1 0, 1  1, 1
  // 6      -2, 2      0, 2       2, 2
  // 7 -3, 3           0, 3            3, 3
  // y

  let iterx = list.range(0, width - 1)
  let itery = list.range(0, height - 1)

  let res =
    itery
    |> list.map(fn(y) {
      iterx
      |> list.map(fn(x) { check_masks_from_xy("XMAS", content, masks, x, y) })
    })
    |> list.flatten
    |> list.fold(0, fn(a, b) { a + b })

  io.println(res |> int.to_string)
}

pub fn check_masks_from_xy(
  search: String,
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
      |> list.at(x + dx)
      |> result.unwrap([])
      |> list.at(y + dy)
      |> result.unwrap("")
    })
    |> string.concat
  })
  |> list.filter(fn(n) { n == search })
  |> list.length
}
