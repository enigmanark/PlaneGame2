import nimraylib_now
import sprite as Sprite
import bullet as Bullet

type Enemy* = ref object of Sprite
    gameHeight : float
    alive* : bool
    flashing* : bool
    flash_timer : float
    flash_delay : float
    hp : int
    score : int
    fire_timer : float
    fire_delay : float

proc NewEnemy*(x : float, y : float, speed : float, path : string, gameHeight : float, hp : int, score : int, delay : float) : Enemy =
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
    enemy.score = score
    enemy.fire_timer = 0f
    enemy.fire_delay = delay
    return enemy

proc GetScore*(self : Enemy) : int =
    return self.score

proc TakeDamage*(self : var Enemy) : bool =
    self.flashing = true
    self.hp -= 1
    if self.hp <= 0:
        self.alive = false
        return true
    else:
        return false

proc Clean*(self : var Enemy) =
    unloadTexture(self.texture)

proc Update*(self : var Enemy, delta : float, bullets : var seq[EnemyBullet]) =
    if self.flashing:
        self.flash_timer += delta
        if self.flash_timer >= self.flash_delay:
            self.flash_timer = 0f
            self.flashing = false

    self.position.y += 1 * self.speed * delta
    if self.position.y > self.gameHeight:
        self.alive = false

    self.fire_timer += delta
    if self.fire_timer >= self.fire_delay:
        self.fire_timer = 0f
        var bullet = NewEnemyBullet(self.position.x + 8, self.position.y, 150, "res/bullet.png", self.gameHeight)
        bullets.add(bullet)

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

