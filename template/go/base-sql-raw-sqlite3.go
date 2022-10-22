package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/mattn/go-sqlite3"
)

func main() {
	db, err := sql.Open("sqlite3", "database.sqlite")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	_, err = db.Exec(`CREATE TABLE IF NOT EXISTS user(id integer primary key autoincrement, name text, age integer)`)
	if err != nil {
		log.Fatal(err)
	}

	_, err = db.Exec(`DELETE FROM user`)
	if err != nil {
		log.Fatal(err)
	}
	_, err = db.Exec(`DELETE FROM sqlite_sequence WHERE name = 'user'`)
	if err != nil {
		log.Fatal(err)
	}
	_, err = db.Exec(`INSERT INTO user(name, age) values('John', 20), ('Mike', 25), ('Bob', 32)`)
	if err != nil {
		log.Fatal(err)
	}

	rows, err := db.Query(`SELECT id, name, age FROM user ORDER BY id`)
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	for rows.Next() {
		var id int
		var name string
		var age int
		err = rows.Scan(&id, &name, &age)
		if err != nil {
			log.Fatal(err)
		}
		fmt.Println(id, name, age)
	}
}
