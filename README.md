# docker-redis
## 快速启动

1、使用编译方式启动

**强烈建议添加 `--privileged` 参数来启用，因为本容器在启动时会有几个内核参数的修改的动作。**

```bash
$ dock build -t waltonmax/redis:3.2.5 .
$ docker run -d --name redis --privileged -p 6379:6379 waltonmax/redis:3.2.5
```

2、通过pull 启动

```bash
$ docker run -d --name redis --privileged -p 6379:6379 waltonmax/redis:3.2.5
```

3、通过docker-compose来实现快速启动
```bash
$ curl -LkO github.com/waltonmax/docker-redis/raw/master/docker-compose.yml
$ docker-compose up -d
```



# 启动Sentinel

```bash
$ docker run -d --name redis --privileged --network host -e SENTINEL=enable waltonmax/redis:3.2.5-sentinel
```



# 可用变量

| 变量名                       | 变量默认值                     | 说明                                       |
| :------------------------ | ------------------------- | ---------------------------------------- |
| DEFAULT_CONF              | enable                    | 是否试用容器的默认配置文件                            |
| REDIS_PASS                | 16位随机生成                   | 当DEFAULT_CONF为非enable值时，此值不生效            |
| CONFIG_FILE               | /etc/redis.conf           | redis配置文件路径                              |
| SENTINEL_FILE             | /etc/sentinel.conf        | sentinel配置文件路径                           |
| SUPERVISORCTL_NAME        | admin                     | supervisorctl用户名                         |
| SUPERVISORCTL_PASS        | admin                     | supervisorctl密码                          |
| SENTINEL                  |                           | 当变量值为enable时则启动Sentinel                  |
| S_PORT                    | 26379                     | sentinel监听端口                             |
| S_BIND                    | 0.0.0.0                   | sentinel监听地址                             |
| S_DATA                    | /data/redis               | sentinel数据路径                             |
| S_AUTH_PASS               | dwhd                      | sentinel密码                               |
| S_MASTER_NAME             | master6379                | sentinel定义集群名称                           |
| S_PIDFILE                 | /var/run/sentinel6379.pid | sentinelPID文件路径                          |
| S_LOGFILE                 | /var/log/sentinel6379.log | sentinel日志文件路径                           |
| S_MASTER_IP               | 127.0.0.1                 | 集群master地址                               |
| S_MASTER_PORT             | 6379                      | 集群master端口                               |
| S_MASTER_QUORUM           | 2                         | 参见http://redisdoc.com/topic/sentinel.html#id4 |
| S_FAILOVER_TIMEOUT        | 3000                      | 参见http://redisdoc.com/topic/sentinel.html#id4 |
| S_DOWN_AFTER_MILLISECONDS | 3000                      | 参见http://redisdoc.com/topic/sentinel.html#id4 |
| S_RECONFIG_SCRIPT         | disable                   |                                          |
| S_CLIENT_RECONFIG_SCRIPT  | /opt/notify_master6379.sh | 当S_RECONFIG_SCRIPT值为disable时此值不生效        |
