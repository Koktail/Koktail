# Koktail

## 프로젝트 개요
- 설명: 사용자 취향에 맞는 칵테일 추천 애플리케이션
- 인원 구성: iOS 4 / Back-End 1
- 사용 기술: Swift5, RxSwift, Xcode, Figma, groom cloud, Slack, Notion

## 주요 라이브러리
- SwiftLint, SwiftJSON, SwiftEventBus, RxSwift, RxCocoa, Firebase, KakaoSDK, Carte, Then 등

## 앱 디자인
카카오 오븐   
https://ovenapp.io/view/XPaYrgoaQPUbGDXcP7XAtFj7T5gIRIIA/

피그마   
https://www.figma.com/file/REFtDPAqx8YaVz0I1igdsf/iOS-Study?node-id=0%3A1

## API 명세서   
https://perfect-purchase-57a.notion.site/API-d512a4a6daf0428f90e393a17c03e1aa

## 개발 내용
- SwiftLint를 사용한 코딩 컨벤션
- Figma, 카카오 오븐을 활용한 디자인
- Slack을 활용하여 Github 연동 및 Notion을 활용한 테스크 관리
- Firebase Auth를 사용한 회원가입과 회원탈퇴 및 로그인과 로그아웃 구현
- 카카오와 애플 소셜 로그인 구현
- Table View, Collection View를 사용한 화면 구현
- API 명세서 작성 및 groom 서버를 사용하여 통신
- 서버 통신을 통해 사용자가 좋아요한 칵테일을 찜목록에 저장
- Google Map, Google Place를 사용하여 사용자 주면 술집 검색 및 검색어 자동완성
- Realm을 사용하여 사용자 가게 찜목록 구현

## 기능 설명
- 로그인

![로그인](https://user-images.githubusercontent.com/45002556/131214577-70f39650-f0b4-434b-b2b2-10e420780f13.gif)
![소셜 로그인](https://user-images.githubusercontent.com/45002556/131214925-8d631519-1bc9-47cf-86b6-3e7ebd771d0c.gif)

- 로그아웃

![로그아웃](https://user-images.githubusercontent.com/45002556/131214572-8e598fe7-c8c0-4507-b845-5ee0bf9053be.gif)

- 회원 탈퇴

![회원탈퇴](https://user-images.githubusercontent.com/45002556/131214931-8e6791a2-a390-4887-8ceb-c50135ae6c02.gif)

- 홈화면

![홈화면](https://user-images.githubusercontent.com/45002556/131214590-55aa75ca-13de-48a7-9e03-ed0b0e6f2699.gif)

- 칵테일 추천

![칵테일 추천](https://user-images.githubusercontent.com/45002556/131214585-3252ca33-0842-4178-ae29-6d0bdb33e636.gif)

- 칵테일 리스트

![칵테일 리스트](https://user-images.githubusercontent.com/45002556/131214598-7b0c13b6-5a1f-463e-bd79-5cec4a3f1b08.gif)

- 칵테일 상세 페이지

![칵테일 상세보기](https://user-images.githubusercontent.com/45002556/131214606-e98e282a-a195-4c1b-92cc-85b18837d05d.gif)

- 지도 및 지도 상세

![지도](https://user-images.githubusercontent.com/45002556/131214812-1060d2ec-3de1-4f89-b89b-fab4dc2587f1.gif)

- 지도 검색

![지도 검색](https://user-images.githubusercontent.com/45002556/131214628-cf551aa4-c9a9-45fd-a996-309365f3dfb7.gif)

- 칵테일 찜목록

![칵테일 찜목록](https://user-images.githubusercontent.com/45002556/131214673-42b38615-3b0d-4ad3-9999-7779097f3f3c.gif)

- 가게 찜목록

![가게 찜목록](https://user-images.githubusercontent.com/45002556/131214678-8c77cbc9-b7d6-4d03-bd65-329e561a240e.gif)

## git commit 메시지
feat: 새로운 기능에 대한 커밋   
fix: 버그 수정에 대한 커밋   
build: 빌드 관련 파일 수정에 대한 커밋   
chore: 그 외 자잘한 수정에 대한 커밋   
ci: CI관련 설정 수정에 대한 커밋   
docs: 문서 수정에 대한 커밋   
style: 코드 스타일 혹은 포맷 등에 관한 커밋   
refactor:  코드 리팩토링에 대한 커밋   
test: 테스트 코드 수정에 대한 커밋   

***커밋 메시지 예시***    
ex1) feat: 로그인 기능 추가   
ex2) fix: 홈화면에 칵테일 이미지가 겹치는 문제 수정   
ex3) refactor: Alamofire -> Moya로 리팩토링
