# mruby-redmine_activity

Summarize activities on Redmine.

*This tool is an mruby implementation of the [redmine_activity](https://github.com/emsk/redmine_activity).*

## Installation

WIP

## Usage

Print one day's activities:

```sh
$ mruby-redmine_activity get --date=2016-01-23 --url=http://example.com/redmine --login-id=admin --password=pass
Example Project - 機能 #1 (新規): チケット１ (2016-01-23T12:34:56Z)
```

Print today's activities:

```sh
$ mruby-redmine_activity today --url=http://example.com/redmine --login-id=admin --password=pass
Example Project - 機能 #1 (新規): チケット１ (2016-01-23T12:34:56Z)
```

## ENV

| ENV Variable | Description |
| :----------- | :---------- |
| `REDMINE_ACTIVITY_URL` | Redmine URL |
| `REDMINE_ACTIVITY_LOGIN_ID` | Redmine login ID |
| `REDMINE_ACTIVITY_PASSWORD` | Redmine password |

You can execute the command without passing options.

## License

[MIT](LICENSE)
