package infrastructure

import (
	"database/sql"
	"errors"
	"fmt"

	_ "github.com/go-sql-driver/mysql"

	"app1/src/db/infrastructure"
	"app1/src/words/domain"
)

type MySQLWordAdapter struct {
	db      *sql.DB
	manager infrastructure.ConnManager
}

var (
	ErrNoRowsAffected = errors.New("no rows affected")
)

func ProvideMySQLWordAdapter(manager infrastructure.ConnManager) domain.WordAdapter {
	var err error
	adapter := &MySQLWordAdapter{
		manager: manager,
	}
	adapter.db, err = manager.GetConnection()
	if err != nil {
		panic("database connection error: " + err.Error())
	}

	return adapter
}

const getAllQuery = "SELECT id, word, last_review, `interval`, ease_factor, repetition FROM words WHERE user_id = ?"

func (m *MySQLWordAdapter) GetAll(userID int64) []domain.Word {
	rows, err := m.db.Query(getAllQuery, userID)
	if err != nil {
		fmt.Println(err)
		return nil
	}
	defer rows.Close()

	var words []domain.Word
	for rows.Next() {
		var word domain.Word
		err := rows.Scan(&word.ID, &word.Word, &word.LastReview, &word.Interval, &word.EaseFactor, &word.Repetition)
		if err != nil {
			fmt.Println(err)
			return nil
		}
		words = append(words, word)
	}

	return words
}

const createQuery = "INSERT INTO words (word, user_id, last_review, `interval`, ease_factor, repetition) VALUES (?, ?, ?, ?, ?, ?)"

func (m *MySQLWordAdapter) Create(userID int64, word domain.Word) error {
	result, err := m.db.Exec(createQuery, word.Word, userID, word.LastReview, word.Interval, word.EaseFactor, word.Repetition)
	if err != nil {
		return err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rowsAffected == 0 {
		return ErrNoRowsAffected
	}

	return nil
}

const updateQuery = "UPDATE words SET word = ?, last_review = ?, `interval` = ?, ease_factor = ?, repetition = ? WHERE id = ?"

func (m *MySQLWordAdapter) Update(word domain.Word) error {
	result, err := m.db.Exec(updateQuery, word.Word, word.LastReview, word.Interval, word.EaseFactor, word.Repetition, word.ID)
	if err != nil {
		return err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rowsAffected == 0 {
		return ErrNoRowsAffected
	}

	return nil
}

const deleteQuery = "DELETE FROM words WHERE id = ?"

func (m *MySQLWordAdapter) Delete(wordID int64) error {
	result, err := m.db.Exec(deleteQuery, wordID)
	if err != nil {
		return err
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}

	if rowsAffected == 0 {
		return ErrNoRowsAffected
	}

	return nil
}
