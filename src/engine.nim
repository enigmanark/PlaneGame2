import nimraylib_now
import state as State
import state_play as PlayState
import state_title as TitleState
import state_gameover as GameOverState

type
    Engine* = object
        windowWidth : int
        windowHeight : int
        gameWidth : float
        gameHeight : float
        screenTitle : string
        camera : Camera2D
        camera_zoom : float
        currentState : State

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
    self.currentState = NewTitleState()

proc ProcessEvents(self : Engine) =
    discard

proc Update(self : var Engine) =
    let delta = getFrameTime()
    self.currentState.Update(delta)
    let message = self.currentState.GetMessage()
    if message == 1:
        self.currentState = NewPlayState(self.gameWidth, self.gameHeight)
    elif message == 2:
        var playState : PlayState = cast[PlayState](self.currentState)
        self.currentState = NewGameOverState(playState.GetPlayerScore())

proc Render(self : Engine) =
    beginDrawing()
    clearBackground(Black)

    self.currentState.Draw(self.camera)

    endDrawing()

proc ChangeState*(self : var Engine, st : State) =
    self.currentState = st

proc Run*(self : var Engine) =
    while not windowShouldClose():
        self.ProcessEvents()
        self.Update()
        self.Render()
    closeWindow()
