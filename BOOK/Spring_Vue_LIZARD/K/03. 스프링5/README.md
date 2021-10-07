# 03. 스프링 5 - 작업에 적합한 기술 스택(pdf. 108)
- IoC(Inversion of Control)와 DI(Dependency Injection) 학습하기(pdf. 109)
- 스프링 MVC 학습하기(pdf. 122)
- 데이터 접근을 위한 스프링 JDBC와 JPA 학습하기(pdf. 134)
- 관점 지향 프로그래밍인 스프링 AOP와 그 장점 학습하기(pdf. 149)
- 요약(pdf. 173)

## 스프링 제어의 역전(IoC)과 의존성 주입(DI)
---
스프링 규약에 의해 스프링 컨테이너가 관리하는 객체를 보통 빈(bean)이라고 부른다.<br>
빈은 예제 애플리케이션의 근간을 구성한다.<br>
자바에서는 객체의 의존성을 관리하기 위한 두 가지 방법이 있다.<br>
첫 번째 방법은 객체가 직접 의존 관계에 있는 객체들의 생성자를 호출(예를 들면 생성자 내에서)하는 것으로 의존성을 인스턴스화 하는 것이고<br>
다른 방법은 룩업(look-up) 패턴을 활용해 의존성들을 찾아 배치하는 것<br>
다음의 RegistrationService는 회원 가입에 성공한 이후에 사용자에게 이메일을 전송하는 예제<br>
단순화하기 위해 의존성 부분에 초점을 맞추고 회원 가입과 이메일을 전송하는 세부 사항 생략<br>

> RegistrationService가 생성자에게 MailSender를 인스턴스화 하는 방법
```
public class RegistrationService {
    private MailSender mailSender;

    public RegistrationService() {
        // 의존하는 객체를 인스턴스화한다.
        this.mailSender = new MailSender();
    }
    // ... 나머지 로직
}
```

RegistrationService는 MailSender를 인스턴스화함으로써 의존성을 관리<br>
<br>
생성자 또는 세터를 통해 의존성 주입하기 위해 스프링과 같은 컨테이너에 의존하는 방법<br><br>
```
public class RegistrationService {
    private MailSender mailSender;

    public RegistrationService(MailSender mailSender) {
        this.mailSender = mailSender();
    }
    // ... 나머지 로직
}
```

위 같이 RegistrationService 생성자의 인자로 MailSender 인스턴스를 추가한다. 이 방법에서는 RegistrationService는 의존성을 제어하지 못한다.
<br>
여기서 스프링이 MailSender 인스턴스를 인스턴스화하는 책임을 진다. 의존성 제어가 역전됐다. 그리고 여기서 제어의 역전(Inversion of Control, IoC)이라는 명칭이 유래<Br>

### 스프링 컨테이너 구동
---
스프링에서 org.springframework.context.ApplicationContext 인터페이스는 스프링 IoC 컨테이너를 의미<br>
독립 실행형 애플리케이션에서 컨테이너를 설정하는 일반적인 방법은 ClassPathXmlApplicationContext 또는 AnnotationConfigApplicationContext를 사용<br>

메이븐을 사용해 애플리케이션 만들기
> 메이븐 프로젝트의 디렉터리 구조
```
/src
/src/main/java
/src/main/resource
/src/main/webapp
/src/test/java
/src/test/resources
/pom.xml
```

/src/main 폴더는 애플리케이션 소스 코드의 루트<br>
/src/main/webapp 폴더는 웹 애플리케이션에서 static assets와 같은 뷰(view)가 위치<br>
/src/test 폴더는 애플리케이션 테스트 코드의 루트<br>
pom.xml은 메이븐의 설정 파일
`pon.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>app.sample</groupId>
  <artifactId>messages</artifactId>
  <version>1.0-SNAPSHOT</version>

  <properties>
    <spring.version>5.0.3.RELEASE</spring.version>
    <log4j.version>2.10.0</log4j.version>
  </properties>

  <dependencies>
    <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-context</artifactId>
      <version>${spring.version}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.logging.log4j</groupId>
      <artifactId>log4j-api</artifactId>
      <version>${log4j.version}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.logging.log4j</groupId>
      <artifactId>log4j-core</artifactId>
      <version>${log4j.version}</version>
    </dependency>
  </dependencies>
</project>
```

> app.messages 패키지의 소스코드
```
/src/main/java/app/messages/AppConfig.java
/src/main/java/app/messages/Application.java
/src/main/java/app/messages/Message.java
/src/main/java/app/messages/MessageRepository.java
/src/main/java/app/messages/MessageService.java
```

- AppConfig.java는 스프링이 컨테이너를 인스턴스화하는 데 사용할 설정 메타 데이터
- Application.java는 애플리케이션의 시작점이며, main() 메소드
- Message.java는 Message 모델을 정의하며 매우 단순한 구조
- MessageRepository.java는 메시지 저장을 담당하는 레파지토리를 간략하게 표현
- MessageService.java는 클라이언트에 API를 제공하는 애플리케이션 서비스

`Message.java`
```java
package app.messages;

public class Message {

  private String text;
  // String 타입의 private 필드인 text를 정의
  public Message(String text) { this.text = text; }
  // Message 클래스의 생성자를 정의
  // 매개변수로 text를 받고 private 필드인 text에 할당
  // 자바에서는 매개변수의 이름은 클래스의 필드 이름과 같을 수 있다.
  // this 키워드로 매개변수와 클래스의 필드를 구분할 수 있다.
  public String getText() { return text; }
  // 외부에서 private text 필드에 접근할 수 있도록 게터 메소드를 정의
}

```

`MessageRepository.java`
```java
package app.messages;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class MessageRepository {

  private final static Log log = LogFactory.getLog(MessageRepository.class);
  // Log 인스턴스 생성

  public void saveMessage(Message message) {
    // Save message to a database
    log.info("Saved message: " + message.getText());
  }
  // Message 객체를 매개변수로 받는 saveMessage() 메소드를 생성
  // 뒤에 나오는 섹션을 위해 데이터베이스에 메시지를 저장하는 구현체 남기고, 여기에서는 로그에 메시지를 간단하게 출력할 것
}
```

`MessageService.java`
```java
package app.messages;

public class MessageService {

  private MessageRepository repository;
  // MessageRespository를 MessageService의 의존성으로 정의

  public MessageService (MessageRepository repository) {
    this.repository = repository;
  }
  // MessageRepository 인스턴스를 매개변수로 취하는 생성자를 생성, 그리고 스프링은 이 생성자를 통해 의존성을 연결

  public void save(String text) {
    this.repository.saveMessage(new Message(text));
  }
  // 클라이언트가 String타입의 text를 전달해 레파지토리에 저장하는 단순한 API인 save(String) 메소드를 정의
}
```

`AppConfig.java`
```java
package app.messages;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
// AppConfig 파일이 빈을 정의하기 위한 것임을 스프링에 알려주기 위해 어노테이션을 적용
@ComponentScan("app.messages")
// 어노테이션이 달린 컴포넌트를 스캔할 기본 패키지를 스프링에 알려주기 위해 @Configuration 어노테이션과 같이 사용
public class AppConfig {

  @Bean
  // 
  public MessageRepository messageRepository() {
    return new MessageRepository();
  }

  @Bean    // applicationcontext 인터페이스를 확장한 BeanFacory 인터페이스 내부에 정의된 getBean(Class(T)) 메소드를 호출해 MessageService 빈의 인스턴스를 가져온다.
  MessageService messageService() {
    return new MessageService(messageRepository());
  }
}

```

`Application.java`
```java
package app.messages;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

public class Application {
  public static void main(String[] args) {
  // String 배열 객체를 매개변수로 취하는 static-void-main 메소드로 애플리케이션의 시작점을 정의
    ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
    // appconfig 클래스를 context 클래스의 생성자에 전달해 스프링 컨테이너를 생성
    MessageService messageService = context.getBean(MessageService.class);
    // applicationcontext 인터페이스를 확장한 BeanFacory 인터페이스 내부에 정의된 getBean(Class(T)) 메소드를 호출해 MessageService 빈의 인스턴스를 가져온다.
    messageService.save("Hello, Spring!");
    // 해당 서비스에 메시지 저장을 요청

  }
  // 이 시점에서 스프링 컨테이너에서 가져온 messageService 빈은 완전히 인스턴스화 됐고, 특히 MessageRepository의 인스턴스가 주입된다.
}

```

코드 실행을 위해 .jar파일을 생성하고 명령줄에서 실행하기 위해 메이븐을 활용할 것<br>
pom.xml 파일을 업데이트하고 <dependencies> 섹션 아래에 다음 <build> 섹션을 추가

```xml
</dependencies>

  <build>
    <finalName>messages</finalName>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-assembly-plugin</artifactId>
        <executions>
          <execution>
            <phase>package</phase>
            <goals>
              <goal>single</goal>
            </goals>
            <configuration>
              <archiveBaseDirectory>${project.basedir}</archiveBaseDirectory>
              <archive>
                <manifest>
                  <mainClass>app.messages.Application</mainClass>
                </manifest>
              </archive>
              <descriptorRefs>
                <descriptorRef>jar-with-dependencies</descriptorRef>
              </descriptorRefs>
            </configuration>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
```

기본적으로 메이븐 플러그인 maven-assembly-plugin을 빌드 프로세스에 추가, 그리고 이 플러그인은 .jar 파일의 main 클래스 정보를 필요로 하기 때문에 mainClass 태그에서 이를 제공한다.<br>
명령줄에서 .jar 파일을 실행하려면 애플리케이션의 의존성으로 spring-context-5.0.3.RELEASE.jar 파일을 .jar 파일에 포함, 이를 위해 <descriptorRef>를 추가<br><br>

애플리케이션 빌드하기 전에 `src/main/resources/log4j2.xml 파일에 Log4j 설정을 추가

`log4j2.xml`
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Configuration status="WARN">
  <Appenders>
    <Console name="Console" target="SYSTEM_OUT">
      <PatternLayout pattern="%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n"/>
    </Console>
  </Appenders>
  <Loggers>
    <Logger name="app.messages" level="INFO">
      <AppenderRef ref="Console"/>
    </Logger>
    <Root level="ERROR"/>
  </Loggers>
</Configuration>

```

pom.xml 파일이 있는 루트 폴더로 전환한 후 mvn install을 실행하면 공용 메이븐 저장소에서 필요한 모든 의존성을 내려받고 .jar파일을 빌드한다.

```관리자cmd
mvn install

➜  java -jar .\target\messages-jar-with-dependencies.jar
Unable to get Charset 'cp65001' for property 'sun.stdout.encoding', using default x-windows-949 and continuing.
02:05:26.797 [main] INFO  app.messages.MessageRepository - Saved message: Hello, Spring!
```

### 어노테이션 기반의 설정
1. 빈을 선언하는 어노테이션
2. 의존성을 연결하는 어노테이션

#### 빈 선언
스프링은 빈을 선언하기 위해 @Component, @Service, @Controller, @Repository를 포함한 스테레오 타입 어노테이션 세트를 제공<br>
스프링은 @ComponentScan 어노테이션에 입력한 기본 패키지 부터 스캔해 해당 어노테이션이 달린 클래스를 수집

@Component 어노테이션은 제네릭 스테레오 타입이다.<br>
클래스에 이 어노테이션이 적용돼 있으면 스프링은 해당 클래스를 인스턴스화한다.<br>
@Service 어노테이션은 @Component를 특수화한 것이고, 이 어노테이션이 적용된 클래스는 `도메인주도설계(위키북스 2011)`에 사용된 용어인 서비스 이거나 Core J2EE에서의 패턴인 비즈니스 서비스 파사드(facade)를 나타낸다.<br>
@Repository 어노테이션은 컴포넌트가 `도메인주도설계`에서 사용된 용어인 레파지토리(repository) 또는 전통 자바 EE 패턴인 DAO(Data Access Object)임을 나타낸다.<br>
@Controller 어노테이션은 컴포넌트가 HTTP 요청을 받을 수 있는 웹 컨트롤러<br>
이후에 @Service, @Repository, @Controller 에 대해 다룬다.

`MessageService.java`
```java
...
import org.springframework.stereotype.Component;
@Component
public class MessageService {
    
}
...
```

스프링에서 관리하는 빈을 가지려면 클래스 레벨에 @Component 어노테이션을 적용만 하면 된다.

`MessageRepository.java`
```java
...
import org.springframework.stereotype.Component;
@Component
public class MessageRepository {
    
}
...
```

@Component를 사용해 MessageService와 MessageRepository 빈을 선언했으므로 더는 필요없는 messageRepository(), messageService() 메소드를 AppConfig에서 삭제<br>

AppConfig에 이 두 메소드를 남겨두면 스프링은 여전히 이전에 선언한 빈으로 MessageRepository와 MessageService의 인스턴스를 만들고, 이 두 클래스에 적용된 @Component 어노테이션은 효과가 없을 것이다.<br>
이들은 AppConfig 내부에서 @Bean 어노테이션에 이해 재정의

### 의존성 주입
의존성을 연결하는 데는 스프링에서 제공하는 두 어노테이션의 @Required 어노테이션과 @Autowired 어노테이션을 사용<br>
@Required 어노테이션을 세터 메소드, @Autowired 어노테이션을 생성자와 메소드, 필드에 적용

- 생성자 기반의 주입
- 세터 기반/ 메소드 기반의 주입
- 필드 기반의 주입

#### 생성자 기반의 주입
생성자를 통해 수행된다.<br>
MessageRepository 빈은 MessageService 빈에 생성자를 통해 주입된다. 생성자에 @Autowired 어노테이션 적용

`MessageService.java`
```java
@Autowired
public MessageService(MessageRepository messageRepository) {
    this.repository = repository;
}
```

여기서 @Autowired 어노테이션 또한 생략할 수 있다. 이경우에도 스프링은 MessageRepository 빈을 삽입해야 하므로 MessageService 생성자를 검사하면서 해당 인자의 유형을 찾는다.<br><br>

#### 세터 기반/ 메소드 기반의 주입
메소드(일반적으로 세터 메소드)를 선언하고 @Autowired 어노테이션 또는 @Required 어노테이션을 적용하는 것<br>
예를 들어 MessageService 생성자를 제거하고 setRepository(MessageRepository) 메소드를 추가할 수 있다.
`MessageService`
```java
public class MessageService {
    ...
    @Required
    public void setRepository (MessageRepository repository) {
        this.repository = repository;
    }
    ...
}
```

또는 다른이름으로 지정할 수 있다.
```java
@Autowired
public void prepare (MessageRepository repository) {
    this.repository = repository;
}
```

#### 필드 기반의 주입
@Autowired 어노테이션으로 필드에 직접 적용할 수 있다.<br>
이 방법을 이용하면 세터 메소드를 선언할 필요 없다.<br>

```java
@Autowired
private MessageRepository repository;
```

#### 의존성 주입 모범 사례
필요한 의존성은 항상 생성자를 주입해야 한다. 이를 통해 생성 이후에 인스턴스는 완전히 초기화되고 주입된 의존성은 읽기 전용(read-only)이 된다.<br>
필수가 아닌 선택적인 의존성은 세터/ 메소드를 통해 주입<br>

필드 기반 주입은 사용하지 말아야한다.<br>
스프링은 자바 리플렉션(Reflection)으로 필드를 주입하고, 필드 주입 방식을 사용하는 것은 위험한 것을 ㅗ간주.
- 의존성을 초기화하고 관리하는 방법과 이들의 의존 관계와 같은 의존성의 정보를 숨긴다.
- 필드 주입은 매우 간단하다. 필드를 정의하고 @Autowired 또는 @Resource 어노테이션을 적용만 하면된다. 개발자가 이 방법에 중독되어 너무 많은 의존성을 추가하면 단일 책임 원칙(SRP)를 위반

## 스프링 MVC
자바 EE 서블릿 API를 기반으로 한다. 스프링MVC에 대해 깊이 있게 살펴보기 전에 자바 EE 웹 애플리케이션이 서블릿과 어떻게 동작하는 알아보아야만 스프링 MVC의 역할을 더 쉽게 이해하는데 도움이 된다.<br>

### 자바 EE 서블릿(pdf. 122)
자바 EE 서블릿 또는 서블릿은 일반적으로 톱캣과 같은 애플리케이션 서버인 서블릿 컴테이너 내에서 동작한다.<br>
HTTP 요청이 서버에 도착하면 일반적으로 인증, 로깅, 감사와 같은 필터링 작업을 수행하는 필터 리스트를 통과한다.<br>
요청이 모든 필터를 통과하면 애플리케이션 서버는 특정 패턴과 일치하는 URI를 포함하는 요청을 처리할 수 있게 등록된 서블릿으로 요청을 넘겨준다.<br>
서블릿이 요청에 대한 처리를 마치면 HTTP 응답은 해당 HTTP 요청을 처리한 같은 필터 세트를 통과한 후 클라이언트로 다시 전송된다.<br>

![]()

자바 EE 에서 모든 HTTP 요청에 대해 HttpServletRequest 인스턴스가 생성된다. 그리고 모든 HTTP 응답에 대해 HttpServletResponse 인스턴스가 생성된다.<br>
여러 요청에서 사용자를 식별하기 위해 애플리케이션 서버는 첫 번째 요청을 받으면 HttpSession 인스턴스를 생성한다. 각 HttpSession 인스턴스는 세션(session) ID 라고 부르는 ID를 가진다.<br>
세션 id는 HTTP 응답 헤더의 클라이언트에 쿠키로 전송된다. 클라이언트는 그 쿠키를 저장하고 다음 요청 시 다시 서버로 보낸다.<br>
이렇게 해서 서버는 쿠키에서 찾은 세션 ID로 HttpSession 인스턴스를 조회해 사용자를 인식<br><br>

자바 EE에서 HttpSessionListener 인터페이스를 구현해 HttpSession의 라이프 사이클 이벤트를 수신하거나 SevletRequestListener 인터페이스를 구현해 요청에 대한 라이프 사이클 이벤트를 수신하는 리스너를 만들 수 있다.<br>
서블릿을 생성하기 위해 javax.sevlet.http.HttpServlet을 확장하고 @webServlet 어노테이션을 적용하거나 전통 방식으로 자바 EE 웹 애플리케이션의 설정 파일인 web.xml 파일에 등록할 수 있다.<br>
어느 방법이든, 서버가 일치하는 URI 요청을 라우트할 수 있게 이 서블릿을 하나 이상의 URI 패턴에 매핑해야 한다.<br>

서블릿에서 다음 메소드를 재정의
- doGet: HTTP GET 요청을 처리
- doPost: HTTP POST 요청을 처리
- doPut: HTTP PUT 요청을 처리
- doDelete: HTTP DELETE 요청을 처리

메소드의 내부는 애플리케이션의 로직이 시작되는 위치가 된다.<br>
또한 서블릿을 사용할 때 in-memory 데이터 또는 I/O 수행과 같은 공유 리소스에 접근해야 한다면 서블릿이 항상 동시 요청을 다루고, 하나의 요청에 의한 변경 사항이 다른 요청에 영향을 줄 수 있다는 사실을 기억해야 한다.<br>

### DispatcherServlet(pdf. 124)
스프링 MVC를 사용하면 서블릿을 생성할 필요가 없다.<br>
클래스를 생성해 @Controller 어노테이션을 추가하고 @RequestMapping 어노테이션으로 특정 URI 패턴에 매핑할 수 있다.<br>
규약에 따르면 클래스 이름은 보통 Controller로 끝난다.<Br>

스프링은 요청을 받기 위해 핵심 서블릿인 DispatcherServlet를 활용한다. 모든 요청을 처리할 수 있게 설정돼야 하며 @RequestMapping 어노테이션에 지정된 URI 패턴에 따라 스프링은 쵸엉을 처리할 패턴에 맞는 컨트롤러를 찾는다.

> 스프링 MVC를 사용할 때의 요청/응답 흐름을 보여준다.

![]()

메시지 앱을 웹 애플리케이션으로 변경하고 HTTP 요청을 받는 컨트롤러를 추가, pom.xml 파일에 스프링 부트 의존성 추가<br>

`pom.xml`
```xml
...
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.0.0.RELEASE</version>
  </parent>

  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-thymeleaf</artifactId>
    </dependency>
  </dependencies>
...
```

<parent> 태그는 스프링 부트의 부모 스타터로부터 프로젝트 아티팩트를 상속받는다. 그리고 spring-boot-starter-web 의존성은 앞서 사용한 spring-context 모듈을 포함한다.<br>
mvn install 실행 하면 메이븐이 스프링 부트가 필요로 하는 의존성을 내려 받는 것을 확인<br>
