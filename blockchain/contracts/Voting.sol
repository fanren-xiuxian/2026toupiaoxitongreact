// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Voting {
    // 候选人结构体：存储候选人ID、姓名、得票数
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    address public admin;                 // 合约管理员（部署者）
    Candidate[] public candidates;         // 候选人数组
    mapping(address => bool) public hasVoted; // 记录地址是否已经投过票

    // 事件：新增候选人
    event CandidateAdded(uint256 id, string name);
    // 事件：用户完成投票，voter加indexed方便链上检索
    event Voted(address indexed voter, uint256 candidateId);

    // 修饰器：限制只有管理员才能调用
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // 构造函数：部署合约时执行，部署者设为管理员
    constructor() {
        admin = msg.sender;
    }

    // 管理员添加候选人
    function addCandidate(string memory _name) public onlyAdmin {
        uint256 candidateId = candidates.length;
        candidates.push(
            Candidate({id: candidateId, name: _name, voteCount: 0})
        );
        emit CandidateAdded(candidateId, _name);
    }

    // 用户投票函数
    function vote(uint256 _candidateId) public {
        require(!hasVoted[msg.sender], "You have already voted"); // 不能重复投票
        require(_candidateId < candidates.length, "Invalid candidate ID"); // 候选人ID合法

        hasVoted[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        emit Voted(msg.sender, _candidateId);
    }

    // 获取全部候选人信息
    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }

    // 获取候选人总数量
    function getCandidateCount() public view returns (uint256) {
        return candidates.length;
    }

    // 根据ID获取单个候选人信息
    function getCandidate(uint256 _candidateId) public view returns (Candidate memory) {
        require(_candidateId < candidates.length, "Invalid candidate ID");
        return candidates[_candidateId];
    }

    // 查询某个地址是否投过票
    function checkIfVoted(address _voter) public view returns (bool) {
        return hasVoted[_voter];
    }
}
