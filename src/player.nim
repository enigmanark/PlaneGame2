import nimraylib_now
import sprite as Sprite
import bullet as Bullet

type Player* = ref object of Sprite
    bullets* : seq[Bullet]
    fire_delay : float
    fire_timer : float
    can_fire : bool
    score : int
    max_hp* : int
    cur_hp* : int
    flashing : bool
    flash_timer : float
    flash_delay : float
    gameWidth : float

proc NewPlayer*(x : float, y : float, speed : float, path : string, gameWidth : float) : Player =
    var player = Player()
    player.gameWidth = gameWidth
    player.max_hp = 5
    player.cur_hp = player.max_hp
    player.speed = 150
    player.position = Vector2()
    player.position.x = x
    player.position.y = y
    player.speed = speed
    player.texture = loadTexture(path)
    player.can_fire = true
    player.fire_delay = 0.25
    player.fire_timer = 0f
    player.score = 0
    player.flashing = false
    player.flash_delay = 0.1
    player.flash_timer = 0f
    return player

proc GetScore*(self : Player) : int =
    return self.score

proc AddScore*(self : var Player, sc : int) =
    self.score += sc

proc TakeDamage*(self : var Player) =
    self.cur_hp -= 1
    self.flashing = true

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
            self.bullets.add(NewBullet(self.position.x + 8, self.position.y, 400, "res/bullet.png"))

    var cleaned_bullets : seq[Bullet]
    for b in self.bullets.items:
        if b.alive:
            cleaned_bullets.add(b)
    self.bullets = cleaned_bullets

    if self.flashing:
        self.flash_timer += delta
        if self.flash_timer >= self.flash_delay:
            self.flash_timer = 0f
            self.flashing = false

    #clamp
    if self.position.x < 0:
        self.position.x = 0
    elif self.position.x + float(32) > self.gameWidth:
        self.position.x = self.gameWidth - 32

method Draw*(self : Player) =
    if self.flashing:
        var rect = Rectangle()
        rect.x = 0
        rect.y = 0
        rect.width = float(self.texture.width)
        rect.height = -float(self.texture.height)
        var blend : BlendMode;
        blend = BlendMode.ADDITIVE
        beginBlendMode(blend)
        drawTextureRec(self.texture, rect, self.position, White)
        endBlendMode()
    else:
        drawTexture(self.texture, cint(self.position.x), cint(self.position.y), White)
