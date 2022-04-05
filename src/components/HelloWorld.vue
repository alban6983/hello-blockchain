<template>
  <div class="hello">
    <div v-if="!currentAccount">
      <button class="primaryButton" @click="connectWallet">Connect Wallet</button>
    </div>
    <div v-if="!currentContract">
      <button class="primaryButton" @click="attachContract">Attach Contract</button>
    </div>
    <h1>{{ msg }}</h1>
    <p>
      For a guide and recipes on how to configure / customize this project,<br>
      check out the
      <a href="https://cli.vuejs.org" target="_blank" rel="noopener">vue-cli documentation</a>.
    </p>
    <h3>Installed CLI Plugins</h3>
    <ul>
      <li><a href="https://github.com/vuejs/vue-cli/tree/dev/packages/%40vue/cli-plugin-babel" target="_blank" rel="noopener">babel</a></li>
      <li><a href="https://github.com/vuejs/vue-cli/tree/dev/packages/%40vue/cli-plugin-router" target="_blank" rel="noopener">router</a></li>
      <li><a href="https://github.com/vuejs/vue-cli/tree/dev/packages/%40vue/cli-plugin-eslint" target="_blank" rel="noopener">eslint</a></li>
    </ul>
    <h3>Essential Links</h3>
    <ul>
      <li><a href="https://vuejs.org" target="_blank" rel="noopener">Core Docs</a></li>
      <li><a href="https://forum.vuejs.org" target="_blank" rel="noopener">Forum</a></li>
      <li><a href="https://chat.vuejs.org" target="_blank" rel="noopener">Community Chat</a></li>
      <li><a href="https://twitter.com/vuejs" target="_blank" rel="noopener">Twitter</a></li>
      <li><a href="https://news.vuejs.org" target="_blank" rel="noopener">News</a></li>
    </ul>
    <h3>Ecosystem</h3>
    <ul>
      <li><a href="https://router.vuejs.org" target="_blank" rel="noopener">vue-router</a></li>
      <li><a href="https://vuex.vuejs.org" target="_blank" rel="noopener">vuex</a></li>
      <li><a href="https://github.com/vuejs/vue-devtools#vue-devtools" target="_blank" rel="noopener">vue-devtools</a></li>
      <li><a href="https://vue-loader.vuejs.org" target="_blank" rel="noopener">vue-loader</a></li>
      <li><a href="https://github.com/vuejs/awesome-vue" target="_blank" rel="noopener">awesome-vue</a></li>
    </ul>
  </div>
</template>

<script>
import Greeter from '../../blockchain/artifacts/contracts/library.sol/Library.json'
export default {
  name: 'HelloWorld',
  data() {
    return {
      currentAccount: null,
      currentContract: null,
      contractAddress: "0x26602893B663eBc1d572c6AC8AF0Fac70d2D298E"
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
      const abi = Greeter.abi;
      // The Contract object
      this.currentContract = new this.$ethers.Contract(this.contractAddress, abi, signer);
      console.log(await this.currentContract.symbol());
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
