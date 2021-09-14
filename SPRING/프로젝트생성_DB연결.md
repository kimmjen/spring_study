# Spring Boot Connect to MySQL in IntelliJ

## 1. IntelliJ에서 프로젝트 생성하기

![1](https://user-images.githubusercontent.com/65153512/133030092-90b1c37c-1c36-4489-b846-c1bbc259799f.PNG)
  
1. IntelliJ에서 새 프로젝트를 생성한다.

<br>

![2](https://user-images.githubusercontent.com/65153512/133030174-a646c429-402d-43bd-82f0-23992b1cc7c7.PNG)

2. Spring initializr 를 통해 프로젝트 명과 Java 버전을 확인한 후 다음으로 넘어간다.

<br>

![3](https://user-images.githubusercontent.com/65153512/133031064-6886a56c-ba64-4775-ac17-8917deca303d.PNG)

3. Spring Web, Spring Data JPA, MySQL Driver 를 추가한 뒤 프로잭트를 생성한다.

<br>

![4](https://user-images.githubusercontent.com/65153512/133031119-67157f6b-baef-4c6e-be05-89c8b122fe2f.png)

4. MySQL에서 스키마를 생성한다.

<br>

![5](https://user-images.githubusercontent.com/65153512/133031143-b6363c4c-df51-4b97-bc11-16bfc72bc839.png)

![6](https://user-images.githubusercontent.com/65153512/133031190-f7942557-495e-4e73-a077-68f541e58cc8.PNG)

5. (생략가능) application파일을 yml 로 확장자를 변경한다.

<br>

![7](https://user-images.githubusercontent.com/65153512/133031221-9c15cbb5-9ff3-48c2-8cdd-6c819ce795b9.PNG)

6. 다음 코드를 삽입한다

~~~
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ionstudyspring?characterEncoding=utf8
    username: root
    password: root
    driver-class-name: com.mysql.cj.jdbc.Driver
  jpa:
    hibernate:
      ddl-auto: create

      naming:
        physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
    show-sql: true
~~~
Spring 설정
  -db 설정
    --db주소
    --db 유저이름
    --db 유저비번
    --db 연결에 사용할 드라이버

  -jpa(전송 데이터 설정을 jpa로)
    --db 실행 설정
    --이름짓기 전략
      ---해당라이브러리방식
    --실행시 sql문 보임

<br>

![8](https://user-images.githubusercontent.com/65153512/133032113-2743b08e-ba0f-4746-8942-355b29ecde52.PNG)

7. 원하는 데이터에 대한 패키지와 클래스를 생성한다.
 
<br>

@Entity - 해당 클래스가 테이블로 생성됨을 명시
@Id - 해당 변수가 primary key 임을 명시
@GeneratedValue(strategy = GenerationType.IDENTITY) - 해당 테이블에 데이터가 추가될 때 DB에 설정된 방식으로 값이 자동으로 지정된다. 이 코드의 경우 값이 1씩 증가한다.

<br>

![9](https://user-images.githubusercontent.com/65153512/133032352-787c6e25-36f7-4e97-a4cd-ec68feefbaa4.PNG)

8. 테이블이 생성되었음을 확인할 수 있다.
#
## 2. start.spring.io 에서 프로젝트 생성하기
https://start.spring.io/
위 사이트에서 초기 설정을 한 뒤 내려받아 압축해제 하여 프로젝트를 생성 할 수 있다.

![image](https://user-images.githubusercontent.com/65153512/133032695-1b722b17-3c1c-4109-a428-d893043d5b1e.png)

![image](https://user-images.githubusercontent.com/65153512/133032866-3ea0873a-d265-4a4f-b02a-d9205ed3c4a3.png)
