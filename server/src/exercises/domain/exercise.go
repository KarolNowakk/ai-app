package domain

type (
	Exercise struct {
		ID       int64
		Text     string
		UseSRS   bool
		Title    string
		Messages []Message
	}

	Message struct {
		Role    string
		Content string
	}

	ExerciseAdapter interface {
		GetAll(userID int64) []Exercise
		Create(userID int64, exercise Exercise) error
		Update(exercise Exercise) error
		Delete(exerciseID int64) error
	}
)
