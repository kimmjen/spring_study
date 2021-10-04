# Vue + Spring Boot study(가제)

<img src="https://wikibook.co.kr/images/cover/l/9791158391850.jpg" alt="실전! 스프링 5와 Vue.js 2로 시작하는 모던 웹 애플리케이션 개발: 스프링 부트와 Vuex를 활용한 실습 중심의 풀스택 웹  애플리케이션 개발 | 위키북스" style="zoom:50%;" />

---

## 02 Vue.js 2 - 기대한 방식으로 동작한다 part2 (p.71~85)

### 1. 지시자(Directives)

지시자는 표현식의 값이 변경될 때 이에 반응해 DOM에 변경 사항을 적용한다 - Singleton Web에서 중요한 기능.

v-for 지시자: 원본데이터를 기반으로 요소나 데이터 블록을 여러번 렌더링한다.

v-on(@:): 리스너(이벤트)를 DOM (태그)요소에 부착한다.

스프링 AOP의 Advice, Aspect 정도로 생각할 수 있다!



사용자 정의 지시자를 만들 수 있으며, 객체 생성 후 Vue.directive()를 이용해 전역등록하거나 컴포넌트에 directives 프로퍼티에 로컬로 등록한다.



지시자 객체 내에 훅함수를 추가할 수 있다.

1. bind - 처음 바인딩 되었을 때 한번 호출되며, 일회성 설정(초기화 등)을 수행할 수 있다.

2. inserted - 바인딩 된 요소가 부모 노드에 삽입되었을 때 호출된다. 이 시점에 부모노드는 DOM에 부착되지 않았을 수도 있다.

   1. ch->p 시점에 동작, p ->DOM(X) 일 수 있다.

      

3. update - 컴포넌트의 vnode가 업데이트 됐을 때(변경사항이 있을 때) 호출된다. 자식 vnode가 업데이트되기 전에 호출될 수 있다.

   

4. ComponentUpdated - Vnode가 업데이트 된 **후에** 호출된다.

   

5. unbind - 바인딩이 해제될 때 한번 호출된다.



```js
Vue.directive("focus", {//v-focus 라는 이름으로 등록,
  inserted: function (el) {//초점을 맞추는 지점이 index이기 때문에 DOM에 삽입되는 시점 insertd
    el.focus();//해당 지시자가 있는 vnode에 초점을 둔다.
  },
});

```



---

### 2. 필터

Vue 애플리케이션에서는 필터를 이용하여 이중괄호 {{}} 혹은 v-bind를 이용할 때 텍스트 형식을 지정한다.

필터는 표현식의 값을 첫인자로 가지는 js 함수로, 필터를 등록하는 두가지 방법이 있다.

1. Vue.filter() 전역등록
2. 컴포넌트의 options객체로 filters 프로퍼티 로컬등록

```js
Vue.filter("datetime", function (value, pattern) {//필터를 datetime으로 등록
  if (!value) return "";//값이 없는 경우 ""
  return formatter.format(value); //값이 있는 경우 생략한 format으로 값을 수정하여 반환
});

```



실제 값이 표현되는 MessageListItem.js에 import하지 않고, index.html에서 import한다.

이는 실제로 값을 바꾸어 저장하거나, 출력하는 것이 아닌 필터를 통해 최종 출력시의 형식만 변경하기 때문에 최종 조합된 상태에서 사용하기 때문인것으로 보인다.



```js
template: `<li>{{item.text}} - {{item.createdAt|datetime('MM/DD/YYYY')}}
        <button @click="deleteClicked">x</button></li>`,
```

| 를 통해 datetime 필터를 등록한다. {{}}를 통해 filter가 적용될 요소임을 알 수 있고, | 뒤에 오는 이름의 필터가 적용될 것이란 것을 알 수 있다.



---

### 3. 믹스인

코드를 재사용 하는 방법 중 하나이다.

모든 컴포넌트의 옵션을 포함할 수 있는 js 객체로, Vue.js는 컴포넌트의  options 객체에 믹스인을 혼합한다.

컴포넌트의 외부 프로퍼티 처럼 생각하면 될 것으로 보인다.



컴포넌트의 설정과 겹치는 경우 Vue.js의 설정에 따라 다르게 병합한다.

created() 훅을 포함하면, 두 메소드를 배열에 넣어 ***믹스인의*** 메소드를 먼저 호출한다.

둘다 객체값을 요구하는 옵션을 포함한다면. Vue.js는 옵션들을 같은 객체에 병합하고 컴포넌트를 우선적으로 한다.



***믹스인 또한 전역, 로컬로 설정할 수 있으며, 컴포넌트와 필터, 지시자와는 달리 선언하여 사용하지 않고 전역 등록시 바로 적용이 되므로, 사용에 주의가 필요하다.***

---

### 4. 플러그인

플러그인은 Vue.js 프레임워크에서 확장성을 제공하는 방법이다.

플러그인을 만드는 방법은 install(vue생성자, options 객체) 메소드를 갖는 객체를 만든다.

첫 인자는 기능이 적용될 위치, 두번째 인자는 플러그인을 구성하는데 사용할 옵션을 정의할 수 있다.



install 메소드 내에서 정적 메소드나 프로퍼티를 vue 생성자에 추가할 수 있으며, 지시자,필터,컴포넌트,믹스인 또한 추가할 수 있다.

```js
export default {
  install(Vue, options) {//vue.use로 호출한 vue객체의 vue와 option
    Object.assign(switchers, options);//생략된 switchers 객체를 option에 병합한다.
    Vue.mixin({//호출한 vue의 믹스인에 이하 내용을 삽입,병합한다.
      created() {
        if (switchers.created) {
          console.log(`${this.$options.name} created`);
        }
      }
    });
  },
};
```

```js
import LifecycleLogger from './plugins/lifecycle-logger.plugin.js';
Vue.use(LifecycleLogger, { beforeMount: false })// use로 플러그인을 등록하고, 값을 변경할 수 있다.
```

---

### 5. 반응형 시스템

Vue.js의 강력함은 반응형데이터 바인딩 시스템으로부터 비롯된다.

데이터와 뷰를 동기화된 상태로 유지하는데 신경을 쓸 필요가 없다.

![image](https://user-images.githubusercontent.com/65153512/135800191-fc5caeb5-1cf0-483a-815f-cd5e21eebf4f.png)

1. Vue.js는 렌더 와처를 생성해 render 함수의 의존 관계에 있는 프로퍼티를 수집한다
2. 프로퍼티의 값을 변경할 때 마다 렌더 와처에 이를 통지하고,  
3. 렌더 와처 DOM을 업데이트 하기 위해 render 함수를 트리거 한다.

---

vue.js가 인스턴스를 초기화할 때 실제 데이터를 저장하기 위해 vm._data를 만들고, Object.defineProperty로 게터와 세터를 정의해 프로퍼티에 접근하는 프록시를 만든다. 이렇게 해서 vm.messages에 접근하려하면 프록시에 의해 vm._data.messages로 접근한다.

따라서 프로퍼티위 반응성은 vm._data에서 발생한다.



Vue.js는 observer객체를 생성하여 vm.__data. _ob_ _ 로 할당하여 관찰 대상으로 표시한다. 이 객체는 모든 프로퍼티를 처리한다.



게터와 세터는 배열의 변경사항을 알 수 없다. getter는 vm._data.messages 를 통해 접근할 때 호출되고, setter는 vm._data.messages.push()가 아닌 vm._data.messages=[...]로 접근할 때 호출되기 때문이다.

vue는 배열의 변경을 알기 위해서 또다른 observer객체를 만들어 배열 객체에 할당한다. vue는 각 배열 함수를 와처에 데이터 변경을 통지하도록 변경한다.

messages안에는 값 뿐만 아니라 message객체도 있으므로 각 객체에도 observer를 할당한다. 이 객체는 자동으로 프로퍼티를 검사하여 getter/setter를 정의한다.

---

#### vue가 변경 내용을 추적할 수 없는 유형이 있다.

1. vm.messages[itemIndex] = newItem 처럼 인덱스를 통해 배열에 접근하는 것.
2. vm.messages.length = 10; 처럼 배열의 길이를 수정하는 것이다.

이를 방지하려면 push나 splice를 사용해야 한다.

혹은, 객체에 새로운 프로퍼티를 추가하거나 삭제하는 방법이 있다.

---

#### Vue에서 computed 프로퍼티를 처리하는 것은 data객체와는 다르다.

예제의 addDisabled에 대해 지연 와처를 생성한고, 맵의 일종인 vm._computedWatchres에 넣는다. addDisabled는 key가되고, 와처 객체는 value가 된다. 이 와처를 computed와처라고 부른다. 렌더함수가 호출될 때만 프로퍼티를 평가하기 때문에 지연평가라고 한다. 평가후 이 값을 와처의 값 프로퍼티에 저장하게 된다.

---

#### Submit 버튼이 비활성화 되는 과정

처음에, DOM을 렌더링 할 때 어느 부분을 업데이트 하는지 파악한다.

초기화 단계에서는 부착지점이 비어있으므로 초기 렌더링에 필요한 요소만 생성한다.

예제에서 v-model을 이용하여 textarea에 바인딩을 추가했다. 양방향 데이터 바인딩을 위해 vue는 textarea의 input이벤트를 모니터링하는 리스너를 추가해 값이 입력되면 브라우저가 이벤트를 발생시키고 리스너가 textarea의 값을 전달받게 한다.

-와처내용 생략-

---

#### 컴포넌트의 props처리

vue는 data와 computed 프로퍼티 전에 props를 먼저 초기화 한다.

내부적으로는 props의 지정된 데이터 저장을 위해 _props 객체를 생성하여 vm.$children[0]. _props 에 넣는다.

자식 컴포넌트 내부 프로퍼티에 값을 넣는 것이다.



props객체는 컴포넌트에 의해 값이 변경되지 않아야 하기 때문에 vue는 props에 대한 observer를 생성하지 않는다. 그리고 props에 정의된 내용을 읽기 전용으로 간주한다.



프로퍼티는 는 부모 객체에서 자식 객체로 단방향으로 데이터를 전달하기 위한 것이다.

자식 컴포넌트에서 값을 변경해야 하는 경우, 초깃값으로 전달된 값을 이용하는 로컬 데이터 프로퍼티를 정의해야 한다.

업데이트된 경우에만 값을 변경해야할 때 computed 프로퍼티를 이용하면 원본이 변경될 때 마다 computed프로퍼티의 값을 자동으로 업데이트할 수 있다.

