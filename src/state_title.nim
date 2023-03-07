import state as State
import nimraylib_now

type TitleState* = ref object of State
    message : int
    gameWidth : float
    gameHeight : float

proc NewTitleState*(gameWidth : float, gameHeight : float) : TitleState =
    var s = TitleState()
    s.message = 0
    s.gameWidth = gameWidth
    s.gameHeight = gameHeight
    return s

method Update*(self : TitleState, delta : float) =
    if isKeyPressed(KeyboardKey.ENTER):
        self.message = 1

method Draw*(self : TitleState, camera : Camera2D) =
    let title : cstring = "Plane Game Go Brrr 2"
    let texOffset = cint(measureText(title, 35) / 2)
    drawText(title, cint(self.gameWidth / 2) - texOffset, cint(self.gameHeight / 2) - 20, 35, White)

method GetMessage*(self : TitleState) : int =
    return self.message
