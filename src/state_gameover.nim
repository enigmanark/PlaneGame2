import state as State
import nimraylib_now

type GameOverState* = ref object of State
    message : int
    score : string
    windowWidth : int
    windowHeight : int

proc NewGameOverState*(score : int, windowWidth : int, windowHeight : int) : GameOverState =
    var s = GameOverState()
    s.score = $score
    s.message = 0
    s.windowWidth = windowWidth
    s.windowHeight = windowHeight
    return s

method Update*(self : GameOverState, delta : float) =
    if isKeyPressed(KeyboardKey.ENTER):
        self.message = 1

method Draw*(self : GameOverState, camera : Camera2D) =
    let gameover : cstring = "Game Over"
    var texOffset = cint(measureText(gameover, 45) / 2)
    drawText(gameover, cint(self.windowWidth / 2) - texOffset, cint(self.windowHeight / 2) - 20, 45, White)

    let scoreText : cstring = cstring("Score : " & self.score)
    texOffset = cint(measureText(scoreText, 35) / 2)
    drawText(scoreText, cint(self.windowWidth / 2) - texOffset, cint(self.windowHeight / 2) + 40, 35, White)

method GetMessage*(self : GameOverState) : int =
    return self.message
