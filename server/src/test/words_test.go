package test_test

import (
	"bytes"
	"encoding/json"
	"io"
	"net/http"
	"strconv"
	"testing"

	"gotest.tools/v3/assert"

	"app1/src/test"
)

type Word struct {
	ID         int64   `json:"id"`
	Word       string  `json:"word"`
	LastReview string  `json:"last_review"`
	Interval   int     `json:"interval"`
	EaseFactor float32 `json:"ease_factor"`
	Repetition int     `json:"repetition"`
}

func TestCreateWord(t *testing.T) {
	word := getFakeWord()
	word.Word = "superWord"
	dtoWord := encodeWord(word)

	createWord(t, dtoWord, test.TestApiKey)
	words := getAllWords(t, test.TestApiKey)

	e := findWord(word.Word, words)
	assert.Check(t, e != nil)
}

func TestUpdateWord(t *testing.T) {
	word := getFakeWord()
	dtoWord := encodeWord(word)
	createWord(t, dtoWord, test.TestApiKey)
	words := getAllWords(t, test.TestApiKey)

	wordUpdated := getFakeWord()
	wordUpdated.Word = "updatedText"
	wordUpdated.ID = words[0].ID
	dtoWordUpdated := encodeWord(wordUpdated)
	updateWord(t, dtoWordUpdated, test.TestApiKey)

	words = getAllWords(t, test.TestApiKey)

	e := findWord(wordUpdated.Word, words)
	assert.Check(t, e != nil)
}

func TestDeleteWord(t *testing.T) {
	word := getFakeWord()
	dtoWord := encodeWord(word)
	createWord(t, dtoWord, test.TestApiKey)

	wordUpdated := getFakeWord()
	wordUpdated.Word = "deleteWordText"
	dtoWordUpdated := encodeWord(wordUpdated)
	createWord(t, dtoWordUpdated, test.TestApiKey)

	words := getAllWords(t, test.TestApiKey)
	e := findWord(wordUpdated.Word, words)
	deleteWord(t, strconv.Itoa(int(e.ID)), test.TestApiKey)

	words = getAllWords(t, test.TestApiKey)
	e = findWord(wordUpdated.Word, words)
	assert.Check(t, e == nil)
}

func createWord(t *testing.T, dtoWord []byte, token string) {
	req, err := http.NewRequest("POST", "http://localhost:3322/words/create",
		bytes.NewBuffer(dtoWord))
	assert.NilError(t, err)

	req.Header.Set("Authorization", "Bearer "+token)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	defer resp.Body.Close()

	assert.NilError(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func updateWord(t *testing.T, dtoWord []byte, token string) {
	req, err := http.NewRequest("POST", "http://localhost:3322/words/update",
		bytes.NewBuffer(dtoWord))
	assert.NilError(t, err)

	req.Header.Set("Authorization", "Bearer "+token)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	defer resp.Body.Close()

	assert.NilError(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func getAllWords(t *testing.T, token string) []Word {
	getReq, err := http.NewRequest("GET", "http://localhost:3322/words/all", nil)
	assert.NilError(t, err)

	getReq.Header.Set("Authorization", "Bearer "+token)
	getReq.Header.Set("Content-Type", "application/json")

	getClient := &http.Client{}
	getResp, err := getClient.Do(getReq)
	assert.NilError(t, err)
	assert.Equal(t, http.StatusOK, getResp.StatusCode)

	body, err := io.ReadAll(getResp.Body)
	words, err := unmarshallWords(body)

	return words
}

func deleteWord(t *testing.T, id, token string) {
	getReq, err := http.NewRequest("GET", "http://localhost:3322/words/delete/"+id, nil)
	assert.NilError(t, err)

	getReq.Header.Set("Authorization", "Bearer "+token)
	getReq.Header.Set("Content-Type", "application/json")

	getClient := &http.Client{}
	getResp, err := getClient.Do(getReq)
	assert.NilError(t, err)
	assert.Equal(t, http.StatusOK, getResp.StatusCode)
}

func unmarshallWords(body []byte) ([]Word, error) {
	var words []Word
	err := json.Unmarshal(body, &words)
	if err != nil {
		return nil, err
	}

	return words, nil
}

func getFakeWord() Word {
	return Word{
		ID:         1,
		Word:       "example",
		LastReview: "2023-04-10T10:00:00Z",
		Interval:   5,
		EaseFactor: 2.5,
		Repetition: 3,
	}
}

func encodeWord(word Word) []byte {
	jsonData, _ := json.Marshal(word)

	return jsonData
}

func findWord(word string, words []Word) *Word {
	for _, e := range words {
		if e.Word == word {
			return &e
		}
	}

	return nil
}
