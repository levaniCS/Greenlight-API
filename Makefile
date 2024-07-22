include .envrc

# ==================================================================================== #
# HELPERS
# ==================================================================================== #
# Command: make help
# MAKEFILE_LIST is a special variable which contains the name of the makefile being parsed by make
# PHONY helps to print descriptions and commands for 'make help' command

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n s/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'



# Asks user 'are you sure?' Y\N
# Reads answer string & checks if answer is 'Y' returns
# true in other case: false ([ $${ans:-N} = y ])

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

## run/api: run the cmd/api application
.PHONY: run/api
run/api:
	go run ./cmd/api -db-dsn=${GREENLIGHT_DB_DSN}


## db/psql: connect to the database using psql
.PHONY: db/psql
db/psql:
	psql ${GREENLIGHT_DB_DSN}

## db/migrations/new name=$1: create a new database migration
.PHONY: db/migrations/new
db/migrations/new:
	@echo 'Creating migration files for ${name}...'
	migrate create -seq -ext .sql -dir=./migrations ${name}

## db/migrations/up: apply all up database migrations
.PHONY: db/migrations/up
db/migrations/up: confirm
	@echo 'Running up migrations...'
	migrate -path ./migrations -database ${GREENLIGHT_DB_DSN} up


# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #
## audit: tidy dependencies and format, vet and test all code
.PHONY: audit
audit:
	@echo 'Formatting code...'
	go fmt ./...
	@echo 'Vetting code...'
	go vet ./...
	staticcheck ./...
	@echo 'Running tests...'
	go test -race -vet=off ./...



# The go mod tidy command will make sure the go.mod and go.sum files list all the
# necessary dependencies for our project (and no unnecessary ones).
# The go mod verify command will verify that the dependencies stored in your module
# cache (located on your machine at $GOPATH/pkg/mod) match the cryptographic hashes in
# the go.sum file.
# The go mod vendor command will then copy the necessary source code from your
# module cache into a new vendor directory in your project root.

## vendor: tidy and vendor dependencies
.PHONY: vendor
vendor:
	@echo 'Tidying and verifying module dependencies...'
	go mod tidy
	go mod verify
	@echo 'Vendoring dependencies...'
	go mod vendor



# ==================================================================================== #
# BUILD
# ==================================================================================== #

current_time = $(shell date --iso-8601=seconds)
git_description = $(shell git describe --always --dirty --tags --long)
linker_flags = '-s -X main.buildTime=${current_time} -X main.version=${git_description}'

## build/api: build the cmd/api application
.PHONY: build/api
build/api:
@echo 'Building cmd/api...'
go build -ldflags=${linker_flags} -o=./bin/api ./cmd/api
GOOS=linux GOARCH=amd64 go build -ldflags=${linker_flags} -o=./bin/linux_amd64/api ./cmd/api