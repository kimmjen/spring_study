# [Vue.js로 Todo List 만들기](https://blog.storyg.co/vue-js-posts/todos-tutorial)

## 1. 환경설정



1. [npm 설치](https://nodejs.org/dist/v14.17.6/node-v14.17.6-x64.msi)
2. cmd/vscode console -> npm install vue-cli -g
3. vue init webpack todos-client

```
? Project name todos-client
? Project description A Vue.js project
? Author storyg <blog@storyg.co>
? Vue build standalone
? Install vue-router? Yes
? Use ESLint to lint your code? No
? Setup unit tests with Karma + Mocha? No
? Setup e2e tests with Nightwatch? No
```

```
cd todo-client
     npm install
     npm run dev
```

---

## 2. 코드

index.html

```vue
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>todos-client</title>
  </head>
  <body>
    <div id="app"></div>//이 div태그가 동적으로 변화함
    <!-- built files will be auto injected -->
  </body>
</html>
```



app.vue

```vue
<template>//실질적으로 보여질 코드
  <div id="app">//같은 아이디의 div가 교체되는 것으로 보인다.
    <img src="./assets/logo.png">
    <router-view/>//페이지 이동시 이 자리에 그려진다.
  </div>
</template>

<script>
export default {
  name: 'app'//app이라는 이름으로 반환? 중요하지 않음
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
```



router/index.js

```js
import Vue from 'vue'
import Router from 'vue-router'
import HelloWorld from '@/components/HelloWorld'
//import된 이름으로 해당 위치에 맞는 componet를 불러온다
Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',//경로
      name: 'Hello',//아마 다른 곳에서 사용할때,...? 경로를 외부에서 바꾼다거나 하는듯
      component: HelloWorld//return값
    },
    {
      path: '/example',
      name: 'example',
      component: HelloWorld
    }
  ]
});
```





Todopage.vue

```vue
<template>
<div class="container">
  <h2>Todo List</h2>
  <div class="input-group" style="margin-bottom:10px;">
    <input type="text" class="form-control" placeholder="할일을 입력하세요" v-model="name" v-on:keyup.enter="createTodo(name)">//enter시 매핑
    <span class="input-group-btn">
      <button class="btn btn-default" type="button" @click="createTodo (name)">추가</button>//onclick 매핑
    </span>
  </div>
  <ul class="list-group">
      
    <li class="list-group-item" v-for="(todo, index) in todos" v-bind:key="index">
    <input class="form-check-input" type="checkbox">
    {{todo.name}}
      <div class="btn-group pull-right" 
        style="font-size: 12px; line-height: 1;">
        <button type="button" 
        class="btn-link dropdown-toggle" 
        data-toggle="dropdown" 
        aria-haspopup="true" 
        aria-expanded="false">
          더보기<span class="caret"></span>
        </button>
        <ul class="dropdown-menu">
          <li><a href="#" @click="deleteTodo(index)">삭제</a></li>
        </ul>
      </div>
    </li>
  </ul>
</div>
</template>

<script>
export default {
	name: 'TodoPage',
	data () {//호출시 기본값?
		return {
			name:null,
			todos: [{name:'청소'},{name:'블로그 쓰기'},{name:'밥먹기'},{name:'안녕'}]
		}
	},
	methods:{
		deleteTodo(i){//array 잘라내기
			this.todos.splice(i,1);
		},
		createTodo(name){
			if(name != null){//빈값이 아니면 todos에 리스트 추가하고 다시 빈값으로
				this.todos.push({name:name});
				this.name = null
			}
		},
        
	}
}
</script>
```

