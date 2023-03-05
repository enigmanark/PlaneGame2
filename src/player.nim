import nimraylib_now
import sprite as Sprite
import bullet as Bullet

type Player* = ref object of Sprite
    bullets* : seq[Bullet]
    fire_delay : float
    fire_timer : float
    can_fire : bool

proc NewPlayer*(x : float, y : float, speed : float, path : string) : Player =
    var player = Player()
    player.speed = 150
    player.position = Vector2()
    player.position.x = x
    player.position.y = y
    player.speed = speed
    player.texture = loadTexture(path)
    player.can_fire = true
    player.fire_delay = 0.25
    player.fire_timer = 0f

    return player

proc Update*(self : var Player, delta : float) =
    if not self.can_fire:
        self.fire_timer += delta
        if self.fire_timer >= self.fire_delay:
            self.fire_timer = 0f
            self.can_fire = true

    if isKeyDown(KeyboardKey.A):
        let move_x = -1 * self.speed * delta
        self.position.x += cfloat(move_x)

    if isKeyDown(KeyboardKey.D):
        let move_x = 1 * self.speed * delta
        self.position.x += cfloat(move_x)

    if isKeyDown(KeyboardKey.SPACE):
        if self.can_fire:
            self.can_fire = false
            self.bullets.add(NewBullet(self.position.x, self.position.y, 300, "res/bullet.png"))

    var cleaned_bullets : seq[Bullet]
    for b in self.bullets.items:
        if b.alive:
            cleaned_bullets.add(b)
    self.bullets = cleaned_bullets


