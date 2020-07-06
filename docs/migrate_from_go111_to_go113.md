# Migrate RAM from go111 to go113

go113 = Go 1.13.8 [reference doc](https://cloud.google.com/functions/docs/concepts/go-runtime#execution_environment)

- `go get golang.org/dl/go1.13.8`
- `go1.13.8 download`
- `go1.13.8 version`
- `go1.13.8 build ram.go`

## File system change

- Source code in no more in `"./"`
- It has moved to `"./serverless_function_source_code/"`
- Error: cannot find anymore `"./settings.yaml"`
  - Impact: every cloud function
  - Fix: add a constant and update code all cloud funtions
- Read the JSON Key file at root broken:
  - Impact
    - listgroups
    - listgroupmembers
    - getgroupmembership
    - convertlog2feed
  - Fix: user the new constant in path

## Environment variable

- `go113 has a limited set of automatically set environment variables as Noed.js !) and subsequent runtimes
- [Reference documentation](https://cloud.google.com/functions/docs/env-var#nodejs_10_and_subsequent_runtimes)
- So what?
  - `FUNCTION_NAME` has disapeard, crashing only `dumpinventory`
    - Fix: use `K_SERVICE` instead of `FUNCTION_NAME`
  - `FUNCTION_IDENTITY` aka the service account name of the function has disapeard, crahsing:
    - Impact
      - listgroups
      - listgroupmembers
      - getgroupmembership
      - convertlog2feed
    - Fix: build the service name account from settings.yaml data

## migrate by micro service

- splitdump DONE
- setfeeds DONE
- dumpinventory DONE
- listgroup DONE
- listgroupmembers DONE
- getgroupsettings DONE
- convertlog2feed DONE
- setlogsinks DONE
- publish2fs DONE
- stream2bq DONE
- upload2gcs DONE
- monitor DONE
