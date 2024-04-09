# BlockChain

- 과제 수행을 위한 기초 공부와 더불어 간단한 블록체인 튜토리얼

## Web 3.0

- Web 3.0은 인공지능에 기반한 맞춤형 정보를 제공하고 블록체인에 기반해 데이터 소유를 개인화하는 3세대 인터넷이다.

## 블록체인에서 말하는 탈중앙화

- 기존 웹서비스에서 데이터의 저장은 서비스를 제공하는 주체가 소유한 데이터베이스에 관계형 혹은 비관계형의 형태로 저장되었고 그 데이터의 보안은 인가된 사용자만 접근할 수 있도록 하는 폐쇄적인 환경을 가지고 있었다.

- 블록체인은 데이터 블록을 체인으로 연결하고 똑같은 블록체인을 모든 사용자의 컴퓨터에 복제하여 동일한 데이터를 가지도록 한다.

- 모두 동일한 데이터를 가지고 있기 때문에 변조를 하려면 다른 모든 사용자의 데이터 또한 변조시켜야 하므로 한 사람이 임의로 데이터를 변조할 수 없는 구조이다.

- 여기서 중앙 집중식 네트워크와의 차이점은 중앙 집중식의 경우 사용자는 서비스를 제공하는 주체에 대한 신뢰가 필요하지만 탈중앙화 네트워크의 경우 사용자는 다른 주체를 신뢰하지 않아도 되는 점이다.

- 예를 들어 화폐의 경우 은행과 정부라는 중앙 직권 기관이 존재하고 그 기관이 화폐의 가치를 결정한다.

- 블록체인 기반 가상화폐의 경우 가치를 결정하는 주체가 존재하지 않고 네트워크 내 참여자들에 의해 자유롭게 결정된다.

## 머클 트리와 노드

- 라이트 노드는 머클 트리의 루트 노드를 포함한 헤더만을 가지고 있는 노드를 의미하고 풀 노드는 머클 트리 전체를 가지고 있는 노드를 의미한다.

- 머클 루트는 블록이 보유하고 있는 거래 내역들의 해시값을 가장 가까운 거래내역끼리 쌍을 지어 해시화하고 쌍을 지을 수 없을 때까지 이 과정을 반복했을 때 얻게 되는 값이다.

- 이 머클 루트를 얻기 위해 반복하면서 생기는 트리가 머클 트리이다.

- 리프 노드는 하나의 트랜잭션(거래)에 대응되며 머클 트리를 통해 모든 트랜잭션을

- ![image](./img/merkle.PNG)

- 머클 트리의 리프 노드 하나만 변경하더라도 루트 노드의 값이 변경되기 때문에 루트 노드 값만 비교하더라도 검증이 가능하며 이로 인해 저사양 기기를 사용하더라도 블록체인에 참여할 수 있다.

### 거래 검증

-
