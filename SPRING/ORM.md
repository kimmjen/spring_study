ORM 이란
======================
#### ORM
##### Object Relational Mapping (객체 관계 매핑)
데이터베이스와 객체 지향 프로그래밍 언어(JAVA) 간의 호환되지 않는 데이터를 변환하는 프로그래밍 기법으로, 객체 지향 언어에서 사용할 수 있는 "가상" 객체 데이터베이스를 구축하는 방법이다.

즉, 자바객체를 DB에 연결하는 방법론이다.

JPA란 자바 ORM 기술에 대한 API 표준 명세를 의미한다.

|JAVA|->|DB(INPUT)|DML(DELETE, UPDATE)|
|:---:|---:|---:|---|
|DB|->|JAVA(OUTPUT)|SELECT|

<br/>

#### DataBase Table
![image](https://user-images.githubusercontent.com/65153512/132879682-3f0aa635-18fd-4bc4-bd19-16f498b89777.png)

<br/>

#### JAVA Class
![image](https://user-images.githubusercontent.com/65153512/132880111-4f0c495d-9b06-4aaa-a0d6-124f92e600a6.png)

<br/>
<br/>

JAVA와 DB의 데이터 타입이 서로 상이하므로, Class를 통해 DB테이블을 모델링한다.
Table Relational Mapping 방식에서는
DB에서 테이블을 생성하고 테이블에 맞추어 Class를 생성했다.

![image](https://user-images.githubusercontent.com/65153512/132882081-f8c69d94-8022-490f-94d3-de3968bc346a.png)

<br/>
<br/>
  
ORM(JPA)를 이용하면
Class를 만들고 이를 통해 DB에 테이블을 자동으로 생성하는 것이 가능하다.

![image](https://user-images.githubusercontent.com/65153512/132881868-05ef4498-b6c6-4421-97e1-e7e56062fb8b.png)
#
#### JPA는 반복적인 CRUD 작업을 생략할 수 있다.

##### CRUD 작업과정
※정확한 예시가 아닐 수 있다.

1. JAVA 에서 DB로 커넥션 요청

![image](https://user-images.githubusercontent.com/65153512/132883203-ec677c37-3980-42a4-8d68-a43a29e3294b.png)

<br/>

2. DB 신분(권한) 확인후 세션 오픈(생성)

![image](https://user-images.githubusercontent.com/65153512/132883483-32ea5176-ceb6-41c0-abae-0b0514adef59.png)

<br/>

3.  JAVA 에서 커넥션을 가짐(세션ID를 return 받음)

<br/>

4. JAVA에서 SQL쿼리를 만들어 요청을 전송, DB에서 쿼리를 이용하여 데이터를 생성하여 전송.

![image](https://user-images.githubusercontent.com/65153512/132884565-c6841790-1f45-46c5-aca2-7fe64b2ed193.png)

<br/>

6. DB데이터는 JAVA 오브젝트와 다르므로 자바오브젝트로 변환해야 한다.

<br/>

7. 커넥션을 닫는다.

<br/>
<br/>

JPA는 쿼리의 응답을 JAVA 오브젝트로 변환하고 세션을 끊는 작업을 함수를 실행하는 것으로 간단하게 처리할 수 있다.
![image](https://user-images.githubusercontent.com/65153512/132885211-8b592b24-cf25-45a1-8063-0eb74b640c38.png)


