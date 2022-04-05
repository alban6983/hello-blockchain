<template>
  <div class="hello">
    <div v-if="!currentAccount">
      <button class="primaryButton" @click="connectWallet">Connect Wallet</button>
    </div>
    <div v-if="!currentContract">
      <button class="primaryButton" @click="attachContract">Attach Contract</button>
    </div>
    <div v-if="currentContract">
      <button class="primaryButton" @click="getList">Get Book List</button>
    </div>
    <h1>ADD BOOK</h1>
    <div class="hello">
      <label for="isbn">ISBN:</label>
      <input id='isbn' type="text" v-model="new_book.isbn">
      <label for="author" >Author:</label>
      <input id='author' type="text" v-model="new_book.author">
      <label for="title">Title:</label><input id='title' type="text" v-model="new_book.title">
      <button class="primaryButton" @click="addBook()">Add</button>
    </div>
    <div class="hello">
      <h2>Book List</h2>
      <table border='1'><tr><td>ISBN</td><td>TITLE</td><td>AUTHOR</td><td>BORROWER</td></tr>
        <tr v-for="book in bookList" :key='book.isbn'>
          <td>{{ book.isbn }} </td>
          <td>{{ book.title }} </td>
          <td>{{ book.author }} </td>
          <td>{{ book.borrower }} </td>
        </tr>
      </table>
    </div>
  </div>
</template>

<script>
import Library from '../../blockchain/artifacts/contracts/library.sol/Library.json'
export default {
  name: 'AddBook',
  data() {
    return {
      currentAccount: null,
      currentContract: null,
      contractAddress: "0xA987adfBfD43C301088e1888dB6A390eb5D91Edd",
      new_book: {
        isbn: '',
        title: '',
        author: ''
      },
      bookList: [
        {isbn: '',
        title: '',
        author: '',
        borrower: ''}
      ]
    };
  },
  mounted() {
    this.checkConnectedWalletExist();
  },
  methods: {
    checkConnectedWalletExist: async function() {
      try {
        const { ethereum } = window;
        if (!ethereum) {
          alert("Make sure you have Metamask!");
          return false;
        }
        else {
          console.log("We have the ethereum object ", ethereum);
        }
        const accounts = await ethereum.request({ method: "eth_accounts"});
        if (accounts.length !== 0) {
          const account = accounts[0];
          console.log("Found an authorized account:", account);
          this.currentAccount = account;
          return true;
        } else {
          console.log("No authorized account found");
          return false;
        }
      } catch (error) {
        console.log(error);
        return false;
      }
    },
    connectWallet: async function () {
      try {
        const { ethereum } = window;
        if (!ethereum) {
          alert("Get MetaMask!");
          return;
        }
        const accounts = await ethereum.request({
          method: "eth_requestAccounts",
        });
        console.log("Connected", accounts[0]);
        this.currentAccount = accounts[0];
      } catch (error) {
        console.log(error);
      }
    },
    attachContract: async function () {
      const provider = new this.$ethers.providers.JsonRpcProvider("http://127.0.0.1:7545");
      const signer = provider.getSigner()
      //const network = await provider.getNetwork();
      //console.log(network);
      const abi = Library.abi;
      // The Contract object
      this.currentContract = new this.$ethers.Contract(this.contractAddress, abi, signer);
      console.log(this.currentContract);
    },
    getList: async function () {
      console.log('getList');
      try {
        const myList = await this.currentContract.getBookList();
        const nel = myList[0].length;
        console.log('nel : ' + nel);
        this.bookList.length = 0;
        if (nel > 0) {
          for (let i=0; i< nel; i++) {
            const abook = {
              'isbn' : myList[0][i],
              'title' : myList[1][i],
              'author' : myList[2][i],
              'borrower' : myList[3][i]};
            this.bookList.push(abook);
          }
        }
        console.log('new length :' + this.bookList.length);
        console.log(this.bookList);
      }
      catch (err) {
        console.log(err);
      }
      
    },
    addBook: async function () {
      console.log("Add book: "+this.new_book.isbn + " " + this.new_book.title + " " + this.new_book.author);
      await this.currentContract.addBook(this.new_book.isbn,
      this.new_book.title,
      this.new_book.author);
      console.log("added?");
    },
  },
  props: {
    msg: String
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
</style>
