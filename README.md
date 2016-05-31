# redis-tsv [![Build Status](https://travis-ci.org/maiha/redis-tsv.cr.svg?branch=master)](https://travis-ci.org/maiha/redis-tsv.cr)

## Installation

- needs [Crystal](http://crystal-lang.org/) to compile

```shell
make
cp bin/redis-tsv ~/bin/
```

## Usage

### migration

- import

```
redis-tsv import foo.tsv
```

- export

```
redis-tsv export > foo.tsv
```

### information

util commands for easy access to INFO

- `count` : show a number of keys
- `version` : show the redis version
- `keys` : show all keys by using KEYS (be careful!)
- `ping` : execute PING command
- `info` (INFO result itself)

## NOTE

- In current version, KEYS command is used. Please be careful in prod.

## Contributing

1. Fork it ( https://github.com/maiha/redis-tsv/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[maiha]](https://github.com/maiha) maiha - creator, maintainer
