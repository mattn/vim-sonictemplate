db, err := sql.Open("{{_cursor_}}", "")
if err != nil {
	log.Fatal(err)
}
defer db.Close()
