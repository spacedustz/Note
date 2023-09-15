
```bash
#!/bin/bash  
  
# Blue & Green 타겟 지정 변수  
target=0  
active=0  
deployment_target_ip=""  
  
# Gradlew 권한 부여  
chmod 500 ./gradlew  
  
# 빌드  
#./gradlew clean build --exclude-task test  
  
# 테스트용 빠른 빌드  
./gradlew bootJar  
  
# ====================Port Check ====================  
if [ "$(docker port blue 8080 | cut -d':' -f2)" -eq 8080 ]; then  
  active=1  
elif [ "$(docker port green 8081 | cut -d':' -f2)" -eq 8081 ]; then  
  active=2  
else  
  # 사용하지 않는 불필요한 이미지 삭제 = 겹치는 이미지가 존재하면 이미지를 삭제한다  
  dangling_images=$(docker images -f "dangling=true" -q)  
  if [[ -n "$dangling_images" ]]; then  
      docker rmi -f "$dangling_images" || true  
  fi  
  
  # 기존 Spring Boot Image 중 이미지가 기존과 똑같은게 있으면 이미지 삭제  
  if docker images | awk '{print $1":"$2}' | grep -q "localhost:5000/blue:1.0"; then  
    docker rmi -f localhost:5000/blue:1.0  
  elif docker images | awk '{print $1":"$2}' | grep -q "localhost:5000/green:1.0"; then  
    docker rmi -f localhost:5000/green:1.0  
  else  
    echo "No Image"  
  fi  
  
  # 두 컨테이너가 모두 없을 경우 첫 빌드  
  docker build --no-cache -t localhost:5000/blue:1.0 -f ./spacepet-deploy/test/Dockerfile .  
  
  # Container Registry에 이미지 Push  docker push localhost:5000/blue:1.0  
  
  # Push한 이미지 삭제  
  docker rmi localhost:5000/blue:1.0  
  
  # Container Registry에서 이미지 Pull  docker pull localhost:5000/blue:1.0  
  
  # Docker Container 생성  
  docker run -d -v /root/docker_volumn/blue:/app --network deploy --ip 172.20.0.2 --privileged --name blue -p 8080:8080 localhost:5000/blue:1.0  
fi  
  
# active 변수 출력  
echo "active=$active"  
  
# ==================== Health Check ====================  
if [ "$active" -eq 1 ]; then # blue가 온라인일때  
 deployment_target_ip="172.20.0.3"  
 target=green  
elif [ "$active" -eq 0 ]; then  
 deployment_target_ip="172.20.0.3"  
 target=blue  
else  
  echo "Invalid Active Container"  
fi  
  
# ==================== Target과 일치하는 가동중인 Spring Boot 컨테이너 중지 & 삭제 ====================if [ "$target" == "green" ]; then  
  # 사용하지 않는 불필요한 이미지 삭제 = 겹치는 이미지가 존재하면 이미지를 삭제한다  
  dangling_images=$(docker images -f "dangling=true" -q)  
  if [[ -n "$dangling_images" ]]; then  
      docker rmi -f "$dangling_images" || true  
  fi  
  
  # 기존 Spring Boot Image 중 이미지가 기존과 똑같은게 있으면 이미지 삭제  
  if docker images | awk '{print $1":"$2}' | grep -q "localhost:5000/green:1.0"; then  
    docker rmi -f localhost:5000/blue:1.0  
  fi  
  
  docker stop green  
  docker rm green  
  
  # Build Image  
  docker build --no-cache -t localhost:5000/green:1.0 -f ./spacepet-deploy/test/Dockerfile .  
  
  # Container Registry에 이미지 Push  docker push localhost:5000/green:1.0  
  
  # Push한 이미지 삭제  
  docker rmi localhost:5000/green:1.0  
  
  # Container Registry에서 이미지 Pull  docker pull localhost:5000/green:1.0  
  
  # Docker Container 생성  
  docker run -d -v /root/docker_volumn/green:/app --network deploy --ip 172.20.0.3 --privileged --name green -p 8081:8080 localhost:5000/green:1.0  
  
  docker stop blue  
  
elif [ "$target" == "blue" ]; then  
  # 사용하지 않는 불필요한 이미지 삭제 = 겹치는 이미지가 존재하면 이미지를 삭제한다  
  dangling_images=$(docker images -f "dangling=true" -q)  
  if [[ -n "$dangling_images" ]]; then  
      docker rmi -f "$dangling_images" || true  
  fi  
  
  # 기존 Spring Boot Image 중 이미지가 기존과 똑같은게 있으면 이미지 삭제  
  if docker images | awk '{print $1":"$2}' | grep -q "localhost:5000/blue:1.0"; then  
    docker rmi -f localhost:5000/blue:1.0  
  fi  
  
  docker stop blue  
  docker rm blue  
  
  # Build Image  
  docker build --no-cache -t localhost:5000/blue:1.0 -f ./spacepet-deploy/test/Dockerfile .  
  
  # Container Registry에 이미지 Push  docker push localhost:5000/blue:1.0  
  
  # Push한 이미지 삭제  
  docker rmi localhost:5000/blue:1.0  
  
  # Container Registry에서 이미지 Pull  docker pull localhost:5000/blue:1.0  
  
  # Docker Container 생성  
  docker run -d -v /root/docker_volumn/blue:/app --network deploy --ip 172.20.0.3 --privileged --name blue -p 8081:8080 localhost:5000/blue:1.0  
  
  docker stop green  
else  
 echo "Invalid target Value"  
fi
```