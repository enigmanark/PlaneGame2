import nimraylib_now
import player as Player
import sprite as Sprite
import map as Map
import bullet as Bullet
import enemy as Enemy
import std/random

type Level* = ref object of RootObj
    gameWidth : float
    gameHeight : float
    player : Player
    map : Map
    mapB : Map
    enemies : seq[Enemy]
    enemy_spawn_timer : float
    enemy_spawn_delay : float

proc Draw*(self : Level) =
    self.map.Draw()
    self.mapB.Draw()
    for b in self.player.bullets.items:
        b.Draw()
    self.player.Draw()
    for e in self.enemies.items:
        e.Draw()

proc Update*(self : var Level, delta : float) =
    self.player.Update(delta)
    self.map.Update(delta, self.mapB)
    self.mapB.Update(delta, self.map)

    if self.map.position.y > self.gameHeight:
        self.map.position.y = self.mapB.position.y - (float(self.mapB.height) * float(self.mapB.tile_size))
        self.map.Generate(self.map.width, self.map.height, self.gameWidth, self.gameHeight)

    if self.mapB.position.y > self.gameHeight:
        self.mapB.position.y = self.map.position.y - (float(self.map.height) * float(self.map.tile_size))
        self.mapB.Generate(self.mapB.width, self.mapB.height, self.gameWidth, self.gameHeight)

    for b in self.player.bullets.mitems:
        b.Update(delta)

    for e in self.enemies.mitems:
        e.Update(delta)

    self.enemy_spawn_timer += delta
    if self.enemy_spawn_timer >= self.enemy_spawn_delay:
        self.enemy_spawn_timer = 0f
        let ex = rand(16..int(self.gameWidth)-16)
        let ey = 0-16
        self.enemies.add(NewEnemy(float(ex), float(ey), 50, "res/plane_2.png", self.gameHeight))

    var clean_enemy_seq : seq[Enemy]
    for e in self.enemies.mitems:
        if e.alive:
            clean_enemy_seq.add(e)
        else:
            e.Clean()
    self.enemies = clean_enemy_seq

proc NewLevel*(gameWidth : float, gameHeight : float) : Level =
    randomize()
    var level = Level()

    level.gameWidth = gameWidth
    level.gameHeight = gameHeight

    let px : float = gameWidth / 2
    let py : float = float(gameHeight - 32)
    var player = NewPlayer(px, py, 100, "res/plane_1.png")
    level.player = player

    level.map = NewMap(16)
    level.map.Generate(30, 17, gameWidth, gameHeight)

    level.mapB = NewMap(16)
    level.mapB.Generate(30, 17, gameWidth, gameHeight)
    level.mapB.position.y = level.map.position.y - (float(level.mapB.height) * float(level.mapB.tile_size))

    level.enemy_spawn_delay = 0.7
    level.enemy_spawn_timer = 0f
    return level
