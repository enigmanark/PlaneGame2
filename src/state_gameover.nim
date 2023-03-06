import state as State
import nimraylib_now

type GameOverState* = ref object of State
    message : int

proc NewGameOverState*() : GameOverState =
    var s = GameOverState()
    s.message = 0
    return s

method Update*(self : GameOverState, delta : float) =
    if isKeyPressed(KeyboardKey.ENTER):
        self.message = 1

method Draw*(self : GameOverState, camera : Camera2D) =
    drawText("Game Over", 10, 10, 35, White)

method GetMessage*(self : GameOverState) : int =
    return self.message
