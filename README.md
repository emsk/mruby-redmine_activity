# mruby-redmine_activity

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Summarize one day's activities on Redmine.

*This tool is an mruby implementation of the [redmine_activity](https://github.com/emsk/redmine_activity).*

## Installation

WIP

## Usage

Print today's activities:

```sh
$ mruby-redmine_activity --url=http://example.com/redmine --login-id=admin --password=pass
Example Project - 機能 #2 (新規): チケット２ (山田 花子) (2016-01-23T13:45:12Z)
Example Project - 機能 #1 (新規): チケット１ (田中 太郎) (2016-01-23T12:34:56Z)
```

Print yesterday's activities:

```sh
$ mruby-redmine_activity yesterday --url=http://example.com/redmine --login-id=admin --password=pass
```

Print one day's activities:

```sh
$ mruby-redmine_activity --date=2016-01-01 --url=http://example.com/redmine --login-id=admin --password=pass
```

Run `mruby-redmine_activity help` for more details.

## ENV

| ENV Variable | Description |
| :----------- | :---------- |
| `REDMINE_ACTIVITY_URL` | Redmine URL |
| `REDMINE_ACTIVITY_LOGIN_ID` | Redmine login ID |
| `REDMINE_ACTIVITY_PASSWORD` | Redmine password |

You can execute the command without passing options.

## License

[MIT](LICENSE)
