## 플랫폼 별 Conf 파일 위치

[RabbitMQ Configuration 공식 문서](https://www.rabbitmq.com/configure.html)

|**Platform**|**Default Configuration File Directory**|**Example Configuration File Paths**|
|---|---|---|
|Generic binary package|`$RABBITMQ_HOME/etc/rabbitmq/`|`$RABBITMQ_HOME/etc/rabbitmq/rabbitmq.conf`, `$RABBITMQ_HOME/etc/rabbitmq/advanced.config`|
|Debian and Ubuntu)|/etc/rabbitmq/|/etc/rabbitmq/rabbitmq.conf, /etc/rabbitmq/advanced.config|
|RPM-based Linux|/etc/rabbitmq/|/etc/rabbitmq/rabbitmq.conf, /etc/rabbitmq/advanced.config|
|Windows)|%APPDATA%\RabbitMQ\|%APPDATA%\RabbitMQ\rabbitmq.conf, %APPDATA%\RabbitMQ\advanced.config|
|MacOS Homebrew Formula|`${install_prefix}/etc/rabbitmq/`, and the Homebrew cellar prefix is usually /usr/local|`${install_prefix}/etc/rabbitmq/rabbitmq.conf`, `${install_prefix}/etc/rabbitmq/advanced.config`|
