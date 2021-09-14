$(function(){
    $(document).ready(function(){
        var date = new Date();
        var year = date.getFullYear();
        var month = ("0" + (1 + date.getMonth())).slice(-2);
        
      $('#show').html('....loading...');
  
      $.ajax({
          type: "GET",
          url:`http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888&targetDt=${year+month}01`,
          success:function(data){
              //$('#show').html(JSON.stringify(data));
              let i = 0;
              let str = `<caption style="text-align:center;">${year+month}01기준</caption><tbody><th>순위</th><th>제목</th><th>개봉일</th>`;
              while(i<10){
                str+="<tr>"
                str += `<td>${data.boxOfficeResult.dailyBoxOfficeList[i].rank}위</td> <td>${data.boxOfficeResult.dailyBoxOfficeList[i].movieNm}</td> <td>${data.boxOfficeResult.dailyBoxOfficeList[i].openDt}</td>`;
                str +="</tr>" ;
                i+=1;
              }
              str+="</tbody>";
              $('#show').html(str);
          }
      })
    })
  })