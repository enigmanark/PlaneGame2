import nimraylib_now
import player as Player
import sprite as Sprite
import map as Map

type
    Engine* = object
        windowWidth : int
        windowHeight : int
        gameWidth : int
        gameHeight : int
        screenTitle : string
        camera : Camera2D
        camera_zoom : float

        player : Player
        map : Map

proc NewEngine*(ww : int, wh : int, t : string) : Engine =
    var engine = Engine()
    engine.camera_zoom = 3
    engine.camera = Camera2D()
    engine.camera.zoom = engine.camera_zoom
    engine.windowWidth = ww
    engine.windowHeight = wh
    engine.gameWidth = int(ww / int(engine.camera_zoom))
    engine.gameHeight = int(wh / int(engine.camera_zoom))
    engine.screenTitle = t

    return engine

proc Initialize*(self : var Engine) =
    initWindow(self.windowWidth, self.windowHeight, cstring(self.screenTitle))
    setTargetFPS(60)

    let px : float = self.gameWidth / 2
    let py : float = float(self.gameHeight - 32)
    var player = NewPlayer(px, py, 100, "res/plane_1.png")
    self.player = player

    self.map = NewMap(16)
    self.map.Generate(30, 16)

proc ProcessEvents(self : Engine) =
    discard

proc Update(self : var Engine) =
    let delta = getFrameTime()
    self.player.Update(delta)

proc Render(self : var Engine) =
    beginDrawing()
    clearBackground(Black)

    beginMode2D(self.camera)
    self.map.Draw()
    self.player.Draw()
    endMode2D()

    drawText("Hello World!", 10, 10, 30, White)
    endDrawing()

proc Run*(self : var Engine) =
    while not windowShouldClose():
        self.ProcessEvents()
        self.Update()
        self.Render()
    closeWindow()
