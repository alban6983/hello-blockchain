import Vue from 'vue'
import ethers from './plugins/ethers'
import App from './App.vue'
import router from './router'

Vue.config.productionTip = false
Vue.use(ethers)

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
