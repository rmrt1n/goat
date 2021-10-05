import preprocess from 'svelte-preprocess';
import node from '@sveltejs/adapter-node';
/** @type {import('@sveltejs/kit').Config} */

const config = {
  kit: {
    // hydrate the <div id="svelte"> element in src/app.html
    target: '#svelte',
    adapter: node({out: 'build'})
  },

  preprocess: [preprocess({
    postcss: true
  })]
};

export default config;
