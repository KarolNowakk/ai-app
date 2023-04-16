package test_test

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strconv"
	"testing"

	"gotest.tools/v3/assert"

	"app1/src/test"
)

type Exercise struct {
	ID       int    `json:"id"`
	Text     string `json:"text"`
	UseSRS   bool   `json:"use_srs"`
	Title    string `json:"title"`
	Messages []struct {
		Role    string `json:"role"`
		Content string `json:"content"`
	} `json:"messages"`
}

func TestCreateExercise(t *testing.T) {
	exe := generateFakeExercise()
	exe.Title = "create exe titile"
	dtoExercise := encodeExercise(exe)

	createExercise(t, dtoExercise, test.TestApiKey)
	exercises := getAllExercises(t, test.TestApiKey)

	e := findExercise(exe.Title, exercises)
	assert.Check(t, e != nil)
}

func TestUpdateExercise(t *testing.T) {
	exe := generateFakeExercise()
	dtoExercise := encodeExercise(exe)
	createExercise(t, dtoExercise, test.TestApiKey)
	exercises := getAllExercises(t, test.TestApiKey)

	exeUpdated := generateFakeExercise()
	exeUpdated.Title = "Updated Text"
	exeUpdated.ID = exercises[0].ID
	dtoExerciseUpdated := encodeExercise(exeUpdated)
	updateExercise(t, dtoExerciseUpdated, test.TestApiKey)

	exercises = getAllExercises(t, test.TestApiKey)

	e := findExercise(exeUpdated.Title, exercises)
	assert.Check(t, e != nil)
}

func TestDeleteExercise(t *testing.T) {
	exe := generateFakeExercise()
	dtoExercise := encodeExercise(exe)
	createExercise(t, dtoExercise, test.TestApiKey)

	exeUpdated := generateFakeExercise()
	exeUpdated.Title = "Deleted Exe Text"
	dtoExerciseUpdated := encodeExercise(exeUpdated)
	createExercise(t, dtoExerciseUpdated, test.TestApiKey)

	exercises := getAllExercises(t, test.TestApiKey)
	e := findExercise(exeUpdated.Title, exercises)
	deleteExercise(t, strconv.Itoa(e.ID), test.TestApiKey)

	exercises = getAllExercises(t, test.TestApiKey)
	e = findExercise(exeUpdated.Title, exercises)
	assert.Check(t, e == nil)
}

func createExercise(t *testing.T, dtoExercise []byte, token string) {
	req, err := http.NewRequest("POST", "http://localhost:3322/exercises/create",
		bytes.NewBuffer(dtoExercise))
	assert.NilError(t, err)

	req.Header.Set("Authorization", "Bearer "+token)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	defer resp.Body.Close()

	assert.NilError(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func updateExercise(t *testing.T, dtoExercise []byte, token string) {
	req, err := http.NewRequest("POST", "http://localhost:3322/exercises/update",
		bytes.NewBuffer(dtoExercise))
	assert.NilError(t, err)

	req.Header.Set("Authorization", "Bearer "+token)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	defer resp.Body.Close()

	assert.NilError(t, err)
	assert.Equal(t, http.StatusOK, resp.StatusCode)
}

func getAllExercises(t *testing.T, token string) []Exercise {
	getReq, err := http.NewRequest("GET", "http://localhost:3322/exercises/all", nil)
	assert.NilError(t, err)

	getReq.Header.Set("Authorization", "Bearer "+token)
	getReq.Header.Set("Content-Type", "application/json")

	getClient := &http.Client{}
	getResp, err := getClient.Do(getReq)
	assert.NilError(t, err)
	assert.Equal(t, http.StatusOK, getResp.StatusCode)

	body, err := io.ReadAll(getResp.Body)
	exercises, err := unmarshallExercises(body)

	return exercises
}

func deleteExercise(t *testing.T, id, token string) {
	getReq, err := http.NewRequest("GET", "http://localhost:3322/exercises/delete/"+id, nil)
	assert.NilError(t, err)

	getReq.Header.Set("Authorization", "Bearer "+token)
	getReq.Header.Set("Content-Type", "application/json")

	getClient := &http.Client{}
	getResp, err := getClient.Do(getReq)
	assert.NilError(t, err)
	assert.Equal(t, http.StatusOK, getResp.StatusCode)
}

func unmarshallExercises(body []byte) ([]Exercise, error) {
	var exercises []Exercise
	err := json.Unmarshal(body, &exercises)
	if err != nil {
		return nil, err
	}

	return exercises, nil
}

func generateFakeExercise() Exercise {
	var exercise Exercise
	exercise.ID = 0
	exercise.Text = "This is the text for exercise #" + fmt.Sprint(exercise.ID)
	exercise.UseSRS = true
	exercise.Title = "Exercise #" + fmt.Sprint(exercise.ID)
	exercise.Messages = []struct {
		Role    string `json:"role"`
		Content string `json:"content"`
	}{
		{Role: "Instructor", Content: "This is a message from the instructor"},
		{Role: "Student", Content: "This is a message from the student"},
	}
	return exercise
}

func encodeExercise(exercise Exercise) []byte {
	jsonData, _ := json.Marshal(exercise)

	return jsonData
}

func findExercise(title string, exe []Exercise) *Exercise {
	for _, e := range exe {
		if e.Title == title {
			return &e
		}
	}

	return nil
}
