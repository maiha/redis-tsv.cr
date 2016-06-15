# redis-tsv [![Build Status](https://travis-ci.org/maiha/redis-tsv.cr.svg?branch=master)](https://travis-ci.org/maiha/redis-tsv.cr)

import and export data from Redis in TSV format

```shell
% redis-tsv export > backup.tsv
% redis-tsv import backup.tsv
% redis-tsv keys > keys.list
```

- Crystal: 0.18.0

## Benchmark

- Bench: import, export and keys with count option (default: 1000)

|      | COUNT  | Time     |    QPS | Unix Command                         |
|:-----|-------:|---------:|-------:|:-------------------------------------|
|import| 1000   | 21.9 sec | 457567 | redis-tsv import -c 1000   10M.tsv   |
|      | 10000  | 19.6 sec | 509422 | redis-tsv import -c 10000  10M.tsv   |
|      | 100000 | 16.2 sec | 617951 | redis-tsv import -c 100000 10M.tsv   |
|export| 1000   |465.1 sec |  21500 | redis-tsv export -c 1000   > 10M.tsv |
|      | 10000  | 90.9 sec | 110002 | redis-tsv export -c 10000  > 10M.tsv |
|      | 100000 | 17.2 sec | 582429 | redis-tsv export -c 100000 > 10M.tsv |
|keys  | 1000   | 10.9 sec | 915983 | redis-tsv keys -c 1000   > keys.list |
|      | 10000  |  8.9 sec | 1124260| redis-tsv keys -c 10000  > keys.list |
|      | 100000 |  7.6 sec | 1311586| redis-tsv keys -c 100000 > keys.list |

- CPU: Intel(R) Core(TM) i7-4800MQ CPU @ 2.70GHz
- TSV: `10M.tsv` (10M entries where key = val = "%08d")
```
00000001        00000001
00000002        00000002
...
10000000        10000000
```

## TODO

- [x] `keys` should use `SCAN` rather than `KEYS *`
- [x] `import` should set data by degrees not at once
- [x] `export` should use `SCAN` rather than `KEYS *`
- [x] add spec about bulk operations

## Installation

- needs [Crystal](http://crystal-lang.org/) to compile

```shell
crystal deps  # for the first time only
make
cp bin/redis-tsv ~/bin/
```

## Usage

### Bulk operations

- import

```
redis-tsv import foo.tsv
redis-tsv -d, import foo.csv
```

- export

```
redis-tsv export > foo.tsv
redis-tsv -d, export > foo.csv
```

- keys

```
redis-tsv keys > keys.list
```

#### options

- `-c` grows performance, but uses much memory and locks server.

```
redis-tsv export -c 1000  > foo.tsv  # 1m13s (default)
redis-tsv export -c 10000 > foo.tsv  # 7m28s (6 times faster)
```
(entry count: 10M)


### information

util commands for easy access to INFO

- `count` : show a number of keys
```
% redis-tsv count
10000000
```

- `version` : show the redis version
```
% redis-tsv version
3.0.6
```

- `role` : show the role of replication
```
% redis-tsv role
master
```

- `ping` : execute PING command
```
% redis-tsv ping
PONG
```

- `info` (INFO result itself)
```
% redis-tsv info
# Server
redis_version:3.0.6
redis_git_sha1:00000000
...
```

## Test

- CAUTION: This spec flushes your redis db on `localhost:6379`.

```
% crystal spec
```

## Contributing

1. Fork it ( https://github.com/maiha/redis-tsv.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[maiha]](https://github.com/maiha) maiha - creator, maintainer
