package domain

type (
	Word struct {
		ID         int64
		Word       string
		LastReview string
		Interval   int
		EaseFactor float32
		Repetition int
	}

	WordAdapter interface {
		GetAll(userID int64) []Word
		Create(userID int64, word Word) error
		Update(word Word) error
		Delete(wordID int64) error
	}
)
