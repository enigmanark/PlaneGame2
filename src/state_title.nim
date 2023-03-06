import state as State
import nimraylib_now

type TitleState* = ref object of State
    message : int

proc NewTitleState*() : TitleState =
    var s = TitleState()
    s.message = 0
    return s

method Update*(self : TitleState, delta : float) =
    if isKeyPressed(KeyboardKey.ENTER):
        self.message = 1

method Draw*(self : TitleState, camera : Camera2D) =
    drawText("Plane Game Go Brrr 2", 10, 10, 35, White)

method GetMessage*(self : TitleState) : int =
    return self.message
