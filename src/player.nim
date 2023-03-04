import nimraylib_now
import sprite as Sprite

type Player* = ref object of Sprite

proc NewPlayer*(x : float, y : float, speed : float, path : string) : Player =
    var player = Player()
    player.position = Vector2()
    player.position.x = x
    player.position.y = y
    player.speed = speed
    player.texture = loadTexture(path)

    return player

proc Update*(self : var Player, delta : float) =
    if isKeyDown(KeyboardKey.A):
        let move_x = -1 * self.speed * delta
        self.position.x += cfloat(move_x)

    if isKeyDown(KeyboardKey.D):
        let move_x = 1 * self.speed * delta
        self.position.x += cfloat(move_x)

