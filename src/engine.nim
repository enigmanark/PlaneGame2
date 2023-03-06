import nimraylib_now
import level as Level

type
    Engine* = object
        windowWidth : int
        windowHeight : int
        gameWidth : float
        gameHeight : float
        screenTitle : string
        camera : Camera2D
        camera_zoom : float
        level : Level
        bg_health : Texture2D
        health_bar : Texture2D

proc NewEngine*(ww : int, wh : int, t : string) : Engine =
    var engine = Engine()
    engine.camera_zoom = 2.5
    engine.camera = Camera2D()
    engine.camera.zoom = engine.camera_zoom
    engine.windowWidth = ww
    engine.windowHeight = wh
    engine.gameWidth = float(float(ww) / (engine.camera_zoom))
    engine.gameHeight = float(float(wh) / (engine.camera_zoom))
    engine.screenTitle = t
    return engine

proc Initialize*(self : var Engine) =
    initWindow(self.windowWidth, self.windowHeight, cstring(self.screenTitle))
    setTargetFPS(60)
    self.level = NewLevel(self.gameWidth, self.gameHeight)
    self.bg_health = loadTexture("res/health_bar_bg.png")
    self.health_bar = loadTexture("res/health_bar.png")

proc ProcessEvents(self : Engine) =
    discard

proc Update(self : var Engine) =
    let delta = getFrameTime()
    self.level.Update(delta)

proc DrawHealthBar(self : Engine) =
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

proc Render(self : Engine) =
    beginDrawing()
    clearBackground(Black)

    beginMode2D(self.camera)
    self.level.Draw()
    endMode2D()

    let fps = getFPS()
    let fpsText : string = $fps
    drawText(cstring("FPS: " & fpsText), 10, 70, 22, WHITE)
    let sct = $self.level.GetPlayerSore()
    drawText(cstring("Score: " & sct), 10, 40, 22, WHITE)
    self.DrawHealthBar()
    endDrawing()

proc Run*(self : var Engine) =
    while not windowShouldClose():
        self.ProcessEvents()
        self.Update()
        self.Render()
    closeWindow()
