<template lang="html">
    <div class="home" v-if="!account">
        <card
        title="User not registred !!"
        subtitle="Follow the link to sign in"
        >
        <router-link to="/" class="explanations">SIGN IN</router-link>
       
        </card>
        </div>
    <div class="home" v-if="account">
        <table>
            <tbody>
                <tr>
                    <th>Name</th>
                    <th>Balance</th>
                    <th>Owner</th>
                    <th>Contributors</th>
                    
                    </tr>
                <tr v-for="project in projects" :key="project.id">
                    <td><a href="#" @click="getbounty(project.name);getevent(project.name)">{{project.name}}</a></td>
                    <td>
                        {{project.projectBalance}} Tokens
                    </td>
                    <td>{{project.owner}}</td>
                    <td>
                        <ul v-for="user in project.contributors" :key="user.id">{{user}}</ul>
                        </td>
                </tr>
                <tr>
                    <th>Click on a project to show bounties ! -></th>
                    <div>
                        <ul v-for="bounty in bounties" :key="bounty.id">
                            <li> Description : {{bounty.description}} 
                                <br>
                                Reward : {{bounty.reward}}
                            </li>
                            
                        </ul>
                    </div>
                    
                </tr>
                <tr>
                    <th>Click on a project to display project's timeline -></th>
                    <div>
                        <ul v-for="event in events" :key="event.id">
                            <li>{{event.message1}}   {{event.message2}}
                            </li>
                            
                        </ul>
                    </div>
                    
                </tr>

            </tbody>

        </table>
    </div>
  
</template>

<script lang="ts">
import { defineComponent, computed,  } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'

export default  defineComponent({
    name:'Projects',
    components: { Card },
    setup(){
        const store = useStore()
        const address = computed(() => store.state.account.address)
        const contract = computed(() => store.state.contract)
        return { address, contract }

    },
    data(){
        const account = null
        const projects = null
        const bounties = null
        const events = null
        return {account, projects, bounties, events}
    },
    methods:{
        async getbounty(a:string){
            const{contract,}=this;
            const bounties = await contract.methods.retunbounties(a).call();
            this.bounties=bounties;

        },
        async getevent(a:string){
            const{contract,}=this;
            const events = await contract.methods.retunevents(a).call();
            this.events=events;

        },
        
        
       

    },
    async mounted(){
        const { address, contract,} = this
        const account = await contract.methods.user(address).call()
        if (account.registered) this.account = account
        const projects = await contract.methods.returnProjects().call()
        this.projects = projects;
        const bounties = await contract.methods.retunbounties("test").call();
        this.bounties = bounties;
        

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

table, td {
  border-collapse: collapse;
  border: 10px solid rgb(177, 159, 180);

  width: 100%;
  
}
th{
  padding: 15px;
  text-align: center;
  background-color:rgb(58, 16, 97);

}
td {
  padding: 12px;
  text-align: left;
}


</style>