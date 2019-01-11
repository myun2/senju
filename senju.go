package main
import "fmt"

func main() {
  db := DbOpen()
  DbMigrate(db)

  fmt.Println("Hello, Senju")
}
