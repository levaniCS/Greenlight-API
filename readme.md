

# Setup
### Create .envrc file in your root directory and add GREENLIGHT_DB_DSN as property with corresponding db dsn value

## Migrate up
### Go to the /migrations directory

```bash
make up
```

## Create migration
### Go to the /migrations directory

```bash
migrate create -seq -ext .sql create_tokens_table
```



# NOTES:
#### Use the ```go mod tidy```  command to prune any unused dependencies from the go.mod and go.sum files, and add any missing dependencies.

#### Use the ```go mod verify```  command to check that the dependencies on your computer (located in your module cache located at $GOPATH/pkg/mod) haven’t been changed since they were downloaded and that they match the cryptographic hashes in your go.sum file. Running this helps ensure that the dependencies being used are the exact ones that you expect.

#### Use the ```go fmt ./...``` command to format all .go files in the project directory, according to the Go standard. This will reformat files ‘in place’ and output the names of any changed files


#### Use the ```go vet ./...``` command to check all .go files in the project directory. The go vet tool runs a variety of analyzers which carry out static analysis of your code and warn you about things which might be wrong but won’t be picked up by the compiler — such as unreachable code, unnecessary assignments, and badly-formed build tags


#### Use the ```go test -race -vet=off ./...``` command to run all tests in the project directory. By default, go test automatically executes a small subset of the go vet checks before running any tests, so to avoid duplication we’ll use the -vet=off flag to turn this off. The -race flag enables Go’s race detector, which can help pick up certain classes of race conditions while tests are running.

#### Run ``` go env ``` to see all go related variables