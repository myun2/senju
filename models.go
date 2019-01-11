package main
import (
  "github.com/jinzhu/gorm"
  _ "github.com/lib/pq"
)

type Task struct {
  gorm.Model
  Title   string `gorm:"not null"`
  Content string
}

type Label struct {
  gorm.Model
  Title   string `gorm:"not null"`
  Comment string
  Color   string `gorm:"size:255"`
}

func DbOpen() *gorm.DB {
  db, _ := gorm.Open("postgres",
          "user=postgres dbname=senju sslmode=disable")
  return db
}

func DbMigrate(db *gorm.DB) {
  db.AutoMigrate(&Task{}, &Label{})
}
