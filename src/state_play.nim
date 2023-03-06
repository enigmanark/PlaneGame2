import state as State
import level as Level
import nimraylib_now

type PlayState* = ref object of State
        level : Level
        bg_health : Texture2D
        health_bar : Texture2D
        message : int

proc NewPlayState*(gameWidth : float, gameHeight : float) : PlayState =
    var play = PlayState()
    play.level = NewLevel(gameWidth, gameHeight)
    play.bg_health = loadTexture("res/health_bar_bg.png")
    play.health_bar = loadTexture("res/health_bar.png")
    play.message = 0
    return play

method Update*(self : PlayState, delta : float) =
    self.level.Update(delta)

    #check player is dead
    if self.level.GetPlayerCurrentHealth() <= 0:
        self.message = 2

proc DrawHealthBar(self : PlayState) =
    let base_scale = 7.0
    let scale_x = 2.0 * base_scale
    let scale_y = 0.7 * base_scale
    let x = 10f
    let y = 10f
    var src_rect = Rectangle()
    src_rect.x = 0
    src_rect.y = 0
    src_rect.width = 16
    src_rect.height = 4
    var dest_rect = Rectangle()
    dest_rect.x = x
    dest_rect.y = y
    dest_rect.width = 16 * scale_x
    dest_rect.height = 4 * scale_y
    drawTexturePro(self.bg_health, src_rect, dest_rect, Vector2(x : 0, y : 0), 0f, White)

    dest_rect.x += 3
    dest_rect.y += 3
    dest_rect.width -= 6
    dest_rect.height -= 6

    dest_rect.width *= self.level.GetPlayerCurrentHealth() / self.level.GetPlayerMaxHealth()
    drawTexturePro(self.health_bar, src_rect, dest_rect, Vector2(x : 0, y : 0), 0f, White)

method Draw*(self : PlayState, camera : Camera2D) =
    beginMode2D(camera)
    self.level.Draw()
    endMode2D()

    let fps = getFPS()
    let fpsText : string = $fps
    drawText(cstring("FPS: " & fpsText), 10, 70, 22, WHITE)
    let sct = $self.level.GetPlayerSore()
    drawText(cstring("Score: " & sct), 10, 40, 22, WHITE)
    self.DrawHealthBar()

method GetMessage*(self : PlayState) : int =
    return self.message
