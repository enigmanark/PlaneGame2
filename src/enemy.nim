import nimraylib_now
import sprite as Sprite
import bullet as Bullet

type EnemyTileData = ref object of RootObj
    x : float
    y : float

let TANK* = EnemyTileData( x : 4, y : 1)
let TURRET1* = EnemyTileData(x : 6, y : 0)

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
    stationary : bool
    data : EnemyTileData

proc NewEnemy*(x : float, y : float, speed : float, path : string, gameHeight : float, hp : int, score : int, delay : float) : Enemy =
    var enemy = Enemy()
    enemy.speed = speed
    enemy.position = Vector2()
    enemy.position.x = x
    enemy.position.y = y
    enemy.texture = loadTexture(path)
    enemy.gameHeight = gameHeight
    enemy.alive = true
    enemy.flash_delay = 0.1
    enemy.hp = hp
    enemy.score = score
    enemy.fire_timer = delay / 2
    enemy.fire_delay = delay
    enemy.data = EnemyTileData()
    enemy.stationary = false
    return enemy

proc NewStationaryEnemy*(x : float, y : float, data : EnemyTileData, gameHeight : float, hp : int, score : int, delay : float) : Enemy =
    var enemy = Enemy()
    enemy.speed = 20
    enemy.position = Vector2()
    enemy.position.x = x
    enemy.position.y = y
    enemy.texture = loadTexture("res/tiles_2.png")
    enemy.gameHeight = gameHeight
    enemy.alive = true
    enemy.flash_delay = 0.1
    enemy.hp = hp
    enemy.score = score
    enemy.fire_timer = delay / 2
    enemy.fire_delay = delay
    enemy.data = data
    enemy.stationary = true
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
    if self.stationary:
        var src_rect = Rectangle()
        src_rect.x = self.data.x * 16
        src_rect.y = self.data.y * 16
        src_rect.width = 16
        src_rect.height = 16
        var dest_rect = Rectangle()
        dest_rect.x = self.position.x
        dest_rect.y = self.position.y
        dest_rect.width = 16
        dest_rect.height = 16

        if self.flashing:
            var blend : BlendMode;
            blend = BlendMode.ADDITIVE
            beginBlendMode(blend)
            drawTexturePro(self.texture, src_rect, dest_rect, Vector2(x: 0, y : 0), 0f, White)
            endBlendMode()
        else:
            drawTexturePro(self.texture, src_rect, dest_rect, Vector2(x: 0, y : 0), 0f, White)
    else:
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

