package main

import (
	"net/http"
)

// Method of 'application' struct
func (app *application) healthcheckHandler(w http.ResponseWriter, r *http.Request) {

	data := Envelope{
		"status": "available",
		"system_info": map[string]string{
			"environment": app.config.env,
			"version":     version,
		},
	}

	err := app.writeJSON(w, http.StatusOK, data, nil)
	if err != nil {
		app.serverErrorResponse(w, r, err)
	}
}
