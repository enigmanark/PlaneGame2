import nimraylib_now
import sprite as Sprite

type Enemy* = ref object of Sprite
    gameHeight : float
    alive* : bool
    flashing* : bool
    flash_timer : float
    flash_delay : float
    hp : int

proc NewEnemy*(x : float, y : float, speed : float, path : string, gameHeight : float, hp : int) : Enemy =
    var enemy = Enemy()
    enemy.speed = speed
    enemy.position = Vector2()
    enemy.position.x = x
    enemy.position.y = y
    enemy.speed = speed
    enemy.texture = loadTexture(path)
    enemy.gameHeight = gameHeight
    enemy.alive = true
    enemy.flash_delay = 0.1
    enemy.hp = hp
    return enemy

proc TakeDamage*(self : var Enemy) =
    self.flashing = true
    self.hp -= 1
    if self.hp <= 0:
        self.alive = false

proc Clean*(self : var Enemy) =
    unloadTexture(self.texture)

proc Update*(self : var Enemy, delta : float) =
    if self.flashing:
        self.flash_timer += delta
        if self.flash_timer >= self.flash_delay:
            self.flash_timer = 0f
            self.flashing = false

    self.position.y += 1 * self.speed * delta
    if self.position.y > self.gameHeight:
        self.alive = false

method Draw*(self : Enemy) =
    var rect = Rectangle()
    rect.x = 0
    rect.y = 0
    rect.width = float(self.texture.width)
    rect.height = -float(self.texture.height)
    if self.flashing:
        var blend : BlendMode;
        blend = BlendMode.ADDITIVE
        beginBlendMode(blend)
        drawTextureRec(self.texture, rect, self.position, White)
        endBlendMode()
    else:
        drawTextureRec(self.texture, rect, self.position, White)

