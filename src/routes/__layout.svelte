<script>
  import { supabase } from '$lib/db';
  import { session } from '$app/stores';
  import { goto } from '$app/navigation';
  import { setAuthCookie, unsetAuthCookie } from '$lib/session';
  import '../tailwind.css';

  supabase.auth.onAuthStateChange(async (event, _session) => {
    if (event !== 'SIGNED_OUT') {
      session.set({ user: _session.user });
      await setAuthCookie(_session);
      goto('/profile');
    } else {
      session.set({ user: { guest: true } });
      await unsetAuthCookie(_session);
      goto('/signin');
    }
  });

  const authenticated = !$session.user && !$session.user.guest;
  /* console.log('session', $session) */
</script>

<nav class="flex justify-between p-4 bg-gray-700 text-white">
  <div>
    <a href="/">GOAT</a>
    <a href="/explore">Explore</a>
    <a href="/about">About</a>
  </div>
  <div>
    {#if authenticated}
      <a href="/">Profile</a>
    {:else}
      <a href="/signin">Sign in</a>
    {/if}
  </div>
</nav>

<slot />
