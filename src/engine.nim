import nimraylib_now
import player as Player
import sprite as Sprite
import map as Map

type
    Engine* = object
        windowWidth : int
        windowHeight : int
        gameWidth : float
        gameHeight : float
        screenTitle : string
        camera : Camera2D
        camera_zoom : float

        player : Player
        map : Map
        mapB : Map

proc NewEngine*(ww : int, wh : int, t : string) : Engine =
    var engine = Engine()
    engine.camera_zoom = 3
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

    let px : float = self.gameWidth / 2
    let py : float = float(self.gameHeight - 32)
    var player = NewPlayer(px, py, 100, "res/plane_1.png")
    self.player = player

    self.map = NewMap(16)
    self.map.Generate(30, 17, self.gameWidth, self.gameHeight)

    self.mapB = NewMap(16)
    self.mapB.Generate(30, 17, self.gameWidth, self.gameHeight)
    self.mapB.position.y = self.map.position.y - (float(self.mapB.height) * float(self.mapB.tile_size))

proc ProcessEvents(self : Engine) =
    discard

proc Update(self : var Engine) =
    let delta = getFrameTime()
    self.player.Update(delta)
    self.map.Update(delta, self.mapB)
    self.mapB.Update(delta, self.map)

    if self.map.position.y > self.gameHeight:
        self.map.position.y = self.mapB.position.y - (float(self.mapB.height) * float(self.mapB.tile_size))
        self.map.Generate(self.map.width, self.map.height, self.gameWidth, self.gameHeight)

    if self.mapB.position.y > self.gameHeight:
        self.mapB.position.y = self.map.position.y - (float(self.map.height) * float(self.map.tile_size))
        self.mapB.Generate(self.mapB.width, self.mapB.height, self.gameWidth, self.gameHeight)

proc Render(self : var Engine) =
    beginDrawing()
    clearBackground(Black)

    beginMode2D(self.camera)
    self.map.Draw()
    self.mapB.Draw()
    self.player.Draw()
    endMode2D()

    drawText("FPS: " & $getFPS(), 10, 10, 30, Black)
    endDrawing()

proc Run*(self : var Engine) =
    while not windowShouldClose():
        self.ProcessEvents()
        self.Update()
        self.Render()
    closeWindow()
