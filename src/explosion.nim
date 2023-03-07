import nimraylib_now

type Explosion* = ref object of RootObj
    anim_timer : float
    anim_delay : float
    texture : Texture2D
    position : Vector2
    src_rect : Rectangle
    alive* : bool

proc NewExplosion*(x : float, y : float) : Explosion =
    var explosion = Explosion()
    explosion.position = Vector2()
    explosion.position.x = x
    explosion.position.y = y
    explosion.anim_timer = 0f
    explosion.anim_delay = 0.15f
    explosion.texture = loadTexture("res/explosion.png")
    explosion.alive = true
    var src_rect = Rectangle()
    src_rect.x = 0
    src_rect.y = 0
    src_rect.width = 16
    src_rect.height = 16
    explosion.src_rect = src_rect
    playSound(loadSound("res/explosion.wav"))
    return explosion

proc Cleanup*(self : Explosion) =
    unloadTexture(self.texture)

proc Update*(self : Explosion, delta : float) =
    self.anim_timer += delta
    if self.anim_timer >= self.anim_delay:
        if self.src_rect.x == 16:
            self.alive = false
        else:
            self.anim_timer = 0f
            self.src_rect.x = 16

proc Draw*(self : Explosion) =
    var dest_rect = Rectangle()
    dest_rect.x = self.position.x
    dest_rect.y = self.position.y
    dest_rect.width = 32
    dest_rect.height = 32
    drawTexturePro(self.texture, self.src_rect, dest_rect, Vector2(x: 0, y : 0), 0f, White)

