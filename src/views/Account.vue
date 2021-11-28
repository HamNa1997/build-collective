<template lang="html">
  <div class="home" v-if="!account">
    <form @submit.prevent>
      <card
        title="Enter your username here"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <input
          type="checkbox"
          id="checkbox"
          v-model="isEntreprise"
        />
        <label for="checkbox"> Entreprise : {{isEntreprise}} </label>
        <input
          type="text"
          class="input-username"
          v-model="username"
          placeholder="Type your username here"
        />
        <input
          type="text"
          class="input-username"
          v-model="entrepriseName"
          :disabled="!isEntreprise"
          v-if="isEntreprise"
          placeholder="Type the entreprise name here"
        />
        <button @click="signUp">SIGN UP</button>
      </card>
    </form>
  </div>
  <div class="home" v-if="account">
    <div class="card-home-wrapper">
      <card
        :title="account.username"
        :subtitle="`${balance} Ξ\t\t${account.balance} Tokens`"
        :gradient="true"
      >
        
        <div class="explanations">
          On your account on the contract, you have
          {{ account.balance }} tokens. If you click
          <button class="button-link" @click="addTokens">here</button>, you can
          add some token to your account. 
        </div>

      </card>
      <card 
        v-if="entreprise"
        title="Entreprise"
        :subtitle="entreprise.name"
        :gradient="true"
        >
      <div class="explanations"> Balance : {{entreprise.Entreprisebalance}}</div>

      </card>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default defineComponent({
  components: { Card },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const contract = computed(() => store.state.contract)
    return { address, contract, balance }
  },
  data() {
    const account = null
    const entreprise = null
    const username = ''
    const isEntreprise = false
    const entrepriseName = ''
    return { account, username, isEntreprise, entrepriseName, entreprise }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      const account = await contract.methods.user(address).call()
      this.account = account
      
      if(account.entreprises){
     
      const entreprise = await contract.methods.entreprise(account.username).call()
      this.entreprise = entreprise
      
      }
    },
    async signUp() {
      const { contract, username, isEntreprise, entrepriseName } = this
      const name = username.trim().replace(/ /g, '_')
      if(!isEntreprise){
      await contract.methods.signUp(name).send()
      console.log('PARTICULIER')
      }
      if(isEntreprise){
      console.log(entrepriseName)
      await contract.methods.signupEntreprise(username,entrepriseName).send()
      console.log('ENTREPRISE')
      }
      await this.updateAccount()
      this.username = ''
      this.isEntreprise = false
      this.entrepriseName = ''
    },
    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    console.log('mounted')
    if (account.registered) 
    {
      this.account = account
      if (account.entreprises) {
        const entreprise = await contract.methods.entreprise(account.username).call()
        this.entreprise = entreprise
      }
    }
  },
})
</script>

<style lang="css" scoped>
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  max-width: 500px;
  margin: auto;
}

.explanations {
  padding: 12px;
}

.button-link {
  display: inline;
  appearance: none;
  border: none;
  background: none;
  color: inherit;
  text-decoration: underline;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  padding: 0;
  margin: 0;
  cursor: pointer;
}

.input-username {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}
</style>
