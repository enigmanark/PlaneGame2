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
    enemyBullets : seq[EnemyBullet]

proc Draw*(self : Level) =
    self.map.Draw()
    self.mapB.Draw()
    for eb in self.enemyBullets.mitems:
        eb.Draw()
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

    #update player bullets
    for b in self.player.bullets.mitems:
        b.Update(delta)

    #update enemies
    for e in self.enemies.mitems:
        e.Update(delta, self.enemyBullets)

    #update enemy bullets
    for eb in self.enemyBullets.mitems:
        eb.Update(delta)

    self.enemy_spawn_timer += delta
    if self.enemy_spawn_timer >= self.enemy_spawn_delay:
        self.enemy_spawn_timer = 0f
        let et = rand(1..6)
        let ex = rand(16..int(self.gameWidth)-16)
        let ey = 0-16
        if et == 1:
            self.enemies.add(NewEnemy(float(ex), float(ey), 42, "res/plane_2.png", self.gameHeight, 3, 20, 3.5))
        elif et == 2:
            self.enemies.add(NewEnemy(float(ex), float(ey), 37, "res/plane_4.png", self.gameHeight, 2, 15, 3.5))
        elif et == 3:
            self.enemies.add(NewEnemy(float(ex), float(ey), 55, "res/plane_5.png", self.gameHeight, 1, 30, 2.5))
        elif et == 4:
            self.enemies.add(NewEnemy(float(ex), float(ey), 30, "res/plane_3.png", self.gameHeight, 2, 10, 2.75))
        elif et == 5:
            self.enemies.add(NewStationaryEnemy(float(ex), float(ey), TURRET1, self.gameHeight, 4, 40, 3.0))
        else:
            self.enemies.add(NewStationaryEnemy(float(ex), float(ey), TANK, self.gameHeight, 5, 50, 3.0))

    #cleanup dead enemies
    var clean_enemy_seq : seq[Enemy]
    for e in self.enemies.mitems:
        if e.alive:
            clean_enemy_seq.add(e)
        else:
            e.Clean()
    self.enemies = clean_enemy_seq

    #check bullet collisions with enemies
    for b in self.player.bullets.items:
        for e in self.enemies.mitems:
            let rect = b.GetBoundingBox()
            if e.Collides(rect):
                b.alive = false
                if e.TakeDamage():
                    self.player.AddScore(e.GetScore())

    #check bullet collision with player
    for eb in self.enemyBullets.mitems:
        let player_rect = self.player.GetBoundingBox()
        if eb.Collides(player_rect):
            eb.alive = false
            self.player.TakeDamage()

    #cleanup dead enemy bullets
    var clean_enemy_bullet_seq : seq[EnemyBullet]
    for eb in self.enemyBullets.mitems:
        if eb.alive:
            clean_enemy_bullet_seq.add(eb)
        else:
            eb.Clean()
    self.enemyBullets = clean_enemy_bullet_seq

proc NewLevel*(gameWidth : float, gameHeight : float) : Level =
    randomize()
    var level = Level()

    level.gameWidth = gameWidth
    level.gameHeight = gameHeight

    let t_size = 16
    let width = 32
    let height = 20

    let px : float = gameWidth / 2
    let py : float = float(gameHeight - 32)
    var player = NewPlayer(px, py, 180, "res/plane_1.png", gameWidth)
    level.player = player

    level.map = NewMap(t_size)
    level.map.Generate(width, height, gameWidth, gameHeight)

    level.mapB = NewMap(t_size)
    level.mapB.Generate(width, height, gameWidth, gameHeight)
    level.mapB.position.y = level.map.position.y - (float(level.mapB.height) * float(level.mapB.tile_size))

    level.enemy_spawn_delay = 0.8
    level.enemy_spawn_timer = 0f
    return level

proc GetPlayerSore*(self : Level) : int =
    return self.player.GetScore()

proc GetPlayerPosition*(self : Level) : Vector2 =
    return self.player.position

proc GetPlayerCurrentHealth*(self : Level) : int =
    return self.player.cur_hp

proc GetPlayerMaxHealth*(self : Level) : int =
    return self.player.max_hp
