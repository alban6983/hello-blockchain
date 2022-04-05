// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Library is Ownable {
  string internal _name = "An Awesome Library";
  struct Book {
    string isbn;
    string title;
    string author;
  }
  //Bookstore
  Book[] internal bookstore;
  //Book id-> borrower
  mapping(uint256 => address) internal ledger;

  constructor(string memory name_) {
    _name = name_;
    bookstore.push(
      Book({
        isbn: "978185360315",
        title: "20,000 Leagues Under the Sea (Wordsworth Classics)",
        author: "Jules Verne"
      })
    );
  }

  /**
  * Return library name
  */
  function name() public view returns (string memory) {
    return _name;
  }
  /**
  * Add new Book
  */
  function addBook(string memory _isbn, string memory _title, string memory _author) public onlyOwner {
    bookstore.push(
      Book({
        isbn: _isbn,
        title: _title,
        author: _author
      })
    );
  }
  function getBookById(uint256 _bookId) external view onlyValidBookId(_bookId) returns (
      uint256 bookId,
      string memory isbn,
      string memory title,
      string memory author,
      address borrower)
  {
    Book memory book = bookstore[_bookId];
    bookId = _bookId;
    isbn = book.isbn;
    title = book.title;
    author = book.author;
    borrower = ledger[_bookId];
  }

function getBookList() public view returns (string[] memory,string[] memory,
      string[] memory,address[] memory)
{
  uint256 arrLen = bookstore.length;
  string[] memory isbn = new string[](arrLen);
  string[] memory title = new string[](arrLen);
  string[] memory author = new string[](arrLen);
  address[] memory borrower = new address[](arrLen);
  for (uint256 i=0; i < arrLen; i++){
    Book memory mybook = bookstore[i];
    isbn[i] = mybook.isbn;
    title[i] = mybook.title;
    author[i] = mybook.author;
    borrower[i] = ledger[i];
  }
  return (isbn, title, author, borrower);
}

modifier onlyValidBookId(uint _bookId) {
  require(_bookId <= bookstore.length - 1, "Invalid book id");
  _;
}
/**
Function: borrowingBook
Input : bookId
Return : boolean
*/
  function _getBorrowerByBookId(uint256 _bookId) private view returns (address) {
    return ledger[_bookId];
  }
  function isBorrowingBook(uint256 _bookId) public view onlyValidBookId(_bookId) returns (bool) {
    return msg.sender == _getBorrowerByBookId(_bookId);
  }

  function isAvailable(uint256 _bookId) public view onlyValidBookId(_bookId) returns(bool) {
    return ledger[_bookId] == address(0);
  }
  modifier onlyBorrowable(uint256 _bookId) {
    require(
      !isBorrowingBook(_bookId) &&
      isAvailable(_bookId),
      "Not available or already borrowed by you."
    );
    _;
  }
/**
Function : borrow
Input : _bookId
*/
  function borrow(uint256 _bookId) public onlyBorrowable(_bookId) {
    ledger[_bookId] = msg.sender;
  //  emit borrow(msg.sender, _bookId);
  }
/**
Function : takeBack
Input : _bookId
*/
  function takeBack(uint256 _bookId) public {
    require(
      isBorrowingBook(_bookId),
      "Can only return borrowing book."
    );
    ledger[_bookId] = address(0);
  //  emit takeBack(msg.sender, _bookId);
  }
}