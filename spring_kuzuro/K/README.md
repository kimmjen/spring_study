# kuzuro 

## mysql
```sql
create database study_board;
use study_board;
// 권한
grant all privileges on *.* to 'test02'@'localhost';
grant all privileges on study_board.* to 'test02'@'localhost';
flush privileges;

// 위에서 생성한 유저 권한 확인
commit;

select * from mysql.user;
```

## table생성
```
create table tbl_board (
	bno int not null auto_increment,
    title varchar(50) not null,
    content text not null,
    writer varchar(30) not null,
    regDate timestamp default now(),
    viewCnt int default 0,
    primary key(bno)
);

commit;
// 확인
select * from tbl_board;
```

## domain
```java
package com.kimmjen.domain;

import java.util.Date;

public class BoardVO {
	
	/*
	 * create table tbl_board ( bno int not null auto_increment, title varchar(50)
	 * not null, content text not null, writer varchar(30) not null, regDate
	 * timestamp default now(), viewCnt int default 0, primary key(bno) );
	 */
	private int bno;
	private String title;
	private String content;
	private String writer;
	private Date regDate;
	private int viewCnt;
	public int getBno() {
		return bno;
	}
	public void setBno(int bno) {
		this.bno = bno;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getWriter() {
		return writer;
	}
	public void setWriter(String writer) {
		this.writer = writer;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	public int getViewCnt() {
		return viewCnt;
	}
	public void setViewCnt(int viewCnt) {
		this.viewCnt = viewCnt;
	}
}

```

## board/pom.xml
```java
<!-- mysql db -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <scope>8.0.21</scope>
</dependency>
<!-- org.mybatis/mybatis -->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.4.1</version>
</dependency>
<!-- mybatis-spring -->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis-spring</artifactId>
    <version>1.3.0</version>
</dependency>
<!-- spring-jdbc -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-jdbc</artifactId>
    <version>${org.springframework-version}</version>
</dependency>
```

## root-context.xml
beans, context, jdbc, mybatis-spring선택

```
<!-- 디비 접근 -->
<bean class="org.springframework.jdbc.datasource.DriverManagerDataSource" id="dataSource">
    <property name="driverClassName" value="com.mysql.jdbc.Driver" />
    <property name="url" value="jdbc:mysql://127.0.0.1:3306/stduy_board" />
    <property name="username" value="test02" />
    <property name="password" value="1111" />
</bean>

<bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
    <property name="dataSource" ref="dataSource" />
    <property name="configLocation" value="classpath:/mybatis-config.xml" />
    <property name="mapperLocations" value="classpath:mappers/**/*Mapper.xml" />
</bean>

<bean id="sqlSession" class="org.mybatis.spring.SqlSessionTemplate" destroy-method="clearCache">
    <constructor-arg name="sqlSessionFactory" ref="sqlSessionFactory" />
</bean>
```

## mybatis-config.xml <- src/main/resources/mybatis-config.xml
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration 
	PUBLIC "-//mybatis.org//DTD Config 3.0//EN" 
	"http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>

</configuration>
```

## mappers 폴더생서 <- src/main/resources/mappers

## boardMapper.xml <- src/main/resources/mappers/boardMapper.xml
> mapper태그 안 namespace는 groupId.artifactId.mappers.study_board(이거는 DB이름)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC 
	"-//mybatis.org//DTD Mapper 3.0//EN" 
	"http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.kimmjen.mappers.DB이름">

</mapper>
```

## 생성한 테이블에 임시 데이터 삽입
```sql
insert into tbl_board(title, content, writer)
	values('테스트 제목1', '테스트 내용', '작성자');
insert into tbl_board(title, content, writer)
	values('테스트 제목2', '테스트 내용', '작성자');
insert into tbl_board(title, content, writer)
	values('테스트 제목3', '테스트 내용', '작성자');
insert into tbl_board(title, content, writer)
	values('테스트 제목4', '테스트 내용', '작성자');
insert into tbl_board(title, content, writer)
	values('테스트 제목5', '테스트 내용', '작성자');
    
commit;

select * from tbl_board;
```

## list.jsp <- views/board/list.jsp
```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 목록</title>
</head>
<body>
	<table>
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성일</th>
				<th>작성자</th>
				<th>조회수</th>
			</tr>
		</thead>
	</table>
</body>
</html>
```

## home.jsp에 게시물 목록 페이지 링크 만들기
```jsp
<p>
	<a hreef="./board/list">게시물목록</a>
</p>
```

이 과정 까지 진행하면 404발생

그이유는 board/list 컨트롤러가 존재하지 않기 때문에

## BoardController.class 만들기 <= com.지정.controller
```java
package com.kimmjen.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/board/*")
public class BoardController {
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public void getList() {
		
	}
}
```

## server 웹 모듈에 들어가서 path를 수정
path: /지정 -> / 변환

## boardMapper.xml: 필요한 컬럼. 매퍼에 쿼리추가
```xml
	<!-- 게시물 목록 -->
	<select id="list" resultType="com.kimmjen.domain.BoardVO" >
		select
			bno, title, content, writer, regDate, viewCnt
		from tbl_board;
	</select>
```

## com.kimmjen + .dao, .service

## BoardDAO 인터페이스 생성
```java
package com.kimmjen.dao;

import java.util.List;

import com.kimmjen.domain.BoardVO;

public interface BoardDAO {
	
	public List<BoardVO> list() throws Exception;

}
```

## BoardDAOImpl.클래스 생성
```java
package com.kimmjen.dao;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.kimmjen.domain.BoardVO;

@Repository
public class BoardDAOImpl implements BoardDAO {
	
	@Inject
	private SqlSession sql;
	
	private static String namesapce = "com.kimmjen.mappers.DB이름";

	// 게시물 목록
	@Override
	public List<BoardVO> list() throws Exception {
		// TODO Auto-generated method stub
		
		return sql.selectList(namesapce + ".list");
	}
}
```

게시물, 즉 tbl_board 1행의 데이터의 형태는 BoardVO와 같다.
게시물목록은 tbl_board가 1행 이상 존재하는 것이므로, BoardVO를 리스트(List) 형태로 만들면 게시물 목록을 받아올 수 있다.

**여기서 boardMapper와 BoardDAOImpl**
의 namespace가 동일하여야 한다.(mappers.DB이름)

## service폴더에 BoardService(interface)와 BoardServiceImpl 생성
BoardService.interface
```java
package com.kimmjen.service;

import java.util.List;

import com.kimmjen.domain.BoardVO;

public interface BoardService {
	
	public List<BoardVO> list() throws Exception;
}

```

BoardServiceImpl.class
```java
package com.kimmjen.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.kimmjen.dao.BoardDAO;
import com.kimmjen.domain.BoardVO;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Inject
	private BoardDAO dao;

	@Override
	public List<BoardVO> list() throws Exception {
		// TODO Auto-generated method stub
		return dao.list();
	}
}
```

## BoardController.class
```java
package com.kimmjen.controller;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.kimmjen.domain.BoardVO;
import com.kimmjen.service.BoardService;

@Controller
@RequestMapping("/board/*")
public class BoardController {
	
	@Inject
	BoardService service;
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public void getList(Model model) throws Exception {
		
		List<BoardVO> list = null;
		list = service.list();
		
		model.addAttribute("list", list);
		
	}	
}
```
`Model`은 컨트롤러(Controller)와 뷰(view)를 연결해주는 역할

## list.jsp
```jsp
</thead>
<tbody>
// jstl 반복문
    <c:forEach items="${list }" var="list">
        <tr>
            <td>${list.bno}</td>
            <td>${list.title}</td>
            <td>${list.regDate}</td>
            <td>${list.writer}</td>
            <td>${list.viewCnt}</td>
        </tr>
    </c:forEach>
</tbody>
```

실행하면 에러발생, 그 이유는 스프링이 BoardDAO와 BoardService를 못참음.

오류
```
타입 예외 보고

메시지 서블릿 [appServlet]을(를) 위한 Servlet.init() 호출이 예외를 발생시켰습니다.

설명 서버가, 해당 요청을 충족시키지 못하게 하는 예기치 않은 조건을 맞닥뜨렸습니다.

예외

javax.servlet.ServletException: 서블릿 [appServlet]을(를) 위한 Servlet.init() 호출이 예외를 발생시켰습니다.
	org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:540)
	org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:92)
	org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:687)
	org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:357)
	org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:382)
	org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:65)
	org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:893)
	org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1726)
	org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)
	org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1191)
	org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:659)
	org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
	java.lang.Thread.run(Unknown Source)
근본 원인 (root cause)

org.springframework.beans.factory.UnsatisfiedDependencyException: Error creating bean with name 'boardController': Unsatisfied dependency expressed through field 'service'; nested exception is org.springframework.beans.factory.NoSuchBeanDefinitionException: No qualifying bean of type 'com.kimmjen.service.BoardService' available: expected at least 1 bean which qualifies as autowire candidate. Dependency annotations: {@javax.inject.Inject()}
	org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor$AutowiredFieldElement.inject(AutowiredAnnotationBeanPostProcessor.java:588)
	org.springframework.beans.factory.annotation.InjectionMetadata.inject(InjectionMetadata.java:88)
	org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor.postProcessPropertyValues(AutowiredAnnotationBeanPostProcessor.java:366)
	org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.populateBean(AbstractAutowireCapableBeanFactory.java:1264)
	org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:553)
	org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:483)
	org.springframework.beans.factory.support.AbstractBeanFactory$1.getObject(AbstractBeanFactory.java:306)
	org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:230)
	org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:302)
	org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:197)
	org.springframework.beans.factory.support.DefaultListableBeanFactory.preInstantiateSingletons(DefaultListableBeanFactory.java:761)
	org.springframework.context.support.AbstractApplicationContext.finishBeanFactoryInitialization(AbstractApplicationContext.java:866)
	org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:542)
	org.springframework.web.servlet.FrameworkServlet.configureAndRefreshWebApplicationContext(FrameworkServlet.java:668)
	org.springframework.web.servlet.FrameworkServlet.createWebApplicationContext(FrameworkServlet.java:634)
	org.springframework.web.servlet.FrameworkServlet.createWebApplicationContext(FrameworkServlet.java:682)
	org.springframework.web.servlet.FrameworkServlet.initWebApplicationContext(FrameworkServlet.java:553)
	org.springframework.web.servlet.FrameworkServlet.initServletBean(FrameworkServlet.java:494)
	org.springframework.web.servlet.HttpServletBean.init(HttpServletBean.java:138)
	javax.servlet.GenericServlet.init(GenericServlet.java:158)
	org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:540)
	org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:92)
	org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:687)
	org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:357)
	org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:382)
	org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:65)
	org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:893)
	org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1726)
	org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)
	org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1191)
	org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:659)
	org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
	java.lang.Thread.run(Unknown Source)
근본 원인 (root cause)

org.springframework.beans.factory.NoSuchBeanDefinitionException: No qualifying bean of type 'com.kimmjen.service.BoardService' available: expected at least 1 bean which qualifies as autowire candidate. Dependency annotations: {@javax.inject.Inject()}
	org.springframework.beans.factory.support.DefaultListableBeanFactory.raiseNoMatchingBeanFound(DefaultListableBeanFactory.java:1486)
	org.springframework.beans.factory.support.DefaultListableBeanFactory.doResolveDependency(DefaultListableBeanFactory.java:1104)
	org.springframework.beans.factory.support.DefaultListableBeanFactory.resolveDependency(DefaultListableBeanFactory.java:1066)
	org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor$AutowiredFieldElement.inject(AutowiredAnnotationBeanPostProcessor.java:585)
	org.springframework.beans.factory.annotation.InjectionMetadata.inject(InjectionMetadata.java:88)
	org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor.postProcessPropertyValues(AutowiredAnnotationBeanPostProcessor.java:366)
	org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.populateBean(AbstractAutowireCapableBeanFactory.java:1264)
	org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:553)
	org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:483)
	org.springframework.beans.factory.support.AbstractBeanFactory$1.getObject(AbstractBeanFactory.java:306)
	org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:230)
	org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:302)
	org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:197)
	org.springframework.beans.factory.support.DefaultListableBeanFactory.preInstantiateSingletons(DefaultListableBeanFactory.java:761)
	org.springframework.context.support.AbstractApplicationContext.finishBeanFactoryInitialization(AbstractApplicationContext.java:866)
	org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:542)
	org.springframework.web.servlet.FrameworkServlet.configureAndRefreshWebApplicationContext(FrameworkServlet.java:668)
	org.springframework.web.servlet.FrameworkServlet.createWebApplicationContext(FrameworkServlet.java:634)
	org.springframework.web.servlet.FrameworkServlet.createWebApplicationContext(FrameworkServlet.java:682)
	org.springframework.web.servlet.FrameworkServlet.initWebApplicationContext(FrameworkServlet.java:553)
	org.springframework.web.servlet.FrameworkServlet.initServletBean(FrameworkServlet.java:494)
	org.springframework.web.servlet.HttpServletBean.init(HttpServletBean.java:138)
	javax.servlet.GenericServlet.init(GenericServlet.java:158)
	org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:540)
	org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:92)
	org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:687)
	org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:357)
	org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:382)
	org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:65)
	org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:893)
	org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1726)
	org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)
	org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1191)
	org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:659)
	org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
	java.lang.Thread.run(Unknown Source)
```

## root-context.xml에 추가
```xml
<context:component-scan base-package="com.kimmjen.domain" />
<context:component-scan base-package="com.kimmjen.dao" />
<context:component-scan base-package="com.kimmjen.service" />
```

위 코드를 입력하면 스프링이 패키지를 찾아서 사용함.

메인 페이지에서 목록 페이지 누르면 

## 오류발생
```
HTTP 상태 500 – 내부 서버 오류
타입 예외 보고

메시지 Request processing failed; nested exception is org.mybatis.spring.MyBatisSystemException: nested exception is org.apache.ibatis.exceptions.PersistenceException:

설명 서버가, 해당 요청을 충족시키지 못하게 하는 예기치 않은 조건을 맞닥뜨렸습니다.

예외

org.springframework.web.util.NestedServletException: Request processing failed; nested exception is org.mybatis.spring.MyBatisSystemException: nested exception is org.apache.ibatis.exceptions.PersistenceException: 
### Error querying database.  Cause: org.springframework.jdbc.CannotGetJdbcConnectionException: Could not get JDBC Connection; nested exception is java.sql.SQLException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
### The error may exist in file [C:\ION_workspace\ION_KOSA\SPRING\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\K\WEB-INF\classes\mappers\boardMapper.xml]
### The error may involve com.kimmjen.mappers.board.list
### The error occurred while executing a query
### Cause: org.springframework.jdbc.CannotGetJdbcConnectionException: Could not get JDBC Connection; nested exception is java.sql.SQLException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
	org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:982)
	org.springframework.web.servlet.FrameworkServlet.doGet(FrameworkServlet.java:861)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:655)
	org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:764)
	org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)
	org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:197)
	org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
근본 원인 (root cause)

org.mybatis.spring.MyBatisSystemException: nested exception is org.apache.ibatis.exceptions.PersistenceException: 
### Error querying database.  Cause: org.springframework.jdbc.CannotGetJdbcConnectionException: Could not get JDBC Connection; nested exception is java.sql.SQLException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
### The error may exist in file [C:\ION_workspace\ION_KOSA\SPRING\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\K\WEB-INF\classes\mappers\boardMapper.xml]
### The error may involve com.kimmjen.mappers.board.list
### The error occurred while executing a query
### Cause: org.springframework.jdbc.CannotGetJdbcConnectionException: Could not get JDBC Connection; nested exception is java.sql.SQLException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
	org.mybatis.spring.MyBatisExceptionTranslator.translateExceptionIfPossible(MyBatisExceptionTranslator.java:79)
	org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:447)
	com.sun.proxy.$Proxy10.selectList(Unknown Source)
	org.mybatis.spring.SqlSessionTemplate.selectList(SqlSessionTemplate.java:223)
	com.kimmjen.dao.BoardDAOImpl.list(BoardDAOImpl.java:25)
	com.kimmjen.service.BoardServiceImpl.list(BoardServiceImpl.java:21)
	com.kimmjen.controller.BoardController.getList(BoardController.java:26)
	sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	java.lang.reflect.Method.invoke(Unknown Source)
	org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:205)
	org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:133)
	org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:97)
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:827)
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:738)
	org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:85)
	org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:963)
	org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:897)
	org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:970)
	org.springframework.web.servlet.FrameworkServlet.doGet(FrameworkServlet.java:861)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:655)
	org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:764)
	org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)
	org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:197)
	org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
근본 원인 (root cause)

org.apache.ibatis.exceptions.PersistenceException: 
### Error querying database.  Cause: org.springframework.jdbc.CannotGetJdbcConnectionException: Could not get JDBC Connection; nested exception is java.sql.SQLException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
### The error may exist in file [C:\ION_workspace\ION_KOSA\SPRING\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\K\WEB-INF\classes\mappers\boardMapper.xml]
### The error may involve com.kimmjen.mappers.board.list
### The error occurred while executing a query
### Cause: org.springframework.jdbc.CannotGetJdbcConnectionException: Could not get JDBC Connection; nested exception is java.sql.SQLException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
	org.apache.ibatis.exceptions.ExceptionFactory.wrapException(ExceptionFactory.java:30)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:150)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:141)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:136)
	sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	java.lang.reflect.Method.invoke(Unknown Source)
	org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:434)
	com.sun.proxy.$Proxy10.selectList(Unknown Source)
	org.mybatis.spring.SqlSessionTemplate.selectList(SqlSessionTemplate.java:223)
	com.kimmjen.dao.BoardDAOImpl.list(BoardDAOImpl.java:25)
	com.kimmjen.service.BoardServiceImpl.list(BoardServiceImpl.java:21)
	com.kimmjen.controller.BoardController.getList(BoardController.java:26)
	sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	java.lang.reflect.Method.invoke(Unknown Source)
	org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:205)
	org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:133)
	org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:97)
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:827)
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:738)
	org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:85)
	org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:963)
	org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:897)
	org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:970)
	org.springframework.web.servlet.FrameworkServlet.doGet(FrameworkServlet.java:861)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:655)
	org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:764)
	org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)
	org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:197)
	org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
근본 원인 (root cause)

org.springframework.jdbc.CannotGetJdbcConnectionException: Could not get JDBC Connection; nested exception is java.sql.SQLException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
	org.springframework.jdbc.datasource.DataSourceUtils.getConnection(DataSourceUtils.java:80)
	org.mybatis.spring.transaction.SpringManagedTransaction.openConnection(SpringManagedTransaction.java:84)
	org.mybatis.spring.transaction.SpringManagedTransaction.getConnection(SpringManagedTransaction.java:70)
	org.apache.ibatis.executor.BaseExecutor.getConnection(BaseExecutor.java:336)
	org.apache.ibatis.executor.SimpleExecutor.prepareStatement(SimpleExecutor.java:84)
	org.apache.ibatis.executor.SimpleExecutor.doQuery(SimpleExecutor.java:62)
	org.apache.ibatis.executor.BaseExecutor.queryFromDatabase(BaseExecutor.java:324)
	org.apache.ibatis.executor.BaseExecutor.query(BaseExecutor.java:156)
	org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:109)
	org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:83)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:148)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:141)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:136)
	sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	java.lang.reflect.Method.invoke(Unknown Source)
	org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:434)
	com.sun.proxy.$Proxy10.selectList(Unknown Source)
	org.mybatis.spring.SqlSessionTemplate.selectList(SqlSessionTemplate.java:223)
	com.kimmjen.dao.BoardDAOImpl.list(BoardDAOImpl.java:25)
	com.kimmjen.service.BoardServiceImpl.list(BoardServiceImpl.java:21)
	com.kimmjen.controller.BoardController.getList(BoardController.java:26)
	sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	java.lang.reflect.Method.invoke(Unknown Source)
	org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:205)
	org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:133)
	org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:97)
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:827)
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:738)
	org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:85)
	org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:963)
	org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:897)
	org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:970)
	org.springframework.web.servlet.FrameworkServlet.doGet(FrameworkServlet.java:861)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:655)
	org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:764)
	org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)
	org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:197)
	org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
근본 원인 (root cause)

java.sql.SQLException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
	com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:129)
	com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:97)
	com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:89)
	com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:63)
	com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:73)
	com.mysql.cj.jdbc.exceptions.SQLExceptionsMapping.translateException(SQLExceptionsMapping.java:76)
	com.mysql.cj.jdbc.ConnectionImpl.createNewIO(ConnectionImpl.java:836)
	com.mysql.cj.jdbc.ConnectionImpl.<init>(ConnectionImpl.java:456)
	com.mysql.cj.jdbc.ConnectionImpl.getInstance(ConnectionImpl.java:246)
	com.mysql.cj.jdbc.NonRegisteringDriver.connect(NonRegisteringDriver.java:197)
	java.sql.DriverManager.getConnection(Unknown Source)
	java.sql.DriverManager.getConnection(Unknown Source)
	org.springframework.jdbc.datasource.DriverManagerDataSource.getConnectionFromDriverManager(DriverManagerDataSource.java:153)
	org.springframework.jdbc.datasource.DriverManagerDataSource.getConnectionFromDriver(DriverManagerDataSource.java:144)
	org.springframework.jdbc.datasource.AbstractDriverBasedDataSource.getConnectionFromDriver(AbstractDriverBasedDataSource.java:196)
	org.springframework.jdbc.datasource.AbstractDriverBasedDataSource.getConnection(AbstractDriverBasedDataSource.java:159)
	org.springframework.jdbc.datasource.DataSourceUtils.doGetConnection(DataSourceUtils.java:111)
	org.springframework.jdbc.datasource.DataSourceUtils.getConnection(DataSourceUtils.java:77)
	org.mybatis.spring.transaction.SpringManagedTransaction.openConnection(SpringManagedTransaction.java:84)
	org.mybatis.spring.transaction.SpringManagedTransaction.getConnection(SpringManagedTransaction.java:70)
	org.apache.ibatis.executor.BaseExecutor.getConnection(BaseExecutor.java:336)
	org.apache.ibatis.executor.SimpleExecutor.prepareStatement(SimpleExecutor.java:84)
	org.apache.ibatis.executor.SimpleExecutor.doQuery(SimpleExecutor.java:62)
	org.apache.ibatis.executor.BaseExecutor.queryFromDatabase(BaseExecutor.java:324)
	org.apache.ibatis.executor.BaseExecutor.query(BaseExecutor.java:156)
	org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:109)
	org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:83)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:148)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:141)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:136)
	sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	java.lang.reflect.Method.invoke(Unknown Source)
	org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:434)
	com.sun.proxy.$Proxy10.selectList(Unknown Source)
	org.mybatis.spring.SqlSessionTemplate.selectList(SqlSessionTemplate.java:223)
	com.kimmjen.dao.BoardDAOImpl.list(BoardDAOImpl.java:25)
	com.kimmjen.service.BoardServiceImpl.list(BoardServiceImpl.java:21)
	com.kimmjen.controller.BoardController.getList(BoardController.java:26)
	sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	java.lang.reflect.Method.invoke(Unknown Source)
	org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:205)
	org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:133)
	org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:97)
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:827)
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:738)
	org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:85)
	org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:963)
	org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:897)
	org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:970)
	org.springframework.web.servlet.FrameworkServlet.doGet(FrameworkServlet.java:861)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:655)
	org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:764)
	org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)
	org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:197)
	org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
근본 원인 (root cause)

com.mysql.cj.exceptions.InvalidConnectionAttributeException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
	sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
	sun.reflect.NativeConstructorAccessorImpl.newInstance(Unknown Source)
	sun.reflect.DelegatingConstructorAccessorImpl.newInstance(Unknown Source)
	java.lang.reflect.Constructor.newInstance(Unknown Source)
	com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:61)
	com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:85)
	com.mysql.cj.util.TimeUtil.getCanonicalTimezone(TimeUtil.java:132)
	com.mysql.cj.protocol.a.NativeProtocol.configureTimezone(NativeProtocol.java:2120)
	com.mysql.cj.protocol.a.NativeProtocol.initServerSession(NativeProtocol.java:2143)
	com.mysql.cj.jdbc.ConnectionImpl.initializePropsFromServer(ConnectionImpl.java:1310)
	com.mysql.cj.jdbc.ConnectionImpl.connectOneTryOnly(ConnectionImpl.java:967)
	com.mysql.cj.jdbc.ConnectionImpl.createNewIO(ConnectionImpl.java:826)
	com.mysql.cj.jdbc.ConnectionImpl.<init>(ConnectionImpl.java:456)
	com.mysql.cj.jdbc.ConnectionImpl.getInstance(ConnectionImpl.java:246)
	com.mysql.cj.jdbc.NonRegisteringDriver.connect(NonRegisteringDriver.java:197)
	java.sql.DriverManager.getConnection(Unknown Source)
	java.sql.DriverManager.getConnection(Unknown Source)
	org.springframework.jdbc.datasource.DriverManagerDataSource.getConnectionFromDriverManager(DriverManagerDataSource.java:153)
	org.springframework.jdbc.datasource.DriverManagerDataSource.getConnectionFromDriver(DriverManagerDataSource.java:144)
	org.springframework.jdbc.datasource.AbstractDriverBasedDataSource.getConnectionFromDriver(AbstractDriverBasedDataSource.java:196)
	org.springframework.jdbc.datasource.AbstractDriverBasedDataSource.getConnection(AbstractDriverBasedDataSource.java:159)
	org.springframework.jdbc.datasource.DataSourceUtils.doGetConnection(DataSourceUtils.java:111)
	org.springframework.jdbc.datasource.DataSourceUtils.getConnection(DataSourceUtils.java:77)
	org.mybatis.spring.transaction.SpringManagedTransaction.openConnection(SpringManagedTransaction.java:84)
	org.mybatis.spring.transaction.SpringManagedTransaction.getConnection(SpringManagedTransaction.java:70)
	org.apache.ibatis.executor.BaseExecutor.getConnection(BaseExecutor.java:336)
	org.apache.ibatis.executor.SimpleExecutor.prepareStatement(SimpleExecutor.java:84)
	org.apache.ibatis.executor.SimpleExecutor.doQuery(SimpleExecutor.java:62)
	org.apache.ibatis.executor.BaseExecutor.queryFromDatabase(BaseExecutor.java:324)
	org.apache.ibatis.executor.BaseExecutor.query(BaseExecutor.java:156)
	org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:109)
	org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:83)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:148)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:141)
	org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:136)
	sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	java.lang.reflect.Method.invoke(Unknown Source)
	org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:434)
	com.sun.proxy.$Proxy10.selectList(Unknown Source)
	org.mybatis.spring.SqlSessionTemplate.selectList(SqlSessionTemplate.java:223)
	com.kimmjen.dao.BoardDAOImpl.list(BoardDAOImpl.java:25)
	com.kimmjen.service.BoardServiceImpl.list(BoardServiceImpl.java:21)
	com.kimmjen.controller.BoardController.getList(BoardController.java:26)
	sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	java.lang.reflect.Method.invoke(Unknown Source)
	org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:205)
	org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:133)
	org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:97)
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:827)
	org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:738)
	org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:85)
	org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:963)
	org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:897)
	org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:970)
	org.springframework.web.servlet.FrameworkServlet.doGet(FrameworkServlet.java:861)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:655)
	org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)
	javax.servlet.http.HttpServlet.service(HttpServlet.java:764)
	org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)
	org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:197)
	org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
비고 근본 원인(root cause)의 풀 스택 트레이스를, 서버 로그들에서 확인할 수 있습니다.

Apache Tomcat/9.0.53
```
리스트를 불러올 수 없다는 이유.<br>

## mysql 오류
```
로 []의 컨텍스트 내의 서블릿 [appServlet]을(를) 위한 Servlet.service() 호출이, 근본 원인(root cause)과 함께, 예외 [Request processing failed; nested exception is org.mybatis.spring.MyBatisSystemException: nested exception is org.apache.ibatis.exceptions.PersistenceException: 
### Error querying database.  Cause: org.springframework.jdbc.CannotGetJdbcConnectionException: Could not get JDBC Connection; nested exception is java.sql.SQLException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
### The error may exist in file [C:\ION_workspace\ION_KOSA\SPRING\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\K\WEB-INF\classes\mappers\boardMapper.xml]
### The error may involve com.kimmjen.mappers.board.list
### The error occurred while executing a query
### Cause: org.springframework.jdbc.CannotGetJdbcConnectionException: Could not get JDBC Connection; nested exception is java.sql.SQLException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.]을(를) 발생시켰습니다.
com.mysql.cj.exceptions.InvalidConnectionAttributeException: The server time zone value '���ѹα� ǥ�ؽ�' is unrecognized or represents more than one time zone. You must configure either the server or JDBC driver (via the 'serverTimezone' configuration property) to use a more specifc time zone value if you want to utilize time zone support.
	at sun.reflect.NativeConstructorAccessorImpl.newInstance0(Native Method)
	at sun.reflect.NativeConstructorAccessorImpl.newInstance(Unknown Source)
	at sun.reflect.DelegatingConstructorAccessorImpl.newInstance(Unknown Source)
	at java.lang.reflect.Constructor.newInstance(Unknown Source)
	at com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:61)
	at com.mysql.cj.exceptions.ExceptionFactory.createException(ExceptionFactory.java:85)
	at com.mysql.cj.util.TimeUtil.getCanonicalTimezone(TimeUtil.java:132)
	at com.mysql.cj.protocol.a.NativeProtocol.configureTimezone(NativeProtocol.java:2120)
	at com.mysql.cj.protocol.a.NativeProtocol.initServerSession(NativeProtocol.java:2143)
	at com.mysql.cj.jdbc.ConnectionImpl.initializePropsFromServer(ConnectionImpl.java:1310)
	at com.mysql.cj.jdbc.ConnectionImpl.connectOneTryOnly(ConnectionImpl.java:967)
	at com.mysql.cj.jdbc.ConnectionImpl.createNewIO(ConnectionImpl.java:826)
	at com.mysql.cj.jdbc.ConnectionImpl.<init>(ConnectionImpl.java:456)
	at com.mysql.cj.jdbc.ConnectionImpl.getInstance(ConnectionImpl.java:246)
	at com.mysql.cj.jdbc.NonRegisteringDriver.connect(NonRegisteringDriver.java:197)
	at java.sql.DriverManager.getConnection(Unknown Source)
	at java.sql.DriverManager.getConnection(Unknown Source)
	at org.springframework.jdbc.datasource.DriverManagerDataSource.getConnectionFromDriverManager(DriverManagerDataSource.java:153)
	at org.springframework.jdbc.datasource.DriverManagerDataSource.getConnectionFromDriver(DriverManagerDataSource.java:144)
	at org.springframework.jdbc.datasource.AbstractDriverBasedDataSource.getConnectionFromDriver(AbstractDriverBasedDataSource.java:196)
	at org.springframework.jdbc.datasource.AbstractDriverBasedDataSource.getConnection(AbstractDriverBasedDataSource.java:159)
	at org.springframework.jdbc.datasource.DataSourceUtils.doGetConnection(DataSourceUtils.java:111)
	at org.springframework.jdbc.datasource.DataSourceUtils.getConnection(DataSourceUtils.java:77)
	at org.mybatis.spring.transaction.SpringManagedTransaction.openConnection(SpringManagedTransaction.java:84)
	at org.mybatis.spring.transaction.SpringManagedTransaction.getConnection(SpringManagedTransaction.java:70)
	at org.apache.ibatis.executor.BaseExecutor.getConnection(BaseExecutor.java:336)
	at org.apache.ibatis.executor.SimpleExecutor.prepareStatement(SimpleExecutor.java:84)
	at org.apache.ibatis.executor.SimpleExecutor.doQuery(SimpleExecutor.java:62)
	at org.apache.ibatis.executor.BaseExecutor.queryFromDatabase(BaseExecutor.java:324)
	at org.apache.ibatis.executor.BaseExecutor.query(BaseExecutor.java:156)
	at org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:109)
	at org.apache.ibatis.executor.CachingExecutor.query(CachingExecutor.java:83)
	at org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:148)
	at org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:141)
	at org.apache.ibatis.session.defaults.DefaultSqlSession.selectList(DefaultSqlSession.java:136)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	at java.lang.reflect.Method.invoke(Unknown Source)
	at org.mybatis.spring.SqlSessionTemplate$SqlSessionInterceptor.invoke(SqlSessionTemplate.java:434)
	at com.sun.proxy.$Proxy10.selectList(Unknown Source)
	at org.mybatis.spring.SqlSessionTemplate.selectList(SqlSessionTemplate.java:223)
	at com.kimmjen.dao.BoardDAOImpl.list(BoardDAOImpl.java:25)
	at com.kimmjen.service.BoardServiceImpl.list(BoardServiceImpl.java:21)
	at com.kimmjen.controller.BoardController.getList(BoardController.java:26)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(Unknown Source)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(Unknown Source)
	at java.lang.reflect.Method.invoke(Unknown Source)
	at org.springframework.web.method.support.InvocableHandlerMethod.doInvoke(InvocableHandlerMethod.java:205)
	at org.springframework.web.method.support.InvocableHandlerMethod.invokeForRequest(InvocableHandlerMethod.java:133)
	at org.springframework.web.servlet.mvc.method.annotation.ServletInvocableHandlerMethod.invokeAndHandle(ServletInvocableHandlerMethod.java:97)
	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.invokeHandlerMethod(RequestMappingHandlerAdapter.java:827)
	at org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter.handleInternal(RequestMappingHandlerAdapter.java:738)
	at org.springframework.web.servlet.mvc.method.AbstractHandlerMethodAdapter.handle(AbstractHandlerMethodAdapter.java:85)
	at org.springframework.web.servlet.DispatcherServlet.doDispatch(DispatcherServlet.java:963)
	at org.springframework.web.servlet.DispatcherServlet.doService(DispatcherServlet.java:897)
	at org.springframework.web.servlet.FrameworkServlet.processRequest(FrameworkServlet.java:970)
	at org.springframework.web.servlet.FrameworkServlet.doGet(FrameworkServlet.java:861)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:655)
	at org.springframework.web.servlet.FrameworkServlet.service(FrameworkServlet.java:846)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:764)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:227)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:162)
	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:53)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:189)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:162)
	at org.springframework.web.filter.CharacterEncodingFilter.doFilterInternal(CharacterEncodingFilter.java:197)
	at org.springframework.web.filter.OncePerRequestFilter.doFilter(OncePerRequestFilter.java:107)
	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:189)
	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:162)
	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:197)
	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:97)
	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:540)
	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:135)
	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:92)
	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:687)
	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:78)
	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:357)
	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:382)
	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:65)
	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:893)
	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1726)
	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:49)
	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1191)
	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:659)
	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:61)
	at java.lang.Thread.run(Unknown Source)
```
## root-context.xml
```
`DB이름`?serverTimezone=Asia/Seoul

<property name="url" value="jdbc:mysql://127.0.0.1:3306/study_board?serverTimezone=Asia/Seoul" />
```

## 게시물 작성
1. write.jsp 작성
```jsp
바디 안에
<form>
    <label>제목</label>
    <input tpye="text" name="title" /><br/>
    
    <label>작성자</label>
    <input tpye="text" name="writer" /><br/>
    
    <label>내용</label>
    <textarea cols="50" rows="5" name="content"></textarea><br/>
    
    <button tpye="submit">등록</button>
</form>
```

2. BoardController.class
```java
// 게시물 작성
	@RequestMapping(value = "/write", method = RequestMethod.GET)
	public void getWrite() throws Exception {
		
	}
```

3. home.jsp 링크추가
```jsp
<p>
    ...
	<a href="./board/write">게시물 작성</a>
</p>
```

4. DB에 테스트 데이터 입력
```mysql
insert into tbl_board(title, content, writer)
	values('test title', 'test content', 'test writer');
    
commit;
select * from tbl_board;
```

> list를 불러올때는 resultType 사용했고, write할때는 parameterTpye을 사용하였다. 그 이유는 resultType은 데이터 쿼리를 실행한 뒤 결과가 있을 경우에 사용되고. parameterType은 데이터를 입력(삽입)할 때 사용된다.

5. boardMapper.xml에 insert문 입력
```xml
<!-- 게시물 작성 -->
<insert id="write" parameterType="com.kimmjen.domain.BoardVO">
    insert into tbl_board(title, content, writer)
    values(#{title}, #{writer}, #{content});
</insert>
```

6. BoardDAO.interface에 게시물 작성용 메서드 추가

boardDAO.java

```java
// 게시물 등록
	public void write(BoardVO vo) throws Exception;
```

6-1. BoardDAOImpl.class에
boardDAOImpl.java
```java
// 게시물 작성
@Override
public void write(BoardVO vo) throws Exception {
    // TODO Auto-generated method stub
    
    sql.insert(namesapce + ".write", vo);
    
}
```

7. 6.과 같이 BoardService와 BoardServiceImpl도 추가

boardService.java

```java
// 게시물 작성
package com.kimmjen.service;

import java.util.List;

import com.kimmjen.domain.BoardVO;

public interface BoardService {
	
	// 게시물 리스트
	public List<BoardVO> list() throws Exception;
	
	// 게시물 작성
	public void write(BoardVO vo) throws Exception;
	
}

```

boardServiceImpl.java
```java
package com.kimmjen.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.kimmjen.dao.BoardDAO;
import com.kimmjen.domain.BoardVO;

@Service
public class BoardServiceImpl implements BoardService {
	
	@Inject
	private BoardDAO dao;

	// 게시물 리스트
	@Override
	public List<BoardVO> list() throws Exception {
		// TODO Auto-generated method stub
		return dao.list();
	}
	
	// 게시물 작성
	@Override
	public void write(BoardVO vo) throws Exception {
		// TODO Auto-generated method stub
		dao.write(vo);
		
	}

}

```

8. BoardController에도 post 메서드 추가

```java
// 게시물 작성
@RequestMapping(value = "/write", method = RequestMethod.POST)
public String postWrite(BoardVO vo) throws Exception {
    
    service.write(vo);
    
    return "redirect:/board/list";
}
```

## 게시물 조회

1. write.jsp 를 복사하여 view.jsp로 붙여넣기

view.jsp

```
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 조회</title>
</head>
<body>
	<form method="post">
		<label>제목</label>
		<input tpye="text" name="title" /><br/>
		
		<label>작성자</label>
		<input tpye="text" name="writer" /><br/>
		
		<label>내용</label>
		<textarea cols="50" rows="5" name="content"></textarea><br/>
		
	</form>
</body>
</html>
```

2. boardcontroller에 조회용 겟메서드 작성

boardcontroller.java

```java
// 게시물 조회
@RequestMapping(value = "/view", method = RequestMethod.GET)
public void getView() throws Exception {

}
```

게시물을 구분하는 방법은 여러가지가 있지만, 보편적으로 게시물에 고유번호(또는 문자)를 이용해서 구분.

## list.jsp 제목태그 수정

```jsp
<td>${list.title}</td>

<td>
    <a href="/board/view?bno=${list.bno}">${list.title}</a>
</td>
```

## DB에서 먼저 테스트
```sql
select
	bno, title, content, writer, regDate, viewCnt
from
	tbl_board
where
	bno = 1;
```

## boardMapper.xml 게시물조회 쿼리 작성
```xml
select
	bno, title, content, writer, regDate, viewCnt
from
	tbl_board
where
	bno = 1;
```

## 게시물조회관련 DAO, DAOImle, Service, ServiceImpl 사용
boardDAO.interface
```java
// 게시물 조회
	public BoardVO view(int bno) throws Exception;
```

boardDAOImpl.class
```java
// 게시물 조회
	@Override
	public BoardVO view(int bno) throws Exception {
		// TODO Auto-generated method stub
		return sql.selectOne(namesapce + ".view", bno);
	}
```

boardService.interface
```java
// 게시물 조회
public BoardVO view(int bno) throws Exception;
```

boardServiceImple.class
```java
// 게시물 조회
@Override
public BoardVO view(int bno) throws Exception {
    // TODO Auto-generated method stub
    return dao.view(bno);
}
```

boardController.java
```java
// 게시물 조회
@RequestMapping(value = "/view", method = RequestMethod.GET)
public void getView() throws Exception {
    
    service.view(bno);
}

// 게시물 조회
@RequestMapping(value = "/view", method = RequestMethod.GET)
public void getView(@RequestParam("bno") int bno, Model model) throws Exception {
    
    BoardVO vo = service.view(vo);
    
    model.addAttribute("view", vo);

}
```
## view.jsp
```jsp
<form method="post">
    <label>제목</label>
    <input tpye="text" name="title" value="${view.title }"/><br/>
    
    <label>작성자</label>
    <input tpye="text" name="writer" value="${view.writer }"/><br/>
    
    <label>내용</label>
    <textarea cols="50" rows="5" name="content">${view.content }</textarea><br/>
    
    <div>
        <a href="/board/modify?bno=${view.bno }">게시물 수정</a>
    </div>
    
</form>

or

<label>제목</label>
${view.title}<br />

<label>작성자</label>
${view.writer}<br />

<label>내용</label><br />
${view.content}<br />
```

## 수정하기

modify.jsp

```java
<form method="post">
    <label>제목</label>
    <input tpye="text" name="title" /><br/>
    
    <label>작성자</label>
    <input tpye="text" name="writer" /><br/>
    
    <label>내용</label>
    <textarea cols="50" rows="5" name="content"></textarea><br/>
    
    <button tpye="submit">완료</button>
</form>
```

boardController.java<br>
수정용 겟 메서드 추가

```java
// 게시물 수정
@RequestMapping(value = "/modify", method = RequestMethod.GET)
public void getModify() throws Exception {
    
}
```

view.jsp
```jsp
<div>
    <a href="/board/modify?bno=${view.bno }">게시물 수정</a>
</div>
```

게시물 수정을 눌렀으나 해당 내용이 존재하기 않기 때문에,
게시물 조회에서 사용된 메서드 이용한다.

boardController.java

```java
// 게시물 수정
@RequestMapping(value = "/modify", method = RequestMethod.GET)
public void getModify(@RequestParam("bno") int bno, Model model) throws Exception {
    
    BoardVO vo = service.view(bno);
    
    model.addAttribute("view", vo);
}
```

modify.jsp
```jsp
<form method="post">
    <label>제목</label>
    <input tpye="text" name="title" value="${view.title }" /><br/>
    
    <label>작성자</label>
    <input tpye="text" name="writer" value="${view.writer }" /><br/>
    
    <label>내용</label>
    <textarea cols="50" rows="5" name="content">${view.content}</textarea><br/>
    
    <button tpye="submit">완료</button>
</form>
```

수정 sql
```sql
update tbl_board
	set
		title = "수정된 테스트 제목1",
        content = "수정된 테스트 내용",
        writer = "수정된 작성자"
	where bno = 1;
    
select * from tbl_board;
```

수정용 쿼리를 boardMapper.xml에 추가
```xml
<!-- 게시물 수정 -->
<update id="modify" parameterType="com.kimmjen.domain.BoardVO">
    update tbl_board
        set
            title = #{title},
            content = #{content},
            writer = #{writer}
        where bno = #{bno};
</update>
```

dao, service, impl

boardDAO.interface
```java
// 게시물 수정
	public void modify(BoardVO vo) throws Exception;
```

boardDAOImple.class
```java
// 게시물 수정
@Override
public void modify(BoardVO vo) throws Exception {
    // TODO Auto-generated method stub
    sql.update(namesapce + ".modify", vo);
    
}
```

boardService.interface
```java
// 게시물 수정
public void modify(BoardVO vo) throws Exception;
```

boardSerivceImpl.class
```java
// 게시물 수정
@Override
public void modify(BoardVO vo) throws Exception {
    // TODO Auto-generated method stub
    dao.modify(vo);
}
```

boardcontroller.class
```java
// 게시물 수정
@RequestMapping(value = "/modify", method = RequestMethod.POST)
public String postModify(BoardVO vo) throws Exception {
    
    service.modify(vo);
    
    return "redirect:/board/view?bno=" + vo.getBno();
}

```

## 메뉴 include 

views에 include라는 폴더생성 후 nav.jsp 파일생성<br>
```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<ul>
	<li>
		<a href="/board/list">글 목록</a>
	</li>
	
		<li>
		<a href="/board/write">글 작성</a>
	</li>
</ul>
```

list, write, view, modify의 body 안에
```jsp
<div id="nav">
	<%@ include file="../include/nav.jsp" %>
</div>
```

날짜 포맷 변경하는 방식 누락<br>

list.jsp
```jsp
상단에
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<%-- <td>${list.regDate}</td> --%>

변경
<td>
    <fmt:formatDate value="${list.regDate }" patten="yyyy-MM-dd" />
</td>
```

## 삭제 구현
view.jsp
```jsp
<a href="/board/delete?bno=${view.bno}">게시물 삭제</a>
```

DB에 확인하기<br>
```sql
delete 
	from tbl_board
where bno = 2;

select * from tbl_board;
```

boradMapper.xml 에 추가
```xml
<!-- 게시물 삭제 -->
<delete id="delete" parameterType="int">
    delete
        from tbl_board
    where bno = #{bno};
</delete>
```

dao, service + impl 에도 삭제 메서드 코드 추가

boardDAO
```java
// 게시물 삭제
public void delete(int bno) throws Exception;
```

boardDAOImpl
```java
// 게시물 삭제
@Override
public void delete(int bno) throws Exception {
    // TODO Auto-generated method stub
    sql.delete(namesapce + ".delete", bno);
}
```

boardService
```java
// 게시물 삭제
public void delete(int bno) throws Exception;
```

boardServiceImpl
```java
// 게시물 삭제
@Override
public void delete(int bno) throws Exception {
    // TODO Auto-generated method stub
    dao.delete(bno);
    
}
```

boardController.class
```java
// 게시물 삭제
@RequestMapping(value = "/delete", method = RequestMethod.GET)
public String getDelete(@RequestParam("bno") int bno) throws Exception {
    
    service.delete(bno);
    
    return "redirect:/board/list";
}
```