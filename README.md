# redis-tsv [![Build Status](https://travis-ci.org/maiha/redis-tsv.cr.svg?branch=master)](https://travis-ci.org/maiha/redis-tsv.cr)

# redis-tsv

import and export data from Redis in TSV format

```shell
% redis-tsv export > backup.tsv
% redis-tsv import backup.tsv
```

## TODO

- [x] `keys` should use `SCAN` rather than `KEYS *`
- [ ] `import` should use `SCAN` rather than `KEYS *`
- [x] `export` should use `SCAN` rather than `KEYS *`

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

- `-c` grows performance, but uses much memory resource.

```
redis-tsv export -c 1000  > foo.tsv  # 1m13s (default)
redis-tsv export -c 10000 > foo.tsv  # 7m28s (6 times faster)
```
(entry count: 10M)


### information

util commands for easy access to INFO

- `count` : show a number of keys
- `version` : show the redis version
- `ping` : execute PING command
- `info` (INFO result itself)

## NOTE

- In current version, KEYS command is used. Please be careful in prod.

## Contributing

1. Fork it ( https://github.com/maiha/redis-tsv.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[maiha]](https://github.com/maiha) maiha - creator, maintainer
