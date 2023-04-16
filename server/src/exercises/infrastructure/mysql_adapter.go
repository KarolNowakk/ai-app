package infrastructure

import (
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"

	_ "github.com/go-sql-driver/mysql"

	"app1/src/db/infrastructure"
	"app1/src/exercises/domain"
)

type Message struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type MySQLAdapter struct {
	db      *sql.DB
	manager infrastructure.ConnManager
}

func ProvideExerciseAdapter(manager infrastructure.ConnManager) domain.ExerciseAdapter {
	var err error
	adapter := &MySQLAdapter{
		manager: manager,
	}
	adapter.db, err = manager.GetConnection()
	if err != nil {
		panic("database connection error: " + err.Error())
	}

	return adapter
}

const getAllQuery = "SELECT id, text, use_srs, title, messages FROM exercises WHERE userID = ?"

func (a *MySQLAdapter) GetAll(userID int64) []domain.Exercise {
	exercises := make([]domain.Exercise, 0)

	rows, err := a.db.Query(getAllQuery, userID)
	if err != nil {
		return exercises
	}
	defer rows.Close()

	for rows.Next() {
		var (
			id       int64
			text     string
			useSRS   bool
			title    string
			messages string
		)

		if err := rows.Scan(&id, &text, &useSRS, &title, &messages); err != nil {
			return exercises
		}

		exercise := domain.Exercise{
			ID:       id,
			Text:     text,
			UseSRS:   useSRS,
			Title:    title,
			Messages: mapMessages(messages),
		}

		exercises = append(exercises, exercise)
	}

	return exercises
}

func mapMessages(msg string) []domain.Message {
	var messages []Message
	if err := json.Unmarshal([]byte(msg), &messages); err != nil {
		fmt.Println("Error unmarshalling JSON:", err)
		return nil
	}

	domainMessages := make([]domain.Message, len(messages))
	for i, message := range messages {
		domainMessages[i].Role = message.Role
		domainMessages[i].Content = message.Content
	}

	return domainMessages
}

const createQuery = "INSERT INTO exercises (id, userID, text, use_srs, title, messages) VALUES (?, ?, ?, ?, ?, ?)"

func (a *MySQLAdapter) Create(userID int64, exercise domain.Exercise) error {
	messages := messagesToJSON(exercise.Messages)

	_, err := a.db.Exec(
		createQuery,
		exercise.ID,
		userID,
		exercise.Text,
		exercise.UseSRS, exercise.Title, messages,
	)

	return err
}

const updateQuery = "UPDATE exercises SET text = ?, use_srs = ?, title = ?, messages = ? WHERE id = ?"

func (a *MySQLAdapter) Update(exercise domain.Exercise) error {
	messages := messagesToJSON(exercise.Messages)

	_, err := a.db.Exec(updateQuery,
		exercise.Text,
		exercise.UseSRS,
		exercise.Title,
		messages,
		exercise.ID,
	)

	return err
}

const deleteQuery = "DELETE FROM exercises WHERE id = ?"

func (a *MySQLAdapter) Delete(exerciseID int64) error {
	res, err := a.db.Exec(deleteQuery, exerciseID)
	if err != nil {
		return err
	}

	count, err := res.RowsAffected()
	if err != nil {
		return err
	}

	if count == 0 {
		return errors.New("exercise not found")
	}

	return nil
}

func messagesToJSON(messages []domain.Message) string {
	dtoMsg := make([]Message, 0)

	for _, msg := range messages {
		dtoMsg = append(dtoMsg, Message{
			Role:    msg.Role,
			Content: msg.Content,
		})
	}

	jsonData, _ := json.Marshal(dtoMsg)
	return string(jsonData)
}
