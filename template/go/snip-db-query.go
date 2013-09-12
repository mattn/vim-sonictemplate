rows, err := db.Query("{{_cursor_}}")
if err != nil {
	log.Fatal(err)
}
defer rows.Close()
for rows.Next() {
	var value string
	rows.Scan(&value)
	fmt.Println(value)
}
