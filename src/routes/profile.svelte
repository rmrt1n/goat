<script context="module">
  export const load = async ({ session }) => {
    const { user } = session
    if (user && !user.guest) return { props: { user: user }}
    return {
      status: 302,
      redirect: '/signin'
    }
  }
</script>

<script>
  import { supabase } from '$lib/db'
  import { goto } from '$app/navigation'

  export let user;

  const signOut = async () => {
    await supabase.auth.signOut()
    /* await goto('/signin') */
  }
</script>

<h1>Profile</h1>
<div>{ JSON.stringify(user, 2) }</div>
<button on:click={ signOut }>Sign out</button>
