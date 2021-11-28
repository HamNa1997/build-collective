<template lang="html">
    <div class="home" v-if="!account">
        <card
        title="User not registred !!"
        subtitle="Follow the link to sign in"
        >
        <router-link to="/" class="explanations">Add a project</router-link>
        
       
        </card>
        </div>
    <div class="home" v-if="account">
        <card
            title="Add a new project"
            subtitile="fill the fields below"
            >
                <form @submit.prevent="signUp">
                        <input
                            type="text"
                            class="input-username"
                            v-model="name"
                            placeholder="Type your project's name here"
                        />
                        <label for="users">Add a contributor : </label>

                        <select name="users" v-on:change="addContributor($event)">
                            <option v-for="user in userlist" :key="user.id" :value="user">{{user}}</option>
                            </select>
                        
                        <input type="text" :value="contributor" disabled="true"/>
    
                        <button @click="addProject">ADD</button>
                         
                </form>
            </card>
    </div>
  
</template>

<script lang="ts">
import { defineComponent, computed,  } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default  defineComponent({
    name:'CreateProject',
    components: { Card ,},
    setup(){
        const store = useStore()
        const address = computed(() => store.state.account.address)
        const contract = computed(() => store.state.contract)
        return { address, contract }

    },
    data(){
        const account = null
        const name = ''
        const userlist = null
        const contributor:string[] = []
        return {account, name, userlist, contributor}
    },
    methods:{
        async addProject(){
            const {contract, name, contributor} = this
            await contract.methods.createProject(name,contributor).send()
            this.name = ''
            this.contributor =[]   
        },
        async addContributor(e: Event){
            
            this.contributor.push((e.target as HTMLInputElement).value)
            
        },

    },
    async mounted(){
        const { address, contract } = this
        const account = await contract.methods.user(address).call()
        if(account.registered) {this.account = account}
        const userlist = await contract.methods.returnUserlist().call()
        this.userlist = userlist


    },

})
</script >

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