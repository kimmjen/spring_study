# 02. Vue.js 2 - 기대한 방식으로 동작한다. (pdf. 76)
- Vue.js의 기본 개념 학습하기(pdf. 77)
- Vue.js의 반응형 시스템 동작 방식 학습하기
- Vue.js의 내부 구현에 관해 학습하기
- Vue.js의 로직과 설계에 관해 학습하기
- 요약(pdf. 107)
---

## 기본개념
애플리케이션의 로직자체를 기억해야 한다.<br>
서로 다른 코드들을 연결하기 위한 일련의 API를 기억하지 않아도 된다.<br>
점진적인 프레임워크인 Vue.js는 작은 규모에서 시작해 점차 대규모로 성장시켜가는 웹 애플리케이션을 작성하기 위한 직관적인 방법을 제시<br>

### Vue 인스턴스
전형적으로 Vue 애플리케이션은 루트 Vue 인스턴스와 컴포넌트 인스턴스로 나뉜다.<br>
> Vue 함수로 루트 인스턴스를 생성
```vue
new Vue ({ /* options */ });
```
options 객체에 애플리케이션을 기술하고, Vue.js가 이 객체를 가지고 Vue 인스턴스를 초기화한다.<br>

메시지 앱(Message App)이라는 간단한 애플리케이션을 만들어 options 객체가 어떻게 활용되는지 보자.<br>
아래의 SPA는 다음과 같은 기능을 가진다.

- 메시지 추가하기
- 메시지 리스트 보기
- 메시지 삭제하기
- 특정 조건에서 추가 기능을 자동으로 비활성화하기

`index.hmtl`
```html
<!DOCTYPE html>
<html>
<head><title>Messages App</title></head>
<body>
    <div id="app"></div>
    <!-- id가 app인 <div> 요소를 DOM에 생성 -->
    <script src="https://unpkg.com/vue@2.5.13/dist/vue.js"></script>
    <script>
        let vm = new Vue ({
        /* Vue 인스턴스를 vm(viewModel) 변수에 할당 */
            el: '#app',
            /* el(element): '#app'과 같이 CSS 선택자 문자열 또는 document.getElementById('app')과 같이 HTMLElement 자체가 될 수 있음*/
            data: {
            /* 객체 리터럴을 사용해 data 객체를 추가, 직관적 
            * data 객체 프로퍼티에 초깃값을 설정하는 것은 좋은 관행
            * */
                messages: [], // 배열
                newMessage: '' // 문자열
            }
        });
    </script>
</body>
</html>
```

```
...
data() {
    return {
        messages: [],
        newMessage: ''
    }
```

컴포넌트에 대한 데이터 구조를 정의할 때 함수를 사용하는 것이 필수,<br>
Vue.js가 항상 이 함수로 새로운 컴포넌트에 대한 새로운 데이터 모델을 생성하기 때문입니다.<br>
컴포넌트의 데이터 모델을 정의하는 데 일반 객체를 사용하면 이 컴포넌트의 모든 인스턴스가 같은 data 객체를 공유하는데, 그렇게 돼서는 안된다.<br>
예제의 루트 Vue 인스턴스에서는 일반객체를 사용해도 괜찮다.


메시지를 표시하고 추가하는 템플릿을 추가해보자. 세 가지 방법으로 템플릿을 추가할 수 있다.<br>
1. options 객체의 template 프로퍼리를 활용해 인라인 템픗릿 문자열을 추가
2. 템플릿을 부착 지점인 `<div id="app"></div>`내에 직접 넣는것,<br> Vue.js는 #app 내부의 템플릿을 분석하고 Vue.js가 생성한 HTML로 대체한다.
3. 템플릿 마크업을 `<script type="x-template" id="tmplApp">`과 같은 script 태그 내에 넣고 options 객체의 template 프로퍼티의 값으로 '#tmplApp'을 넣는 것

`index.html`
```html
...
    <div id="app">
        <ul>
            <li v-for="message in messages">
            <!-- v-for 지시자: 메시지 리스트를 렌더링, 구문은 <별칭> in < 원본 데이터> 
            v-for 블록은 js에서 for-loop 블록과 같다고 생각
            -->
                {{ message.text }} - {{ message.createdAt }}
                <!-- 이중 중괄호(Mustache) 구문으로 messages 리스트에 있는 message 객체의 text프로퍼티와 createdAt 프로퍼티를 출력 
                cretedAt 프로퍼티는 새로운 메시지를 저장할 때 추가하는 Date 객체
                Vue가 템플릿을 분석하고 {{ message.text }}와 같은 이중 중괄호 태그를 보간할 때 출력 결과와 해당 데이터 사이에 데이터 바인딩을 생성
                태그를 실제 값으로 대체하고 text프로퍼티가 변경될 때마다 출력 결과를 업데이트
                -->
            </li>
        </ul>
        <form v-on:submit.prevent="addMessage">
        <!-- v-on을 사용해 폼의 submit 이벤트에 이벤트 리스너를 부착
         prevent는 바라우저가 실제로 폼을 제출하지 않도록 vue.js에 event.preventDefault() 호출을 지시하는 수식어,
         addMessage는 폼의 submit 이벤트가 트리거 될 때 호출되는 메소드
         v-on은 click과 mouseover와 같은 일반적인 DOM 이벤트 전부에 리스너를 부착
         또 같은 방식으로 Vue 사용자 정의 컴포넌트의 사용자 정의 이벤트를 수신하는데 사용가능
         -->
            <textarea v-model="newMessage" placeholder="Leave a message"></textarea>
            <!-- v-model 지시자로 textarea 요소와 data 객체의 newMessage 프로퍼티 사이에 양방향 바인딩을 생성,
            이 방법으로 textarea 요소의 값이 변경될 때마다 newMessage가 자동으로 업데이트 
            -->
            <div><button type="submit">Add</button></div>
            <!-- submit 이벤트 트리거를 할 수 있게 type="submit" 버튼을 추가, -->
        </form>
    </div>
...
```

```html
...
let vm = new vue ({
    ...
    data: {
        ...
    },
    methods: {
        addMessage (event) {
            if (!this.newMessage) { return; }
                this.messages.push ({
                    text: this.newMessage, createdAt: new Date()});
                this.newMessage = '';
        }
    }
});
```

options 객체의 methods 프로퍼티는 단일 객체를 가지며, 이 객체에서 사용하는 모든 메소드를 담는다.<br>
그리고 이 메소드 내에서는 this로 데이터 객체의 프로퍼티에 접근하며, addMessage 메소드 내에서 객체 프로퍼티에 접근하는 데 this.newMessage와 this.messages를 사용<br>
메소드 구문은 ES6로 구현했지만, 다음과 같이 함수 표현식을 사용할 수도 있다.

```html
addMessage: function (event) {
    // 로직은 여기에 작성한다.
}
```

그러나 메소드를 만드는 데 화살표 함수 구문을 사용하면 안된다. 왜냐하면 this로 Vue 인스턴에 접근할 수 없기 때문이다.<br>

addMessage 메소드 내부에서 push() 메소드로 messages 배열에 새로운 메시지를 추가한 후 newMessage 프로퍼티를 초기화한다. <br>이에 맞춰서 Vue.js는 UI에서 textarea를 자동으로 비운다.<br>
이는 곧 알아볼 양방향 바인딩의 마술이다.

`index.html`

```html
...
<li v-for="message in messages">
    {{ message.text }} - {{ message.createdAt }}
    <button @click="deleteMessage(message)">X</button>
</li>
...
```

버튼을 추가하고 v-on:click 줄임말인 @click을 이용해 click 이벤트 리스너인 deleteMessage 메소드를 연결.<br>
여기에 메소드의 이름을 넣는 대신 message 객체를 메소드에 전달하기 위한 인라인 구문을 사용한다.<br>그리고 options 객체의 methods를 다음과 같이 변경
```html
let vm = new Vue ({
    ...
    methods: {
        ...
        deleteMessage (message) {
            this.messages.splice(this.messages.indexOf(message), 1)
        }
    }
});
```

Array.prototype.splice() 메소드로 messages 배열에서 선택된 메시지를 삭제<br>
Vue.js가 이 변경 사항을 감지하고 DOM을 자동으로 업데이트한다. DOM을 전혀 조작할 필요가 없다.

이제 메시지 추가하기 기능을 자동으로 비활성화가는 기능을 추가<br>
리스트에 10개의 메싲가 있을 때 비활성화하기를 원한다고 가정.<br>
이를 수행하려면 내장된 v-bind 지시자로 Add 버틍의 disabled 속성과 messages.length >= 10 표현식을 연결 <br>
이 방법으로 Vue.js는 messages 배열의 길이가 변경되면 disabled 속성을 자동으로 업데이트 한다.<br>

```html
<form @submit.prevent="addMessage">
    ...
    <div>
        <button v-bind:disabled="messages.length >= 10" 
        type="submit">Add</button>
        <!-- v-bind 지시자 : 내용길이 50자 초과시 비활성화, -->
    </div>
</form>
...
```

`computed`를 활용, 이 프로퍼티의 값은 data객체 내의 프로퍼티와 달리 계산된 값이다.<br>
그리고 Vue.js는 computed 프로퍼티에 종속된 대상을 추적하고 종속된 대상이 변경될 때 프로퍼티의 값을 업데이트 한다.<br>
computed 프로퍼티인 addDisabled를 options 객체에 추가.

```vue
let vm = new Vue ({
  data {
    ...
  },
  computed: {
    addDisabled () {
      return this.messages.length >= 10 || this.newMessage.length > 50;
    }

  }
});
```
계산된 프로퍼티인 addDisabled는 options 내에 있는 computed 객체의 메소드로 정의된다.<br>
메소드 내부에서 this를 통해 Vue 인스턴스에 접근할 수 있다.<br>
v-bind 지시자를 줄여서 콜론(:)을 사용
```vue
<button :disabled="addDisabled" type="submit">Add</button>
```

보다시피 예제 템플릿은 HTML 템플릿이 아니라 자바스크립트에서 대부분의 로직을 관리하기 때문에 유지보수하기가 훨씬 더 쉽다.

v-bind 지시자로 class와 style 같은 HTML 요소의 내장된 속성을 연결할 수 있다.<br>
또한 그것을 Vue의 사용자 정의 컴포넌트의 프로퍼티를 연결하는데 사용할 수 있으며, 이에 대해서는 곧 살펴볼 것<br>

템플릿 부착한 지점에 v-cloak 지시자를 추가하고 템플릿 마크업을 숨길 수 있는 CSS 규칙을 추가.

`index.html`
```html
<head>
    ...
    <style>
        [v-cloak] {display: none;}
        body > div {width: 500px; margin: @ auto;}
        textarea { width: 100%; }
        ul {padding: 0 15px;}
    </style>
</head>
<body>
    <div id="app" v-clock>
        ...
    </div>

</body>
```

지금까지 Vue 인스턴스의 options 객체의 data 객체와 computed 객체, methods 객체를 활용하는 방법을 학습.<br>
 이러한 객체의 프로퍼티가 따로 분리되어 정의돼 있더라도 this로 접근할 수 있음.<br>

`index.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Messages App</title>

    <!-- style start -->
    <style>
        [v-cloak] {display: none;}
        body > div {width: 500px; margin: 0 auto}
        textarea { width: 100%;}
        ul {padding: 0 15px;}
    </style>
    <!-- style end -->
</head>
<body>
    <div id="app" v-cloak>
        <message-list :items="messages" @delete="deleteMessage"></message-list>
        <ul>
            <li v-for="message in messages"> <!-- v-for 지시자(directive): 메시지 미르슽 렌더링, 구문: <별칭> in <원본 데이터>, 자바스크립트의 for- loop 구문과 비슷하다고 볼수 있다. -->
                {{ message.text }} - {{ message.createdAt }} <!-- 이중 중괄호구문, message 객체의 text, createaAt 프로퍼티 출력, createdAt 프로퍼티는 새로운 메시지를 저장할 때 추가하는 Date 객체 -->
                <button @click="deleteMessage(message)">X</button> <!-- v-on:click = @click, click 리스너인 deleteMessage메소드를 연결, 메소드의 이름을 넣는대신 message 객체를 메소드에 전달하기 위한 인라인 구문을 사용 -->
            </li>
        </ul>
        <form v-on:submit.prevent="addMessage"> <!-- v-on 지시자: 폼의 submit 이벤트에 이벤트 리스너를 부착, prevent는 브라우저가 실제로 폼을 제출하지 않도록 Vue.js에 event.preventDefault() 호출을 지시하는 수식어,
                                                 addMessage는 폼의 submit 이벤트가 트리거가 될 때 호출되는 메소드,
                                                 v-on으로 click과 mouseover와 같은 일반적인 DOM 이벤트 전부에 리스너를 부착,
                                                 -->
            <textarea v-model="newMessage" placeholder="Leave a message">
            </textarea><!-- v-model 지시자로 textarea 요소와 data 객체의 new Message 프로퍼티 사이에 양방향 바인딩을 생성, textarea 요소의 값이 변경될 때마다 newMessage가 자동을 업데이트  -->
            <div>
                <!--<button v-bind:disabled="messages.length >= 10" type="submit">Add</button>-->
                <button :disabled="addDisabled" type="submit">Add</button> <!-- v-bind를 줄여서 : 사용 -->
            </div>
            <!-- 메시지 10개 이상 되면 Add 버튼 비활성화, textarea 내용의 길이가 50자를 초과하는 경우 Add 버튼 비활성화 하도록 로직 변경 -->
        </form>
    </div>
    <script src="https://unpkg.com/vue@2.5.13/dist/vue.js"></script>
    <script type="module">
        import MessageList from "./components/MessageList";
        let vm = new Vue ({ // vm: viewModel
            el: '#app', // el: element, '#app': css선택자문자열, document.getElementById('app')과 같이 HTMLElement자체가 된다.
            data: { // data 모델, 객체 리터럴 사용
                messages: [], // 배열
                newMessage: '' // 문자열
            },
            // options 객체: methods 프로퍼티는 단일 객체를 가지며, 이 객체에서 사용하는 모든 메소드
            // 메소드내에서는 this로 데이터 객체의 프로퍼티에 접근하며, addMessage 메소드 내에서 객체 프로퍼티에 접근하는데, this.newMessage와 this.messages를 사용
            // addMessage: function (event) {
            //   // 로직은 여기에 작성한다.
            // }
            computed: { // data 객체 내의 프로퍼티와 달리 계산된 값
                addDisabled () {
                    return this.messages.length >= 10 || this.newMessage.length > 50; // 메시지 갯수 10제한, textarea 50자 제한
                }
            },
            methods: {
                addMessage (event) {
                    if (!this.newMessage) { return; }
                        this.messages.push({
                            text: this.newMessage, createdAt: new Date() });
                        this.newMessage=''
                },
                deleteMessage (message) {
                    this.messages.splice(this.messages.indexOf(message), 1) // Array.prototype.splice() 메소드로 messages 배열에서 선택된 메시지를 삭제.
                }

            }
        });
    </script>
</body>
</html>
```

### 컴포넌트(pdf. 86)
Vue 애플리케이션에서 코드를 재사용할 수 있는 기본적인 방법<br>
컴포넌트를 이용하면 HTML 요소를 확장하고 추가 로직을 제공할 수 있어 그것들을 재사용 할 수 있다.<br>
자신만의 요소를 정의하고 네이티브 HTML요소와 같은 방식으로 그것을 사용<br>
Vue 컴포넌트는 Vue 인스턴스이기도 하다, Vue 컴포넌트는 생성 중에 Vue 인스턴스와 같은 options 객체를 받는다.<br>
<br>
컴포넌트를 전체 애플리케이션에서 활용할 수 있게 전역으로 등록<br>
컴포넌트를 전역으로 등록 하는 데는 Vue.component(id, `[definition]`)을 사용 <br>
첫 번재 인자는 컴포넌트의 id이다. 템플릿에서 사용할 태그 이름<br>
두 번째 인자는 컴포넌트에 대한 정의(definition)로 options 객체이거나 options 객체를 반환하는 함수<br>
컴포넌트를 다른 Vue 인스턴스의 범위에서만 활용 할 수 있게 로컬로 등록할 수도 있다. 이를 위해서는 컴포넌에 대한 options 객체를 부모 components 프로퍼티에 추가<br>
<br>
리스트를 렌더링하려면 MessageList 컴포넌트가 data 객체의 messages 프로퍼티에 접근<br>
Vue.js에서 컴포넌트는 컴포넌트 자체의 고립된 스코프를 가진다. 즉 자식 컴포넌트에서 부모 데이터를 직접 참조 할 수 없다. Vue.js는 options 객체에 props라는 프로퍼티를 제공한다.<br>
props 프로퍼티로 컴포넌트에 전달할 수 있는 데이터를 정의할 수 있다. props 프로퍼티는 배열 또는 객체를 값으로 가진다.<br>
MessageList 컴포넌트에 items 프로퍼티를 추가하고 v-bind 지시자로 messages 데이터와 연결<br>

MessageList 컴포넌트 내에서 Delete 버튼 클릭에 대한 메시지로 부모 컴포넌트와 통신할 방법이 필요하기 때문에<br>
Vue.js에서는 사용자 정의 이벤트로 부모 컴포넌트와 통신, Vue인스턴스에는 현재 인스턴스의 이벤트를 트리거 할 수 있는 `$emit()`메소드가 있다.<br>
첫 번째 인자로 이벤트명을 취하고,<br>
두 번째 인자는 추가 데이터가 있는 경우 사용한다.<br>
그리고 부모 컴포넌트는 v-on 지시자로 이벤트를 리스터에 부착함에 따라 Delete 버튼을 클릭하면 MessageList가 delete 이벤트를 트리거하고 삭제해야 할 메시지를 전달<br>

`index.html`
```html
<div id="app" v-cloak>
    <message-list :item="messages" @delete="deleteMessage"></message-list>
    <!-- :items="messages"는 v-bind:items="messages"를 줄여 쓴 것, 
    @delete="deleteMessage"는 v-on:delete="deleteMessage"의 줄임문
    -->
    <ul>
        <li v-for="message in messages">
            {{ message.text }} - {{ message.createdAt }}
            <button @click="deleteMessage(message)">X</button>
        </li>
    </ul>
    ...
</div>
```

Vue.js에서 컴포넌트를 먼저 등록해야 부모 컴포넌트에서 사용할 수 있기 때문에 index.html에서 MessageList의 코드를 let vm = new Vue({...}) 위에 배치<br>
권장 하는 또 다른 방법은 컴포넌트가 필요로 하는 모든 것을 별도의 파일에 저장해 필요한 곳에서 가져오기로 재사용할 수 있게 하는것<br>

> components 폴더 생성 후 MessageList.js 파일 생성

`components/MessageList.js`
```js
export default {
    name: 'MessageList', //  필수는 아니지만, 디버깅에 필요
    template: `<ul>
    <li v-for="item in items" :item="item">
        {{ item.text }} - {{ item.createdAt }}
    <button @click="deleteMessage(item)">X</button></li><ul>`,
    props: {
        items: {
            type: Array,
            required: true
        }
    },
    // 위 props는 MessageList의 items 프로퍼티를 정의
    method: {
        deleteMessage(message) { // Delete 버튼의 click 이벤트를 수신하기 위해 메소드 추가
            this.$emit('delete', message);
            // $emit은 MessageList의 delete 이벤트를 트리거 하기 때문에 부모 컴포넌트는 @delete="..."에서 이 이벤트를 수신
            // 무조건 delete라는 이름 사용할 필요는 없다, this.$emit('이름',...)로 트리거 하고 @이름="..." 로 수신
        }
    }
};
```

`index.html`

```html
<script type="module">
 import MessageList from './components/MessageList.js' from "./MessageList";
 let vm = new Vue({
  ...
  components: {
      MessageList
 },
 ...
 })
</script>
```
> components/MessageListItem.js
```js
export default {
    name: 'MessageListItem',
    template: `<li>{{ item.text }} - {{ item.createdAt }}
    <button @click="deleteClicked">X</button></li>`,
    props: {
        items: {
            type: Object,
            required: true
        }
    },
    method: {
        deleteClicked() {
            this.$emit('delete');
        }
    }
};
```

> MessageList 컴포넌트의 변경 사항

```js
import MessageListItem from'./MessageListItem.js';
export default {
    name: 'MessageList', //  필수는 아니지만, 디버깅에 필요
    template: `<ul>
    <message-list-item v-for="item in items" :item="item" @delete="deleteMessage(item)">
    </message-list-item><ul>`,
    // v-for 지시자를 그래도 사용하고 :item으로 데이터를 전달하고 @delete로 리스너를 바인딩 
    components: {
           MessageListItem
    },
    props: {
        items: {
            type: Array,
            required: true
        }
    },
    // 위 pr>ops는 MessageList의 items 프로퍼티를 정의
    method: {
        deleteMessage(message) { // Delete 버튼의 click 이벤트를 수신하기 위해 메소드 추가
            this.$emit('delete', message);
            // $emit은 MessageList의 delete 이벤트를 트리거 하기 때문에 부모 컴포넌트는 @delete="..."에서 이 이벤트를 수신
            // 무조건 delete라는 이름 사용할 필요는 없다, this.$emit('이름',...)로 트리거 하고 @이름="..." 로 수신
        }
    }
};
```

> addMessage() 메소드의 변경
```html
addMessage (event) {
    ...
    let now = new Date();
    this.messages.push ({
        id: now.getTime(), text: this.newMessage, createdAt: now });
    ...
}
```

> MessageList 컴포넌트 변경 사항
```js
export default {
    ...
    template: `<ul><message-list-item v-for="item in items
        :item="item" :key="item.id" @delete="deleteMessage(item)">
        </message-list-item>`,
    ...
};
```

> Vue 애플리케이션 컴포넌트 기반, 최종구조
```
/index.html
/components/MessageList.js
/components/MessageListItem.js
```

대규모 웹 애플리케이션을 구축하는 데는 단일 파일 컴포넌트를 사용하는 것이 이상적
- 기본적으로 컴포넌트의 템플릿과 자바스크립트 코드, CSS를 .vue 확장자를 가지는 단일 파일에 저장

`index.html`
```html
<!DOCTYPE html>
<html lang="en">
<head>
 <meta charset="UTF-8">
 <title>Messages App</title>

 <!-- style start -->
 <style>
  [v-cloak] {display: none;}
  body > div {width: 500px; margin: 0 auto}
  textarea { width: 100%;}
  ul {padding: 0 15px;}
 </style>
 <!-- style end -->
</head>
<body>
<div id="app" v-cloak>
 <message-list :items="messages" @delete="deleteMessage"></message-list>
 <ul>
  <li v-for="message in messages"> <!-- v-for 지시자(directive): 메시지 미르슽 렌더링, 구문: <별칭> in <원본 데이터>, 자바스크립트의 for- loop 구문과 비슷하다고 볼수 있다. -->
   {{ message.text }} - {{ message.createdAt }} <!-- 이중 중괄호구문, message 객체의 text, createaAt 프로퍼티 출력, createdAt 프로퍼티는 새로운 메시지를 저장할 때 추가하는 Date 객체 -->
   <button @click="deleteMessage(message)">X</button> <!-- v-on:click = @click, click 리스너인 deleteMessage메소드를 연결, 메소드의 이름을 넣는대신 message 객체를 메소드에 전달하기 위한 인라인 구문을 사용 -->
  </li>
 </ul>
 <form v-on:submit.prevent="addMessage"> <!-- v-on 지시자: 폼의 submit 이벤트에 이벤트 리스너를 부착, prevent는 브라우저가 실제로 폼을 제출하지 않도록 Vue.js에 event.preventDefault() 호출을 지시하는 수식어,
                                                 addMessage는 폼의 submit 이벤트가 트리거가 될 때 호출되는 메소드,
                                                 v-on으로 click과 mouseover와 같은 일반적인 DOM 이벤트 전부에 리스너를 부착,
                                                 -->
  <textarea v-model="newMessage" placeholder="Leave a message">
            </textarea><!-- v-model 지시자로 textarea 요소와 data 객체의 new Message 프로퍼티 사이에 양방향 바인딩을 생성, textarea 요소의 값이 변경될 때마다 newMessage가 자동을 업데이트  -->
  <div>
   <!--<button v-bind:disabled="messages.length >= 10" type="submit">Add</button>-->
   <button :disabled="addDisabled" type="submit">Add</button> <!-- v-bind를 줄여서 : 사용 -->
  </div>
  <!-- 메시지 10개 이상 되면 Add 버튼 비활성화, textarea 내용의 길이가 50자를 초과하는 경우 Add 버튼 비활성화 하도록 로직 변경 -->
 </form>
</div>
<script src="https://unpkg.com/vue@2.5.13/dist/vue.js"></script>
<script type="module">
 import MessageList from "./components/MessageList";
 let vm = new Vue ({ // vm: viewModel
  el: '#app', // el: element, '#app': css선택자문자열, document.getElementById('app')과 같이 HTMLElement자체가 된다.
  data: { // data 모델, 객체 리터럴 사용
   messages: [], // 배열
   newMessage: '' // 문자열
  },
  // options 객체: methods 프로퍼티는 단일 객체를 가지며, 이 객체에서 사용하는 모든 메소드
  // 메소드내에서는 this로 데이터 객체의 프로퍼티에 접근하며, addMessage 메소드 내에서 객체 프로퍼티에 접근하는데, this.newMessage와 this.messages를 사용
  // addMessage: function (event) {
  //   // 로직은 여기에 작성한다.
  // }
  computed: { // data 객체 내의 프로퍼티와 달리 계산된 값
   addDisabled () {
    return this.messages.length >= 10 || this.newMessage.length > 50; // 메시지 갯수 10제한, textarea 50자 제한
   }
  },
  methods: {
   addMessage (event) {
    if (!this.newMessage) { return; }
    this.messages.push({
     text: this.newMessage, createdAt: new Date() });
    this.newMessage=''
   },
   deleteMessage (message) {
    this.messages.splice(this.messages.indexOf(message), 1) // Array.prototype.splice() 메소드로 messages 배열에서 선택된 메시지를 삭제.
   }

  }
 });
</script>
</body>
</html>
```
`MessageList.js`
```js
import MessageListItem from './MessageListItem.js'

export default {
  name: 'MessageList',
    template: `<ul><message-list-item v-for="item in items" 
    :item="item" :key="item.id"@delete="deleteMessage(item)">
    </message-list-item></ul>`,
  props: {
    items: {
      type: Array,
      required: true
    }
  },
  components: {
    MessageListItem
  },
  methods: {
    deleteMessage (message) {
      this.$emit('delete', message)
    }
  }
}
```
`MessageListItem.js`
```js
export default {
  name: 'MessageListItem',
  template: `<li>{{ item.text }} - {{ item.createdAt }} 
    <button @click="deleteClicked">X</button></li>`,
  props: {
    item: {
      type: Object,
      required: true
    }
  },
  methods: {
    deleteClicked () {
      this.$emit('delete')
    }
  }
}
```
### Vue 인스턴스 라이플 사이클
 Vue.js의 기본 개념 중에서 라이플 사이클 혹(life cycle hook)은 특별하게 인스턴스의 라이프 사이크 동안 각 단계별로 로직을 정의할 수 있는 능력을 제공
 
1. beforeCreated: 인스턴스의 내부 이벤트와 라이프 사이클 상태가 초기화된 후에 호출된다.
2. created: 인스턴스의 주입과 반응형 시스템이 초기화된 후에 호출된다. 이 단계에서 인스턴스는 기능을 수행하지만 DOM이 업데이트되지 않아 사용자는 UI에서 아무것도 볼 수 없다.
3. beforeMount: Vue.js가 템플릿 컴파일을 마치고 생성된 DOM을 렌더링할 준비가 된 후에 호출된다.
4. mounted: DOM이 업데이트된 후에 호출된다. 이 시점에서 사용자는 UI와 상호작용할 수 있으며, 인스턴스는 완전한 기능을 수행
5. beforeUpdate: 데이터가 변경된 이후 DOM이 업데이트되기 전에 호출된다. 이 혹에서 여전히 데이터 변경을 수행할 수 있으며, 이 변경이 추가적인 DOM 업데이트를 트리거하지 않는다.
6. updated: DOM이 데이터 변경 사항을 기반으로 업데이트된 후에 호출된다.
7. activated: keep-alive 컴포넌트가 활성화 될 때 호출된다.
8. deactivated: keep-alive 컴포넌트가 비활성화 될 때 호출된다.
9. beforeDestroy: 인스턴스가 파괴되기 전에 호출된다. 이 단계에서 인스턴스는 여전히 완전한 기능을 수행한다.
10. destroyed: 인스턴스가 파괴된 후에 호출된다. 이 단계에서 인스턴스의 모든 지시자의 바인딩이 해제되고 모든 이벤트 리스너가 제거되며 모든 하위 Vue 인스턴스가 파괴된다.
11. errorCaptured: 자손 컴포넌트에서 에러가 검출될 때마다 호출된다.

혹은 라이프 사이클에 로직을 추가하는 것 이외에도 Vue.js가 컴포넌트의 라이프 사이클을 관리하는 방법을 확인하기에 좋다.<br>
이를 이용하면 Vue.js의 동작 방식을 더 잘 이해하게 될 것,