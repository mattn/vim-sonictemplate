package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"time"

	"github.com/mattn/go-colorable"
	"github.com/uptrace/bun"
	"github.com/uptrace/bun/dialect/sqlitedialect"
	"github.com/uptrace/bun/driver/sqliteshim"
	"github.com/uptrace/bun/extra/bundebug"
)

type User struct {
	bun.BaseModel `bun:"table:user,alias:u"`

	ID        int64      `bun:"id,pk,autoincrement"`
	Name      string     `bun:"name,notnull"`
	Age       int        `bun:"age,notnull"`
	DeletedAt *time.Time `bun:",soft_delete"`
}

func main() {
	sqldb, err := sql.Open(sqliteshim.ShimName, `database.sqlite?_fk=1`)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(sqliteshim.DriverName())
	db := bun.NewDB(sqldb, sqlitedialect.New())
	db.AddQueryHook(bundebug.NewQueryHook(
		bundebug.WithVerbose(true),
		bundebug.WithWriter(colorable.NewColorableStderr()),
		bundebug.FromEnv("BUNDEBUG"),
	))

	_, err = db.NewCreateTable().Model((*User)(nil)).IfNotExists().Exec(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	_, err = db.NewTruncateTable().Model((*User)(nil)).Exec(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	users := []User{
		{Name: "John", Age: 20},
		{Name: "Mike", Age: 25},
		{Name: "Bob", Age: 32},
	}
	_, err = db.NewInsert().Model(&users).Exec(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	users = nil
	err = db.NewSelect().Model((*User)(nil)).OrderExpr("id ASC").Scan(context.Background(), &users)
	if err != nil {
		log.Fatal(err)
	}
	for _, user := range users {
		fmt.Printf("%+v\n", user)
	}
}
