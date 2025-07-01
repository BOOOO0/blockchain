# 블록체인 노드 모니터링 토이 프로젝트

- Kind 클러스터에 노드 설치, 컨트랙트 앱 배포해서 트랜잭션 관련 메트릭 모니터링, 알림 설정, 후속 작업 자동화

- Kind 클러스터 구성

```bash
kind create cluster \
  --name mycluster \
  --image kindest/node:v1.32.5@sha256:36187f6c542fa9b78d2d499de4c857249c5a0ac8cc2241bef2ccd92729a7a259 \
  --config ./kind/kind.yaml

```

## 이더리움 Geth 노드 설치부터

- StatefulSet으로 배포, Service도 배포

- 서비스를 통해 노드 API 포트 확인

```bash
kubectl run -i --rm test-pod --image=curlimages/curl --restart=Never \
  -- curl -s -X POST -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"net_version","id":1}' \
  http://geth-service:8545
```

<details>
<summary>노드 관련 정리</summary>

1. Geth 노드 역할

- 블록체인 네트워크의 핵심 구성요소

  - 블록 생성, 트랜잭션 처리, 스마트 컨트랙트 실행

  - 데이터 동기화 및 검증

- 쿠버네티스 환경에서 컨테이너로 실행

  - 고가용성, 확장성, 모니터링 용이

2. Geth 노드 설정

- 이미지: ethereum/client-go:stable (공식, 신뢰성, 최신 기능)

- 주요 실행 옵션

  - --syncmode=snap : 빠른 동기화(스냅싱크)

  - --http : RPC 서버 활성화

  - --http.addr=0.0.0.0 : 모든 IP 허용

  - --http.port=8545 : RPC 포트

  - --http.api=eth,net,web3,debug : API 모듈

  - --metrics : 모니터링 활성화

  - --metrics.addr=0.0.0.0 : 메트릭 수신 주소

  - --networkid=1337 : 개인 테스트넷 ID

3. API 모듈 설명

- eth : 블록체인 핵심 기능 (트랜잭션, 잔액 등)

- net : 네트워크 관리 (피어, 네트워크 ID 등)

- web3 : 웹3 유틸리티 (버전 확인 등)

- debug : 고급 진단 (트랜잭션 트레이스 등)

4. 네트워크 ID 1337 선택 이유

- 개인 네트워크 표준 ID

- 충돌 방지 (메인넷 ID: 1, 테스트넷: 3~5)

- 개발 환경에서 널리 사용

5. 노드 연결 및 동기화

- 자동 피어 디스커버리 : P2P 포트(30303/UDP) 개방 시 외부 노드와 자동 연결

- 수동 연결 :

```bash
kubectl exec geth-node-0 -- geth attach --exec "admin.addPeer('enode://...@ip:30303')"
```

- 동기화 강제 시작 :

```bash
kubectl exec geth-node-0 -- geth attach --exec "admin.startSync()"
```

- 클라우드 환경에서 외부 노출 시

  - P2P 포트(30303/UDP) 개방하면 외부 노드와 자동 동기화

  - 로컬 테스트 환경에서는 외부 노출 필요 없음

6. 포트 개방 및 연결 상태 확인

- RPC 포트(8545/TCP) : dApp, 백엔드, 모니터링 도구 접근용

- P2P 포트(30303/UDP) : 노드 간 동기화용

7. 로그 분석

- 정상 로그 예시

```text
INFO [06-30|17:30:45] Starting peer-to-peer node
INFO [06-30|17:31:20] Block synchronisation started
INFO [06-30|17:35:22] Imported new chain segment
INFO [06-30|17:35:30] HTTP server started endpoint=0.0.0.0:8545
```

- 핵심 로그 패턴

  - Imported new chain segment: 새 블록 동기화 성공

  - HTTP server started: RPC API 서비스 활성화

  - Block synchronisation started: 동기화 진행 중

  - Successfully sealed new block: 새 블록 생성 완료

</details>

## 트랜잭션 발생 어플리케이션

- dApp까지는 아니고 시나리오는 정하지 않았기 때문에 트랜잭션 일으키는 간단한 어플리케이션 배포하고 트랜잭션 일어난 것 확인까지만

- 노드에 API 요청 보내기 위해 프라이빗 키 필요, geth 파드에 exec 명령으로 계정 생성, 프라이빗 키 발급

- 테스트용으로 사용할 것이기 때문에 개발자 모드로 노드 실행하여 가상의 이더리움 가진 계정, 프라이빗 키 발급하도록 statefulset.yaml 수정

- 블록체인 노드... 어렵다... 흑흑...
