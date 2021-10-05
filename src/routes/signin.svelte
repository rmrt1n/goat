<script context="module">
  export const laod = async({ session }) => {
    const { user } = session
    if (user && user.guest) return {}
    return {
      status: 302,
      redirect: '/profile'
    }
  }
</script>

<script>
  import { supabase } from '$lib/db'

  let loading = false

  const onSubmit = async (e) => {
    loading = true
    const { error } = await supabase.auth.signIn({ email: e.target.email.value }, { redirectTo: '/profile' })
    if (error) {
      loading = false
      alert(error.message)
    }
  }
</script>

<div class="flex justify-center items-center h-4/5">
  <div class="form-card">
    {#if loading}
      <h3 class="form-title mb-4">Check your inbox</h3>
    {:else}
      <h3 class="form-title">Sign in</h3>
      <p class="form-subtitle">login without passwords with magic link</p>
      <form on:submit|preventDefault={ onSubmit }>
        <input
          required
          class="form-input-text"
          type="email"
          name="email"
          placeholder="Enter your email address to sign in"
        />
        <div class="flex justify-center">
          <button
            disabled={ loading }
            class="form-btn-submit"
            type="submit"
          >
            Sign In
          </button>
        </div>
      </form>
    {/if}
  </div>
</div>
