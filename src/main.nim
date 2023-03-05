import engine

proc main() =
  var e = NewEngine(1280, 768, "Plane Game Go Brrrr 2")
  e.Initialize()
  e.Run()

main()
