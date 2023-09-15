## 💡 gRPC

gRPC는 Google에서 개발한 고성능, 오픈 소스, 다목적 Remote Procedure Call(RPC) 프레임워크입니다.

gRPC는 Protocol Buffers를 사용하여 서비스 정의를 작성하고, HTTP/2를 통해 효율적인 통신을 제공합니다. 

이것은 분산 시스템에서의 클라이언트-서버 통신에 사용되며, 멀티 플랫폼, 멀티 언어 지원을 통해 쉬운 개발 및 통합을 제공합니다.

<br>

gRPC의 주요 특징과 이점은 다음과 같습니다.

1. 다양한 언어 지원: gRPC는 C++, Java, Python, Go, Ruby, C#, Node.js, Android Java, Objective-C, PHP, Dart, Kotlin, Swift, JavaScript 등 다양한 언어를 지원합니다.
2. 효율적인 통신: HTTP/2를 기반으로 하므로, 단일 연결로 다중 요청/응답 처리가 가능하며, 데이터 전송에 필요한 대기 시간을 줄일 수 있습니다.
3. 서비스 정의: Protocol Buffers를 사용하여 서비스 정의를 작성할 수 있습니다. 이를 통해 컴파일러가 코드를 생성하므로, 높은 생산성과 개발 효율성을 제공합니다.
4. 멀티 플랫폼: gRPC는 다양한 플랫폼을 지원합니다. 예를 들어, 서버는 Linux, macOS, Windows 등 다양한 운영 체제에서 실행할 수 있으며, 클라이언트는 iOS, Android, Web, IoT 등 다양한 플랫폼에서 실행할 수 있습니다.
5. 보안: gRPC는 SSL/TLS를 사용하여 통신을 보호합니다.
6. 스트리밍: gRPC는 서버와 클라이언트 간의 스트리밍을 지원합니다. 예를 들어, 클라이언트는 서버로 데이터를 보내는 것과 동시에, 서버가 데이터를 처리하고 결과를 반환하는 것이 가능합니다.
7. 가벼운 프로토콜: gRPC는 JSON 같은 텍스트 기반 프로토콜보다 가볍고 효율적입니다.

gRPC는 마이크로서비스 아키텍처, 분산 시스템, 클라우드 네이티브 애플리케이션, 모바일 애플리케이션 등에서 널리 사용됩니다. gRPC는 빠른 개발과 효율적인 통신을 제공하며, 높은 성능과 확장성을 제공합니다.

---

**gRPC를 코틀린 기반의 Spring Boot에서 활용하려면 다음과 같은 단계를 따르면 됩니다.**

gRPC 서비스 정의 작성: 먼저, Protocol Buffers를 사용하여 gRPC 서비스 정의 파일(.proto)을 작성해야 합니다. 

이 파일에는 서비스 및 메서드의 인터페이스를 정의하는 RPC 서비스 정의가 포함됩니다. 

예를 들어, 다음과 같은 간단한 greet.proto 파일을 작성할 수 있습니다.

```go
syntax = "proto3";

package greet;

service GreetingService {
  rpc SayHello(HelloRequest) returns (HelloResponse) {}
}

message HelloRequest {
  string name = 1;
}

message HelloResponse {
  string message = 1;
}
```

<br>

**gRPC 코드 생성: 작성한 gRPC 서비스 정의 파일을 사용하여 코드를 생성해야 합니다.** 

이를 위해 프로젝트에 protobuf-gradle-plugin을 추가하고, 다음과 같은 Gradle 스크립트를 작성할 수 있습니다.

```python
plugins {
    id 'com.google.protobuf' version '0.8.17'
}

protobuf {
    protoc {
        artifact = "com.google.protobuf:protoc:3.15.8"
    }
    plugins {
        grpc {
            artifact = 'io.grpc:protoc-gen-grpc-java:1.39.0'
        }
    }
    generateProtoTasks {
        all()*.plugins {
            grpc {}
        }
    }
}

sourceSets {
    main {
        proto {
            srcDir 'src/main/proto'
        }
        java {
            srcDir 'src/generated/main/grpc'
        }
    }
}
```

<br>

**이제 gradle build 명령을 실행하면, gRPC 서비스 정의 파일을 바탕으로 자동으로 코드가 생성됩니다.**

Spring Boot 서비스 구현: 생성된 gRPC 코드를 Spring Boot 서비스에서 사용할 수 있도록 구현해야 합니다.

 이를 위해, Spring Boot에서 gRPC 서비스 빈을 생성하고, 이를 Controller에서 사용할 수 있도록 설정합니다. 

예를 들어, 다음과 같은 코드를 작성할 수 있습니다.

```kotlin
@Service
class GreetingService : GreetingServiceGrpc.GreetingServiceImplBase() {

    override fun sayHello(request: HelloRequest, responseObserver: StreamObserver<HelloResponse>) {
        val message = "Hello, ${request.name}!"
        val response = HelloResponse.newBuilder().setMessage(message).build()
        responseObserver.onNext(response)
        responseObserver.onCompleted()
    }
}

@RestController
@RequestMapping("/greet")
class GreetingController(private val greetingService: GreetingService) {

    @GetMapping("/{name}")
    fun greet(@PathVariable name: String): HelloResponse {
        val request = HelloRequest.newBuilder().setName(name).build()
        return greetingService.sayHello(request)
    }
}
```

<br>

**Spring Boot 서버 설정: 마지막으로, Spring Boot 서버를 gRPC 프로토콜로 설정해야 합니다.** 

이를 위해, 다음과 같은 라이브러리를 추가하고, 서버를 구성해야 합니다.

```yaml
implementation("io.grpc:grpc-spring-boot-starter:2.14.0")
```