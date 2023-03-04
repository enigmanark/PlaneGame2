import nimraylib_now
import std/random

type TileData = ref object of RootObj
    x : int
    y : int

let grass = TileData(x: 2, y: 1)
let tree2 = TileData(x: 0, y: 1)
let house1 = TileData(x: 6, y: 0)

type Map* = ref object of RootObj
    position* : Vector2
    tileset* : Texture2D
    width* : int
    height* : int
    tile_size* : int
    tiles* : seq[seq[TileData]]

proc NewMap*(tileSize : int) : Map =
    var map = Map()
    map.tile_size = tileSize
    map.position = Vector2()
    map.position.x = 0
    map.position.y = 0
    map.tileset = loadTexture("res/tiles_new.png")

    return map

proc Generate*(self : Map, width : int, height : int) =
    randomize()
    self.width = width
    self.height = height

    var matrix : seq[seq[TileData]]
    var row : seq[TileData]

    matrix = newSeq[seq[TileData]]()

    for i in countup(0, width):
        row = newSeq[TileData]()
        matrix.add(row)
        matrix[i].add(newSeq[TileData](height))

    for i in countup(0, width-1):
        for j in countup(0, height-1):
            let t = rand(1000)
            if t > 990:
                matrix[i][j] = house1
            elif t > 900:
                matrix[i][j] = tree2
            else:
                matrix[i][j] = grass

    self.tiles = matrix

proc Draw*(self : Map) =
    for i in countup(0, self.width - 1):
        for j in countup(0, self.height - 1):
            var td = self.tiles[i][j]

            var src_rect = Rectangle()
            src_rect.x = float(td.x) * float(self.tile_size)
            src_rect.y = float(td.y) * float(self.tile_size)
            src_rect.width = float(self.tile_size)
            src_rect.height = float(self.tile_size)

            var dest_rect = Rectangle()
            dest_rect.x = float(i) * float(self.tile_size)
            dest_rect.y = float(j) * float(self.tile_size)
            dest_rect.width = float(self.tile_size)
            dest_rect.height = float(self.tile_size)

            drawTexturePro(self.tileset, src_rect, dest_rect, Vector2(x:0,y:0), 0f, White)
