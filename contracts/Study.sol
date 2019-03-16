pragma solidity ^0.5.0;

contract Study {

  struct Student {
    bytes32 name;
    bytes32 email;
  }

  struct Lecture {
    bytes32 lectureName;
    address[] attandee;
  }

  address labAdmin;
  bytes32 labName;
  mapping(address => Student) public students;
  Lecture[] class;
  bytes32 attendanceCode;
  uint deposit;

  modifier onlyAdmin {
    require(msg.sender == labAdmin);
    _;
  }


  constructor(bytes32 className, bytes32[] memory lectureNames, uint _deposit) public {
    labAdmin = msg.sender;
    labName = className;
    deposit = _deposit;

    for(uint i=0; i<lectureNames.length; i++) {
      class.push(Lecture({
        lectureName: lectureNames[i],
        attandee: new address[](0)
      }));
    }
  }

  function kill() onlyAdmin public{
    selfdestruct(msg.sender);
  }

  function getAdmin() public view returns(address) {
    return labAdmin;
  }

  function setStudent(bytes32 name, bytes32 email) public{
    students[msg.sender] = Student(name, email);
  }

  function getStudent(address st) public view returns(bytes32, bytes32) {
    require(msg.sender == st || msg.sender == labAdmin);
    return (students[st].name, students[st].email);
  }

  function getLectures() public view returns (bytes32[] memory lectureList) {
    lectureList = new bytes32[](class.length);
    for(uint i=0; i<class.length; i++) {
      lectureList[i] = class[i].lectureName;
    }
  }
  // function setAttendance(uint lectureNum) public {
  //   class[lectureNum].attandee.push(msg.sender);
  // }
  function setAttendanceCode(uint _attendanceCode) onlyAdmin public {
    attendanceCode = sha3(_attendanceCode);
  }

  function setAttendance(uint lectureNum, uint _attendanceCode) public {
    require(attendanceCode == sha3(_attendanceCode));
    class[lectureNum].attandee.push(msg.sender);
  }

  function getAttendance(uint lectureNum) public view returns (address[] memory){
    return class[lectureNum].attandee;
  }

  function join(bytes32 name, bytes32 email) payable public {
    require(deposit <= msg.value);
    students[msg.sender] = Student(name, email);
  }

}
