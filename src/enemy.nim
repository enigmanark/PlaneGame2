import nimraylib_now
import sprite as Sprite

type Enemy* = ref object of Sprite
    gameHeight : float
    alive* : bool

proc NewEnemy*(x : float, y : float, speed : float, path : string, gameHeight : float) : Enemy =
    var enemy = Enemy()
    enemy.speed = speed
    enemy.position = Vector2()
    enemy.position.x = x
    enemy.position.y = y
    enemy.speed = speed
    enemy.texture = loadTexture(path)
    enemy.gameHeight = gameHeight
    enemy.alive = true
    return enemy

proc Clean*(self : var Enemy) =
    unloadTexture(self.texture)

proc Update*(self : var Enemy, delta : float) =
    self.position.y += 1 * self.speed * delta
    if self.position.y > self.gameHeight:
        self.alive = false

method Draw*(self : Enemy) =
    var rect = Rectangle()
    rect.x = 0
    rect.y = 0
    rect.width = float(self.texture.width)
    rect.height = -float(self.texture.height)
    drawTextureRec(self.texture, rect, self.position, White)
