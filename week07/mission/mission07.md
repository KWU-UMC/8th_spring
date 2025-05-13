# 7주차 미션

## 7주차 워크북 실습 진행 과정 기록

### ![파일생성.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/%ED%8C%8C%EC%9D%BC%EC%83%9D%EC%84%B1.png)
- 주어진 대로 파일을 생성하였음

### ![오타수정.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/%EC%98%A4%ED%83%80%EC%88%98%EC%A0%95.png)
- 워크북 수행 중, 클래스 이름 오류 발견하여 Reason -> ReasonDTO로 수정함 (ErrorReasonDTO도 동일 수정)

### ![API동작확인.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/API%EB%8F%99%EC%9E%91%ED%99%95%EC%9D%B8.png)
- API 정상 동작 확인하였음

### ![오류.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/%EC%98%A4%EB%A5%98.png)
- TEMP_EXCEPTION 라인을 위 응답 "," 뒤에 이어서 작성했어야 했는데, 마지막 응답 ";" 뒤에 작성하여 인식 안 되는 오류 발생했었음
- 응답 중간에 "," 로 이어넣어 오류 해결

### ![flag1.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/flag1.png)
- flag=1의 경우 정상 작동 확인

### ![flag2.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/flag2.png)
- flag=2의 경우 정상 작동 확인

### 고찰 및 정리
- 워크북 코드와 실제 github에 올라가 있는 코드가 달라서 예상치 못한 오류가 몇 있었음
- Error Handler, DTO 등 이해가 가지 않는 부분에 관해 더 찾아보며 공부할 수 있었고, 직접 실습해보며 조금 익숙해질 수 있었음
- 각각의 어노테이션을 사용하려면 어떤 경로를 import 해야 하는지 익혔고, Alt+Enter를 통해 자동 import가 가능하다는 것을 깨달음
- 미션 목록 조회에 관한 API 명세서는 3주차 워크북 미션으로 제출했기에 따로 작성하지 않음
- RestControllerAdvcie의 장점과 없을 때의 불편한 점은 keyword에 같이 정리했음

