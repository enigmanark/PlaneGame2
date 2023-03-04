import engine

proc main() =
  var e = NewEngine(1366, 768, "Plane Game Go Brrrr 2")
  e.Initialize()
  e.Run()

main()
