import nimraylib_now

type Sprite* = ref object of RootObj
    position* : Vector2
    speed* : float
    texture* : Texture2D

proc NewSprite*(x : float, y : float, speed : float, path : string) : Sprite =
    var sprite = Sprite()
    sprite.position = Vector2()
    sprite.position.x = x
    sprite.position.y = y
    sprite.speed = speed
    sprite.texture = loadTexture(path)

    return sprite

method Update*(self : Sprite, delta : float) {.base.} =
    discard

method Draw*(self : Sprite) {.base.} =
    drawTexture(self.texture, cint(self.position.x), cint(self.position.y), White)

