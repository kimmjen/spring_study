# 스프링 게시판 만들기 정리
## [1. 스프링 기본 설정](https://kuzuro.blogspot.com/2019/08/1.html)
환경
Tool:[sts4](https://download.springsource.com/release/STS4/4.12.0.RELEASE/dist/e4.21/spring-tool-suite-4-4.12.0.RELEASE-e4.21.0-win32.win32.x86_64.self-extracting.jar) + sts3 add-on for sts4
Tomcat:[톰캣 8.5](https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.71/bin/apache-tomcat-8.5.71.zip)
DB:[MySQL](https://dev.mysql.com/downloads/file/?id=506568)



sts4

workspace, resource encoding UTF-8 지정



web.xml

인코딩 설정

~~~xml
<!--  문자 인코딩  시작 -->
<filter>
  <filter-name>encodingFilter</filter-name>
  <filter-class>
    org.springframework.web.filter.CharacterEncodingFilter
  </filter-class>
  <init-param>
    <param-name>encoding</param-name>
    <param-value>UTF-8</param-value>
  </init-param>
  <init-param>
    <param-name>forceEncoding</param-name>
    <param-value>true</param-value>
  </init-param>
</filter>
<filter-mapping>
  <filter-name>encodingFilter</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>
<!--  문자 인코딩  끝 -->
~~~

filter 를 추가하여 인코딩

filtername : 필터명

filter-class : 등록하려는 필터의 클래스

init-param :설정할 내용

encoding: 인코딩 방식

force encoding: 강제성?

filter-mapping: 필터 적용 위치 /* 전체



home.jsp

~~~jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
~~~



---

## [2. 데이터 베이스 준비](https://kuzuro.blogspot.com/2019/08/2.html)

~~~sql
# 계정 생성
create user 'kuzuro'@'localhost' identified by '1111';
#kuzuro 라는 db계정 생성 ip는 localhost pw는 1111

# 데이터 베이스 생성
create database board;

# 데이터 베이스에 대한 권한 설정
grant all privileges on board.* to 'kuzuro'@'localhost';
#board라는 db에 모든 접근권한을 준다

commit;
#작업처리

select * from mysql.user;
# select 가져오기, * 모든, from 위치 mysql.user

select * from mysql.user;
#user 생성 확인

use board;
#사용할 db선택

create table tbl_board(
    #tbl_board 생성
  bno int not null auto_increment,
    #bno는 int 형이며, null일수 없고 테이블에 값이 추가될때마다 자동으로 1씩 증가한다
  title varchar(50) not null,
    #title는 문자열이며 null일 수 없다.
  content text not null,
  writer varchar(30) not null,
  regDate timestamp not null default now(),
    #regDate는 시간이며 기본적으로 현재시간이 입력된다.
  viewCnt int default 0,
    #viewCnt는 int 형이며, 기본값을 0으로 한다.
  primary key(bno)
    #구분자는 bno
);

select * from tbl_board;
#tbl_board 테이블로부터 모든 정보를 가져옴
~~~

---

## [3. 스프링과 데이터 베이스 연동](https://kuzuro.blogspot.com/2019/08/3.html)

### DAO, DTO, VO 차이

DAO - Data Access Object 의 약자로 데이터베이스의 data에 접근하기 위한 객체.

DataBase 접근을 하기 위한 로직과 비지니스 로직을 분리하기 위해 사용한다.

Mybatis 등을 사용할 경우 커넥션풀까지 제공되고 있기 때문에 DAO를 별도로 만드는 경우는 드뭅니다.

DTO(Data Transfer Object), VO(Value Object)

둘 모두 데이터 교환을 위해 사용되는 객체이다.

DTO의 경우 Getter/Setter 가 존재하여 가변적인 객체이고, VO는 Getter만 존재하는 Read-Only 객체다.



VO와 DTO를 사용해서 데이터를 교환하는 이유는. 온전한 domain/model 의 일부 정보만을 전달할 때 비어있는 정보로 인해 오류가 발생할 수 있고, 복잡도가 증가하므로 특정 목적을 위해 쓰인다.

### Domain

DB 에서 생성한 테이블의 하나의 행에 해당하는 요소이다.



pom.xml

~~~xml
<!-- mysql db -->
		<!-- https://mvnrepository.com/artifact/mysql/mysql-connector-java -->
		<!-- mysql과 java를 연결하는 라이브러리 -->
		<dependency>
			<groupId>mysql</groupId>
			<artifactId>mysql-connector-java</artifactId>
			<version>8.0.16</version>
		</dependency>

		<!-- org.mybatis/mybatis -->
		<!-- mybatis 라이브러리 -->
		<dependency>
			<groupId>org.mybatis</groupId>
			<artifactId>mybatis</artifactId>
			<version>3.4.1</version>
		</dependency>

		<!-- mybatis-spring -->
		<!-- mybatis와 spring을 연결하는 라이브러리 -->
		<dependency>
			<groupId>org.mybatis</groupId>
			<artifactId>mybatis-spring</artifactId>
			<version>1.3.0</version>
		</dependency>

		<!-- spring-jdbc -->
		<!-- db와 spring를 연결하는 라이브러리 -->
		<dependency>
			<groupId>org.springframework</groupId>
			<artifactId>spring-jdbc</artifactId>
			<version>${org.springframework-version}</version>
		</dependency>
~~~



### Mybatis

자바 오브젝트와 SQL사이의 자동 매핑 기능을 지원하는 ORM(Object relational Mapping)프레임워크이다. SQL을 별도의 파일로 분리해서 관리하게 해준다.



root-context

~~~xml
<!-- Root Context: defines shared resources visible to all other web components -->
<!--db연결 정보 bean 생성 -->
	<bean id="dataSource"
		class="org.springframework.jdbc.datasource.DriverManagerDataSource">
		<property name="driverClassName"
			value="com.mysql.jdbc.Driver"></property>
		<property name="url" value="jdbc:mysql://127.0.0.1:3306/board?characterEncoding=UTF-8&amp;serverTimezone=UTC"></property>
		<property name="username" value="root"></property>
		<property name="password" value="root"></property>
	</bean>

<!-- 위 정보를 통한 mybitis db연결 설정-->
	<bean id="sqlSessionFactory"
		class="org.mybatis.spring.SqlSessionFactoryBean">
		<property name="dataSource" ref="dataSource" />
		<property name="configLocation"
			value="classpath:/mybatis-config.xml" />
        <!-- mybitis 설정 파일 경로-->
		<property name="mapperLocations"
			value="classpath:mappers/**/*Mapper.xml" />
        <!-- 매핑 정보 위치 기본위치는 main/resources-->
        <!-- mappers 이하 Mapper로 끝나는 모든 xml 파일을 인식-->
	</bean>
<!-- sqlSession 이라는 이름으로 jdbc 기능을 관리하는 sqlSession 생성 -->
	<bean id="sqlSession"
		class="org.mybatis.spring.SqlSessionTemplate"
		destroy-method="clearCache">
		<constructor-arg name="sqlSessionFactory"
			ref="sqlSessionFactory" />
	</bean>
~~~





mybatis.xml

~~~xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
  PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>

</configuration>
~~~



boardMapper.xml

~~~xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
  PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
  "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.board.mappers.board">
    <!-- com.board.mappers의 board로 시작하는 mapper -->

</mapper>
~~~

---

## [4. 게시물 목록 페이지 구현](https://kuzuro.blogspot.com/2019/08/4.html)

```sql
insert into tbl_board(title, content, writer)
  values('테스트 제목1', '테스트 내용', '작성자');

insert 테이블 삽입
into (table name) (속성1,속성2,속성3) values("값1","값2","값3")
```



JSTL

```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> 
```

jsp 작성을 단순화 하기 위해 사용하며 `<%= student %>`를 `${student}`로, `<%=if %>`문을 `<c:if>`, `<%=for%>`문을 `<c:forEach>`로 대체하여 사용한다.



---

## Spring MVC

1. 모델(Model) : 비즈니스 규칙을 표현  - BoardVO 등의 객체
        controller에서 파라미터로 별도의 선언 없이 사용 가능하다. jsp와 컨트롤러의 데이터 전달을 위해 사용한다.
        모델은 HashMap 형태를 갖고 있으므로 key값과 value값처럼 사용할 수 있다.
        addAttribute는 Map의 put과 같은 기능과 같아서 이를 통해 해당 모델에 원하는 속성과 그것에 대한 값을 주어 전달할 뷰에 데이터를 전달할 수 있다.

   

2. 뷰(View) : 프레젠테이션을 표현 - home.jsp 등의 페이지

   

3. 컨트롤러(Controller) : 위 두가지를 분리하기 위하여 양측 사이에 배치된 인터페이스

   컨트롤러를 통해서 클라이언트의 요청 주소에 따라서 적절한 뷰와 로직으로 정보를 전달하는 인터페이스이다.



BoardController

~~~java
package com.board.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.board.dao.BoardDAO;
import com.board.domain.BoardVO;
import com.board.service.BoardService;

@Controller
@RequestMapping("/board/*")
public class BoardController {

 @RequestMapping(value = "/list", method = RequestMethod.GET)
 public void getList() throws Exception {
  
   
 }
}
~~~

@Controller

해당 클래스가 controller임을 표시하고, view를 리턴할 수 있게한다.



@RequestMapping("/board/*")

기본주소/board/* 이하의 주소로 오는 요청을 해당 클래스에서 처리하도록 지정한다.



 @RequestMapping(value = "/list", method = RequestMethod.GET)

@Getmapping("/list")

/list 주소요청에 GET 방식의 요청에 대해 해당 함수로 처리한다.



### BoardMapper Mapping

```xml
<!-- 게시물 목록 -->
<select id="list" resultType="com.board.domain.BoardVO">
 select  bno, title, content, writer, regDate, viewCnt from tbl_board
</select>
<!-- 가운데는 평범한 쿼리문이고, select 태그로 감싸 mybatis가 select문임을 알게 한다.-->
<!-- id는 결과값이 저장될 인자이고, resultType으로 지정된 객체 타입으로 저장된다.-->
```

---

### Service 와 DAO 차이

### 차이

DAO는 단일 데이터 접근/갱신만 처리한다. 서버에 직접적으로 데이터를 입출력하는 동작을 담당한다,

Service는 여러 DAO를 호출하여 다수의 데이터의 입출력을 한뒤 데이터에 대한 비즈니스 로직을 수행하고, 이를 하나의 트랜잭션으로 묶는다.




### Impl 로 인터페이스를 굳이 사용하는 이유

1. 일반적으로 웹 프로그램에서는 서비스 + DAO까지 하나의 컴포넌트로 외부(Controller)에 제공되기 때문에 인터페이스를 사용하여 대체 가능성 등을 고려하기 위함

2. 일반적으로 transaction이나 Exception 처리 등의 AOP 설정이 서비스 경계 부분에 지정되기 때문입니다.



BoardDAOImpl

```java
package com.board.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.board.domain.BoardVO;

@Repository
//외부 I/O, DB 작업 등을 처리하는 클래스를 명시하는 어노테이션
public class BoardDAOImpl implements BoardDAO {

 @Inject//스프링 컨테이너로부터 자동으로 생성된 객체와 연결됨, @Autowired(spring 어노테이션)와 같은기능, java 어노테이션
    
   //mybatis를 통해 관리되는 jdbc객체?
 private SqlSession sql;
 //사용할 mapper
 private static String namespace = "com.board.mappers.board";

 // 게시물 목록
 @Override
 public List list() throws Exception { 
  //db에서 select로 다수의 결과를 반환한다. mapper의 list 를 사용해서.
  return sql.selectList(namespace + ".list");
 }

}
```



BoardServiceImpl

```java
package com.board.service;
import java.util.List;
import javax.inject.Inject;
import org.springframework.stereotype.Service;
import com.board.dao.BoardDAO;
import com.board.domain.BoardVO;

@Service//로직 처리 : @Service (서비스 레이어, 내부에서 자바 로직을 처리함)
public class BoardServiceImpl implements BoardService {

 @Inject
 private BoardDAO dao;
 
 @Override
 public List list() throws Exception {

  return dao.list();
 }

}
```





BoardController

```java
@RequestMapping(value = "/list", method = RequestMethod.GET)
 public void getList(Model model) throws Exception {
  
  List list = null;
  list = service.list(); //결과적으로 BoardVO가 담긴 list가 리턴됨
  model.addAttribute("list", list);//model 객체에 "list"라는 key로 list 변수를 담음
     //자동으로 /list 에 해당하는 jsp를 반환하는 것 같다.
 }
```



list.jsp

```jsp
<!-- model 로부터 ${list} 의 키에 해당하는 값을 var="list"에 담아서 사용한다.-->
<!-- 여기서 각각의 list객체는 boardVO 이다.-->
<c:forEach items="${list}" var="list">
 <tr>
  <td>${list.bno}</td>
  <td>${list.title}</td>
  <td>${list.regDate}</td>
  <td>${list.writer}</td>
  <td>${list.viewCnt}</td>
 </tr>
</c:forEach>
```

root-context

```xml
<context:component-scan base-package="com.board.domain" />
<context:component-scan base-package="com.board.dao" />
<context:component-scan base-package="com.board.service" />
<!-- 해당 패키지의 어노테이션을 읽어들여 자동으로 생성되도록 한다.-->
```

---

# [5. 게시물 작성 구현](https://kuzuro.blogspot.com/2019/08/5.html)



boardMapper.xml

```xml
<!-- 게시물 작성 -->
<!-- parameterType은 전송할 데이터 타입이다.-->
<insert id="write" parameterType="com.board.domain.BoardVO">
 insert into  tbl_board(title, content, writer)  values(#{title}, #{content}, #{writer})
</insert>
<!-- select 와 같다-->
```



BoardDAOImpl

```java
sql.insert(namespace + ".write", vo); //매퍼 기능 중 insert를 해당 인자의 매퍼의 write로 실행 하고 vo를 인자로 보낸다.
```



BoardController

```java
// 게시물 작성
@RequestMapping(value = "/write", method = RequestMethod.POST)
//== @PostMapping("/write") write페이지에서 submit 하면 post요청이 된다.
//post요청은 데이터를 전송하는 요청
Public String posttWirte(BoardVO vo) throws Exception {
  service.write(vo);
  
  return "redirect:/board/list";
}
```

---

# [6. 게시물 조회 (상세보기)구현](https://kuzuro.blogspot.com/2019/08/6.html)

list.jsp

```jsp
<td>
    <a href="/board/view?bno=${list.bno}">${list.title}</a>
    <!-- get 방식으로 주소를 통해 bno 에 list.bno를 넘기고 a태그로는 list의 제목을 표시-->
</td>
```



BoardController

```java
@GetMapping("/view")
//a태그를 통해 bno 값을 넘겨받음
public void getView(@RequestParam("bno") int bno, Model model) throws Exception {
	BoardVO vo = service.view(bno);
	model.addAttribute("view", vo);//모델에 결과로 받은 vo객체를 넘김
}
```





boardDAOImpl

```java
// 게시물 조회
public BoardVO view(int bno) throws Exception {
 //하나만 찾는 명령어, bno를 인자로 넘김
 return sql.selectOne(namespace + ".view", bno);
}
```



boardMapper

```xml
<!-- 게시물 조회 -->
<select id="view" parameterType="int" resultType="com.board.domain.BoardVO">
 select 
  bno, title, content, writer, regDate, viewCnt
 from 
  tbl_board
 where
  bno = #{bno}   
</select>
<!-- select와 동일, parameterType은 넘겨받은 bno타입, where에서 꺼내기 위해 #{bno}-->
```



view.jsp

~~~jsp
<!-- model을 통해 view라는 이름으로 vo객체를 받았다.-->
<label>제목</label> ${view.title }
<br />
<label>작성자</label> ${view.writer }
<br />
<label>내용</label>
<br /> ${view.content }
~~~

---

# [7. 게시물 수정 구현](https://kuzuro.blogspot.com/2019/08/7.html)

boardMapper.xml

```xml
<!-- 게시물 수정 -->
<update id="modify" parameterType="com.board.domain.BoardVO" >
 update tbl_board
  set
   title = #{title},
   content = #{content},
   writer = #{writer}
  where bno = #{bno}
</update>
<!-- 호출될 id지정, parameterType 전송 데이터 타입, #{}를통해 값을 매칭해서 가져온다.-->
```



---

# [7-5. 메뉴 인클루드, 날짜포멧](https://kuzuro.blogspot.com/2019/09/7-5.html)

include

~~~jsp
<div id="nav">
 <%@ include file="../include/nav.jsp" %>
</div>
~~~



날짜포멧

```jsp
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
```

---

# [8. 게시물 삭제 구현](https://kuzuro.blogspot.com/2019/09/8.html)

view.jsp

```jsp
<a href="/board/delete?bno=${view.bno}">게시물 삭제</a>
<!-- model의 값을 넘겨준다-->
```



BoardController

~~~java
// 게시물 삭제
@RequestMapping(value = "/delete", method = RequestMethod.GET)
public String getDelete(@RequestParam("bno") int bno) throws Exception {
  
 service.delete(bno);  //넘겨받은 bno를 넘겨준다

 return "redirect:/board/list";
}
~~~





BoardDAOImpl

~~~java
// 게시물 삭제
public void delete(int bno) throws Exception {
 sql.delete(namespace + ".delete", bno);//delete 기능중 .delete경로인 명령어를 실행하고, bno를 인자로 넘긴다.
}
~~~





BoardMapper

~~~xml
<!-- 게시물 삭제 -->
<delete id="delete" parameterType="int">
 delete
  from tbl_board
 where bno = #{bno}
</delete>
<!-- 삭제 쿼리문, 삭제할 데이터의 pk를 위한 id를 bno로 넘겨받는다 -->
~~~

---

# [9. 페이징 구현 1](https://kuzuro.blogspot.com/2019/09/9-1.html)

쿼리문

~~~sql
select   bno, title, writer, regDate, viewCnt from tbl_board order by bno desc limit 10;
#테이블로부터 정보를 가져오되. bno값이 큰순으로 10개씩 나누어 가져온다.
select   bno, title, writer, regDate, viewCnt from tbl_board order by bno desc limit a, b;
a번째부터 b개씩 가저온다
~~~



BoardMapping

~~~xml
<!-- 게시물 총 갯수 -->
<select id="count" resultType="int">
 select count(bno) from tbl_board
</select>
<!-- 테이블의 bno개수를 세는 명령어 -->


<!-- 게시물 목록 + 페이징 -->
<!-- hashmap형태의 데이터를 받았고, vo객체를 리턴한다. -->
<select id="listPage" parameterType="hashMap" resultType="com.board.domain.BoardVO">
 select  bno, title, writer, regDate, viewCnt from tbl_board order by bno desc limit #{displayPost}, #{postNum}
</select>
~~~



BoardDAOImpl

~~~java
// 게시물 총 갯수
@Override
public int count() throws Exception {
 return sql.selectOne(namespace + ".count"); //위의 명령어를 실행한 뒤 결과를 반환
}

// 게시물 목록 + 페이징
@Override
public List listPage(int displayPost, int postNum) throws Exception {

 HashMap data = new HashMap();
  //두 값을 key,value 형태로 담아서 전송
 data.put("displayPost", displayPost);
 data.put("postNum", postNum);
  
 return sql.selectList(namespace + ".listPage", data);
}
~~~



BoardController

~~~java
// 게시물 목록 + 페이징 추가
	@GetMapping("/listPage")
//listpage에서 기본값 1을 num으로 받았다.
	public void getListPage(Model model, @RequestParam("num") int num) throws Exception {

		// 게시물 총 갯수를 불러온다.
		int count = service.count();

		// 한 페이지에 출력할 게시물 갯수
		int postNum = 10;

		// 하단 페이징 번호 ([ 게시물 총 갯수 ÷ 한 페이지에 출력할 갯수 ]의 올림)
		int pageNum = (int) Math.ceil((double) count / postNum);

		// 출력할 게시물
		int displayPost = (num - 1) * postNum;

		List list = null;
		list = service.listPage(displayPost, postNum);//최초 0~10개 가져온다
		model.addAttribute("list", list);
		model.addAttribute("pageNum", pageNum);//모델에 페이지수 넘김
	}
~~~

---

listpage.jsp

~~~jsp
<div>
    <!-- 1부터 페이지 수만큼 반복 값은 num에 -->
 <c:forEach begin="1" end="${pageNum}" var="num">
    <span>
     <a href="/board/listPage?num=${num}">${num}</a>
  </span>
 </c:forEach>
</div>
~~~

