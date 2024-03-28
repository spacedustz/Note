## Server Health Check Script

- 특정 시간대에 특정 프로세스들이 떠있는지 확인하고, 실행중이 아니라면 실행
- 만약 조건에 맞는 시간대가 아니면 주기적으로 프로세스가 실행중인지 확인 후 프로세스 종료

```python
import datetime
import subprocess
import time
import psutil

def kill_process_by_name(process_name):
"""프로세스 이름으로 프로세스를 찾아 종료하는 함수"""
for proc in psutil.process_iter():
if proc.name() == process_name:
proc.kill()
print(f"{process_name} 프로세스를 종료했습니다.")

def check_and_run_process():
now = datetime.datetime.now()
start_time = now.replace(hour=11, minute=20, second=0, microsecond=0)
end_time = now.replace(hour=13, minute=10, second=0, microsecond=0)

    cvedia_process_name = "cvediart.exe"
    java_process_name = "java.exe"

    cvedia_path = "CVEDIA-RT.bat"
    jar_path = "C:\\Users\\user\\Documents\\Dains\\Backend-Server\\bridge.jar"

    # 스크립트 시작 전에 특정 프로세스를 종료
    kill_process_by_name(cvedia_process_name)
    kill_process_by_name(java_process_name)

    while True:
        now = datetime.datetime.now()
        if start_time <= now <= end_time:
            cvedia_running = any(cvedia_process_name in p.name() for p in psutil.process_iter())
            java_running = any(java_process_name in p.name() for p in psutil.process_iter())

            if not cvedia_running:
                startupinfo = subprocess.STARTUPINFO()
                subprocess.Popen([cvedia_path], startupinfo=startupinfo, shell=True)
                print("CVEDIA-RT 실행")

            if not java_running:
                startupinfo = subprocess.STARTUPINFO()
                subprocess.Popen(f'java -jar -Dspring.config.location=file:C:\\Users\\user\\Documents\\Dains\\Backend-Server\\application.yml {jar_path}', startupinfo=startupinfo, shell=True)
                print("Bridge 실행")

        elif now > end_time:
            for proc in psutil.process_iter():
                if proc.name() == cvedia_process_name or proc.name() == java_process_name:
                    proc.kill()
                    print(f"{proc.name()} 프로세스 종료")

            print(f"운영시간이 아닙니다 - 운영시간 : {str(start_time)[11:16]} ~ {str(end_time)[11:16]}")
            time.sleep(60)
            continue

        time.sleep(10)

if __name__ == "__main__":
check_and_run_process()
```