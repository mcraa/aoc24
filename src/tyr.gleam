import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set
import gleam/string
import simplifile

pub fn main() {
  let content =
    simplifile.read(from: "input")
    |> result.unwrap("")
    |> string.split("\n")
    |> list.map(fn(n) { n |> string.split("") })

  let height = content |> list.length
  let width = content |> list.at(0) |> result.unwrap([]) |> list.length

  let iterx = list.range(0, width - 1)
  let itery = list.range(0, height - 1)

  let #(startx, starty) =
    itery
    |> list.map(fn(y) {
      iterx
      |> list.map(fn(x) {
        let item =
          content
          |> list.at(y)
          |> result.unwrap([])
          |> list.at(x)
          |> result.unwrap("")

        case item {
          "^" -> #(x, y)
          "v" -> #(x, y)
          ">" -> #(x, y)
          "<" -> #(x, y)
          _ -> #(-1, -1)
        }
      })
    })
    |> list.flatten
    |> list.filter(fn(f) { { f.0 == -1 } |> bool.negate })
    |> list.at(0)
    |> result.unwrap(#(-1, -1))

  let start_guard =
    content
    |> list.at(starty)
    |> result.unwrap([])
    |> list.at(startx)
    |> result.unwrap("")

  io.println(start_guard)
  io.print(startx |> int.to_string)
  io.print(", ")
  io.println(starty |> int.to_string)

  let #(dirx, diry) = case start_guard {
    "^" -> #(0, -1)
    "v" -> #(0, 1)
    ">" -> #(1, 0)
    "<" -> #(-1, 0)
    _ -> #(0, 0)
  }

  let visited = set.new()

  let res =
    get_out_in_steps(
      content,
      startx,
      starty,
      height,
      width,
      visited,
      dirx,
      diry,
    )

  io.print(res |> int.to_string)
}

pub fn get_out_in_steps(
  map: List(List(String)),
  startx: Int,
  starty: Int,
  height: Int,
  width: Int,
  visited: set.Set(String),
  directionx: Int,
  directiony: Int,
) -> Int {
  let need_to_turn =
    {
      map
      |> list.at(starty + directiony)
      |> result.unwrap([])
      |> list.at(startx + directionx)
      |> result.unwrap("")
    }
    == "#"

  case need_to_turn {
    True -> {
      // io.print(need_to_turn |> bool.to_string)
      io.print(" ")
      io.print(starty |> int.to_string)
      io.print(", ")
      io.println(startx |> int.to_string)
    }
    False -> {
      io.print("")
    }
  }

  let last_step = #(
    { startx >= width },
    { starty >= height },
    { startx <= 0 },
    { starty <= 0 },
    directionx,
    directiony,
    need_to_turn,
  )

  case last_step {
    #(True, _, _, _, _, _, _) -> visited |> set.size
    #(_, True, _, _, _, _, _) -> visited |> set.size
    #(_, _, True, _, _, _, _) -> visited |> set.size
    #(_, _, _, True, _, _, _) -> visited |> set.size

    #(_, _, _, _, _, _, False) ->
      get_out_in_steps(
        map,
        startx + directionx,
        starty + directiony,
        height,
        width,
        visited
          |> set.insert(
            string.concat([
              startx |> int.to_string,
              "-",
              starty |> int.to_string,
            ]),
          ),
        directionx,
        directiony,
      )
    #(_, _, _, _, -1, _, True) ->
      get_out_in_steps(
        map,
        startx,
        starty - 1,
        height,
        width,
        visited
          |> set.insert(
            string.concat([
              startx |> int.to_string,
              "-",
              starty |> int.to_string,
            ]),
          ),
        0,
        -1,
      )
    #(_, _, _, _, 1, _, True) ->
      get_out_in_steps(
        map,
        startx,
        starty + 1,
        height,
        width,
        visited
          |> set.insert(
            string.concat([
              startx |> int.to_string,
              "-",
              starty |> int.to_string,
            ]),
          ),
        0,
        1,
      )
    #(_, _, _, _, _, -1, True) ->
      get_out_in_steps(
        map,
        startx + 1,
        starty,
        height,
        width,
        visited
          |> set.insert(
            string.concat([
              startx |> int.to_string,
              "-",
              starty |> int.to_string,
            ]),
          ),
        1,
        0,
      )
    #(_, _, _, _, _, 1, True) ->
      get_out_in_steps(
        map,
        startx - 1,
        starty,
        height,
        width,
        visited
          |> set.insert(
            string.concat([
              startx |> int.to_string,
              "-",
              starty |> int.to_string,
            ]),
          ),
        -1,
        0,
      )
    // should not happen
    _ -> 0
  }
}
