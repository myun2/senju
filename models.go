package main
import (
  "time"
  "github.com/jinzhu/gorm"
  _ "github.com/lib/pq"
)

type Task struct {
  gorm.Model
  Title   string `gorm:"not null"`
  Content string
  TaskDeadline TaskDeadline
  Labels []Label
}

type TaskDeadline struct {
  gorm.Model
  TaskID    uint `gorm:"unique;index;not null"`
  Time time.Time `gorm:"not null"`
}

type Label struct {
  gorm.Model
  Title   string `gorm:"not null"`
  Comment string
  Color   string `gorm:"size:255"`
  Tasks []Task
}

type TaskLabel struct {
  gorm.Model
  TaskID  uint `gorm:"index;not null"`
  LabelID uint `gorm:"index;not null"`
}

////////////////////////////////////////////////////

func DbOpen() *gorm.DB {
  db, _ := gorm.Open("postgres",
          "user=postgres dbname=senju sslmode=disable")
  return db
}

func DbMigrate(db *gorm.DB) {
  db.AutoMigrate(
    &Task{}, &Label{}, &TaskDeadline{}, &TaskLabel{})

  db.Debug().Model(&TaskDeadline{}).AddForeignKey(
    "task_id", "tasks(id)", "RESTRICT", "RESTRICT")

  db.Debug().Model(&TaskLabel{}).AddForeignKey(
    "task_id",  "tasks(id)", "RESTRICT", "RESTRICT")
  db.Debug().Model(&TaskLabel{}).AddForeignKey(
    "label_id", "labels(id)", "RESTRICT", "RESTRICT")
  db.Model(&TaskLabel{}).AddUniqueIndex("idx_task_id_and_label_id", "task_id", "label_id")
}
