## Prometheus Query

### Linux

```promql
# CPU - idle 시간을 기준으로 백분율 계산 (Standard Option의 Unit을 Percent(0.0 - 1.0)으로 세팅
1 - (avg(irate(node_cpu_seconds_total{instance="192.168.0.6:9100",job="Test",mode="idle"}[$__rate_interval])) by (instance))

# Memory
1 - (node_memory_MemAvailable_bytes{instance="192.168.0.6:9100",job="Test"} / node_memory_MemTotal_bytes{instance="192.168.0.6:9100",job="Test"}) 

# Disk I/O
irate(node_pressure_io_waiting_seconds_total{instance="192.168.0.6:9100",job="Test"}[$__rate_interval])
```