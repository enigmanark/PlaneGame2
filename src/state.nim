import nimraylib_now
type State* = ref object of RootObj

method Update*(self : State, delta : float) {.base.} =
    discard

method Draw*(self : State, camera : Camera2D) {.base.} =
    discard

method GetMessage*(self : State) : int {.base.} =
    discard
