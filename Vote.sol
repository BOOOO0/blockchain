// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
// 솔리디티 버전 명시
// 상단에 라이센스 Identifier를 명시해야 한다.

contract Vote {

    // structure (후보의 정보와 몇 표를 받았는지 구조체로 저장할 것)
    struct candidator {
        string name;
        uint upVote;
    }

    // variable
    bool live;
    candidator[] public candidatorList;
    address owner;

    // mapping
    // 주소 -> Boolean 쌍의 Map으로 투표 여부를 확인
    mapping(address => bool) Voted;

    // event (블록체인에서 무엇을 했는지 브로드캐스팅 하는 목적이라고 함)
    event AddCandidator(string _name);
    event UpVote(string candidator, uint upVote);
    event FinishVote(bool live);
    event Voting (address owner);

    // modifier (finishVote를 할 수 있는 주체를 확인하기 위해 사용할 것)
    modifier onlyOwner {
        require(msg.sender == owner);
        // _;는 이후 함수를 모두 수행해라 modifier가 호출된 메소드의 호출 시점 아래 내용들을 의미
        _;
    }

    //constructor
    // 생성자는 default가 public이므로 명시하지 않아도 된다.
    constructor() {
        // 컨트랙트 생성할 때 생성한 사람의 주소로 owner를 정한다는 건가? 실행을 해봐야 알 것 같다.
        owner = msg.sender;
        live = true;

        emit Voting(owner);
    }

    // candidator
    // 파라미터의 앞에 언더바를 관례로 붙인다고 한다.
    function addCandidator(string memory _name) public onlyOwner {
        require(live == true);
        // require에 명시한 조건에 해당될 경우에만 이하 내용 실행
        // 가스 조절을 위한 제한의 예시라고 한다.
        require(candidatorList.length < 5);
        candidatorList.push(candidator(_name, 0));

        // emit event 후보자 등록 완료를 브로드캐스팅
        emit AddCandidator(_name);
    }

    // voting
    function upVote(uint _indexOfCandidator) public {
        require(live == true);
        require(_indexOfCandidator < candidatorList.length);
        // 투표를 안한 사람만 가능
        require(Voted[msg.sender] == false);
        candidatorList[_indexOfCandidator].upVote++;

        // msg.sender는 메세지를 보낸(투표를 한) 사람의 주소 값이다.
        Voted[msg.sender] = true;

        // 표를 받은 후보자의 이름과 현재 몇 표를 받았는지 브로드캐스팅
        emit UpVote(candidatorList[_indexOfCandidator].name, candidatorList[_indexOfCandidator].upVote);
    }

    // finish vote
    function finishVote() public onlyOwner {
        require(live == true);
        // live Boolean 변수를 false로 바꿔서 투표 종료
        live = false;

        emit FinishVote(live);
    }
}
