sc := make(chan os.Signal, 1)
signal.Notify(sc, os.Interrupt)
go func(){
    for sig := range sc {
		{{_cursor_}}
    }
}()
