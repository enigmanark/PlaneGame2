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

proc ProcessEvents(self : Engine) =
    discard

proc Update(self : var Engine) =
    let delta = getFrameTime()
    self.level.Update(delta)

proc Render(self : Engine) =
    beginDrawing()
    clearBackground(Black)

    beginMode2D(self.camera)
    self.level.Draw()
    endMode2D()

    let fps = getFPS()
    let fpsText : string = $fps
    drawText(cstring("FPS: " & fpsText), 10, 10, 22, WHITE)
    let sct = $self.level.GetPlayerSore()
    drawText(cstring("Score: " & sct), 10, 40, 22, WHITE)
    endDrawing()

proc Run*(self : var Engine) =
    while not windowShouldClose():
        self.ProcessEvents()
        self.Update()
        self.Render()
    closeWindow()
