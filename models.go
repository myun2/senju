package main
import (
  "time"
  "github.com/jinzhu/gorm"
  _ "github.com/lib/pq"
)

type Project struct {
  gorm.Model
  Name string `gorm:"not null"`
  Tasks []Task
}

type Task struct {
  gorm.Model
  ProjectID     uint `gorm:"index;not null"`
  Title       string `gorm:"not null"`
  Description string
  Priority   float32 `gorm:"not null;default 1"`

  TaskDeadline TaskDeadline
  TaskAssignee TaskAssignee
  TaskEstimate TaskEstimate
  Comments     []Comment
  Labels       []Label
}

type TaskDeadline struct {
  gorm.Model
  TaskID    uint `gorm:"unique;index;not null"`
  Time time.Time `gorm:"not null"`
}

type TaskEstimate struct {
  gorm.Model
  TaskID   uint `gorm:"unique;index;not null"`
  Value float32 `gorm:"not null"`
}

type TaskAssignee struct {
  gorm.Model
  TaskID  uint `gorm:"unique;index;not null"`
  Name  string `gorm:"size:255;not null"`
}

type Comment struct {
  gorm.Model
  TaskID  uint `gorm:"unique;index;not null"`
  Name  string `gorm:"size:255;not null"`
  Content string `gorm:"not null"`
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
    &Project{}, &Task{}, &Label{}, &TaskLabel{}, &Comment{},
    &TaskDeadline{}, &TaskAssignee{}, &TaskEstimate{})

  // Foreign Keys
  db.Model(&Task{}).AddForeignKey(
    "project_id", "projects(id)", "RESTRICT", "RESTRICT")

  db.Model(&TaskDeadline{}).AddForeignKey(
    "task_id",    "tasks(id)", "RESTRICT", "RESTRICT")
  db.Model(&TaskAssignee{}).AddForeignKey(
    "task_id",    "tasks(id)", "RESTRICT", "RESTRICT")
  db.Model(&TaskEstimate{}).AddForeignKey(
    "task_id",    "tasks(id)", "RESTRICT", "RESTRICT")
  db.Model(&Comment{}).AddForeignKey(
    "task_id",    "tasks(id)", "RESTRICT", "RESTRICT")

  db.Model(&TaskLabel{}).AddForeignKey(
    "task_id",    "tasks(id)", "RESTRICT", "RESTRICT")
  db.Model(&TaskLabel{}).AddForeignKey(
    "label_id",   "labels(id)", "RESTRICT", "RESTRICT")

  // Multiple-key Unique Indexes
  db.Model(&TaskAssignee{}).AddUniqueIndex("idx_task_id_and_assignee", "task_id", "name")
  db.Model(&TaskLabel{}   ).AddUniqueIndex("idx_task_id_and_label_id", "task_id", "label_id")
}
