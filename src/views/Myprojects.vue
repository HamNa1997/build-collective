<template lang="html">
<div class="home-wrapper">
    <div class="home" v-if="!account">
        <card
        title="User not registred !!"
        subtitle="Follow the link to sign in"
        >
        <router-link to="/" class="explanations">SIGN IN</router-link>
        
       
        </card>
        </div>
    <div class="home" v-if="account">
        <card v-for="project in projects" :key="project.id"
            title="Project"
            :subtitle="project.name"
           
            >
            Balance : {{project.projectBalance}} Tokens.<br>
            <ul>Add a Bounty
            
                <li><input v-model="bounty.desc[project]" type="text" placeholder="Descritpion"/></li>
                <li><input v-model="bounty.reward[project]" type="number" placeholder="Reward"/></li>
                <br>
                <button @click="addbounty(bounty.desc[project],bounty.reward[project],project.name)">ADD</button>

            </ul>
            
        </card>
       
    </div>
</div>
  
</template>

<script lang="ts">
import { defineComponent, computed,  } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default  defineComponent({
    name:'Myprojects',
    components: { Card ,},
    setup(){
        const store = useStore()
        const address = computed(() => store.state.account.address)
        const contract = computed(() => store.state.contract)
        return { address, contract }

    },
    data(){
        const account = null
        const projects = null
        const Descritpion = ''
        const Reward = 0
        
        
        return {account, projects, Descritpion, Reward,
        bounty:{
            desc:[],
            reward:[],
        
        }
        
        
        }
    },
    methods:{
        async addbounty(a:string,b:number,c:string){
            const {address,contract} = this
            console.log(a)
            console.log(b)
            await contract.methods.addBounty(c,a,b).send()
            
            


        }
        


    },
    async mounted(){
        const { address, contract } = this
        const account = await contract.methods.user(address).call()
        if(account.registered) {
            this.account = account
            this.projects = await contract.methods.returnmyProjects().call()
            }
        

        


    },

})
</script >

<style lang="css" scoped>
    .home-wrapper {
        margin: auto 24px auto 24px;
    }
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