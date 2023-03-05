import nimraylib_now
import sprite as Sprite

type Bullet* = ref object of Sprite
    alive* : bool

proc NewBullet*(x : float, y : float, speed : float, path : string) : Bullet =
    var bullet = Bullet()
    bullet.speed = speed
    bullet.alive = true
    bullet.position = Vector2()
    bullet.position.x = x
    bullet.position.y = y
    bullet.speed = speed
    bullet.texture = loadTexture(path)
    return bullet

proc Update*(self : var Bullet, delta : float) =
    self.position.y -= 1 * self.speed * delta
    if self.position.y <= -30:
        self.alive = false
